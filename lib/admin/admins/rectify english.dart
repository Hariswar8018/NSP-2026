import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inditrans/inditrans.dart' as inditrans;

class RectifySimple extends StatefulWidget {
  const RectifySimple({super.key});

  @override
  State<RectifySimple> createState() => _RectifySimpleState();
}

class _RectifySimpleState extends State<RectifySimple> {

  final col = FirebaseFirestore.instance.collection('NSP1768802521725373');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rectify Transliteration"),
        actions: [
          ElevatedButton(
            onPressed: updateAllEnglishNames,
            child: const Text("Update "),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: col.where('transliteradone', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("✅ All records are transliterated"),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? ''),
                subtitle: Text(data['fatherName'] ?? ''),
                trailing: Text("${docs.length-i} left"),
              );
            },
          );
        },
      ),
    );
  }
  Future<String> hindiToRomanFormatted(String text) async {
    await inditrans.init();
    final raw = inditrans.transliterate(
      text,
      inditrans.Script.devanagari,
      inditrans.Script.readableLatin,
      inditrans.Option.IgnoreVedicAccents,
    );
    return toTitleCase(raw);
  }
  Future<void> updateAllEnglishNames() async {
    final snap = await col
        .where('transliteradone', isEqualTo: false)
        .get();

    final docs = snap.docs;

    if (docs.isEmpty) {
      debugPrint("✅ No pending records to transliterate");
      return;
    }

    const int batchSize = 30;
    int processed = 0;

    for (int i = 0; i < docs.length; i += batchSize) {
      final batch = docs.skip(i).take(batchSize);

      // ================= PARALLEL COMPUTE =================
      final futures = batch.map((doc) async {
        final data = doc.data();

        if (data['transliteradone'] == true) return null;

        final nameHindi = (data['name'] ?? '').toString();
        final fatherHindi = (data['fatherName'] ?? '').toString();

        if (nameHindi.isEmpty && fatherHindi.isEmpty) return null;

        final nameFuture = nameHindi.isNotEmpty
            ? hindiToRomanFormatted(nameHindi)
            : Future.value('');

        final fatherFuture = fatherHindi.isNotEmpty
            ? hindiToRomanFormatted(fatherHindi)
            : Future.value('');

        final results = await Future.wait([nameFuture, fatherFuture]);

        return _BatchUpdateData(
          ref: doc.reference,
          nameEn: results[0],
          fatherNameEn: results[1],
        );
      }).toList();

      final results = await Future.wait(futures);

      // ================= SAFE FIRESTORE BATCH =================
      final writeBatch = FirebaseFirestore.instance.batch();

      for (final r in results) {
        if (r == null) continue;

        writeBatch.update(r.ref, {
          'nameEn': r.nameEn,
          'fatherNameEn': r.fatherNameEn,
          'transliteradone': true,
        });
      }

      await writeBatch.commit(); // 🔥 atomic batch commit

      processed += batch.length;

      debugPrint("⚡ Processed $processed / ${docs.length}");
    }

    debugPrint("✅ FAST transliteration completed safely");
  }

  String toTitleCase(String input) {
    return input
        .toLowerCase()
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

}
class _BatchUpdateData {
  final DocumentReference<Map<String, dynamic>> ref;
  final String nameEn;
  final String fatherNameEn;

  const _BatchUpdateData({
    required this.ref,
    required this.nameEn,
    required this.fatherNameEn,
  });
}
