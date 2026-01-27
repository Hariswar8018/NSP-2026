import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inditrans/inditrans.dart' as inditrans;

class RectifySimple extends StatefulWidget {
  const RectifySimple({super.key});

  @override
  State<RectifySimple> createState() => _RectifySimpleState();
}

class _RectifySimpleState extends State<RectifySimple> {

  final col = FirebaseFirestore.instance.collection('voters');

  Future<String> hindiToRoman(String text) async {
    await inditrans.init();

    return inditrans.transliterate(
      text,
      inditrans.Script.devanagari,
      inditrans.Script.readableLatin,
      inditrans.Option.IgnoreVedicAccents,
    );
  }

  // 🚀 Bulk Update Function
  Future<void> updateAllEnglishNames() async {
    final snap = await col.get();

    for (final doc in snap.docs) {
      final data = doc.data();

      final hindi = data['name_hindi'] ?? '';
      final english = data['name_english'] ?? '';

      if (hindi.toString().isEmpty || english.toString().isNotEmpty) continue;

      final roman = await hindiToRoman(hindi);

      await doc.reference.update({
        'name_english': roman,
        'transliterated': true,
      });
    }

    debugPrint("✅ All Hindi → English transliteration done");
  }

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
        stream: col.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data() as Map<String, dynamic>;

              final hindi = data['name_hindi'] ?? '';
              final english = data['name_english'] ?? '';

              return ListTile(
                title: Text(hindi),
                subtitle: Text(english.isEmpty ? "❌ Not transliterated" : english),
                trailing: Icon(
                  english.isEmpty ? Icons.close : Icons.check,
                  color: english.isEmpty ? Colors.red : Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
