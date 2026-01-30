import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RectifySerialOverflow extends StatefulWidget {
  const RectifySerialOverflow({super.key});

  @override
  State<RectifySerialOverflow> createState() => _RectifySerialOverflowState();
}

class _RectifySerialOverflowState extends State<RectifySerialOverflow> {

  final col = FirebaseFirestore.instance.collection('NSP1768802521725373');

  static const int maxSerialAllowed = 8387; // 🔒 HARD SAFETY LIMIT


  Future<void> safeDelete(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final serial = int.tryParse(data['serialNo'].toString()) ?? 0;

    // 🔐 DOUBLE SAFETY CHECK
    if (serial <= maxSerialAllowed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ सुरक्षा जाँच विफल: SerialNo सीमा के अंदर है")),
      );
      return;
    }

    // 🔥 FINAL CONFIRMATION DIALOG
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("⚠️ Confirm Deletion"),
        content: Text(
          "This record has serialNo = $serial which is > $maxSerialAllowed.\n\n"
              "This record will be permanently deleted.\n\nAre you 100% sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await doc.reference.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🗑️ Deleted serialNo $serial safely")),
        );
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serial Overflow Validator"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: col.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // 🔍 FILTER ONLY SERIAL > 8387
          final overflowDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final serial = int.tryParse(data['serialNo'].toString()) ?? 0;
            return serial > maxSerialAllowed;
          }).toList();

          if (overflowDocs.isEmpty) {
            return const Center(
              child: Text(
                "✅ No serial numbers above 8387",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: overflowDocs.length,
            itemBuilder: (context, i) {
              final doc = overflowDocs[i];
              final data = doc.data() as Map<String, dynamic>;

              final serial = data['serialNo'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  onTap: () => safeDelete(doc),
                  title: Text("${data['name']} (${data['nameEn']})"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Serial No: $serial"),
                      const Text(
                        "⚠️ Serial overflow detected",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      const Text("Long-press to delete (protected action)"),
                    ],
                  ),
                  trailing: const Icon(Icons.warning, color: Colors.orange),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
