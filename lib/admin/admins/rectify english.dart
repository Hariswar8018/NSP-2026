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
            child: const Text("Update All"),
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
                trailing: const Icon(Icons.pending, color: Colors.orange),
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

    return toTitleCase(raw); // 👈 formatting here
  }
  Future<void> updateAllEnglishNames() async {
    final snap = await col
        .where('transliteradone', isEqualTo: false)
        .get();

    for (final doc in snap.docs) {
      final data = doc.data();

      final nameHindi = data['name'] ?? '';
      final fatherHindi = data['fatherName'] ?? '';

      if (nameHindi.toString().isEmpty && fatherHindi.toString().isEmpty) continue;

      final nameEn = nameHindi.toString().isNotEmpty
          ? await hindiToRomanFormatted(nameHindi)
          : '';

      final fatherEn = fatherHindi.toString().isNotEmpty
          ? await hindiToRomanFormatted(fatherHindi)
          : '';

      await doc.reference.update({
        'nameEn': nameEn,
        'fatherNameEn': fatherEn,
        'transliteradone': true,
      });
    }

    debugPrint("✅ Transliteration completed for all pending records");
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
