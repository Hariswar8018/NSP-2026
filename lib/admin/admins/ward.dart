import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RectifyWardValidator extends StatefulWidget {
  const RectifyWardValidator({super.key});

  @override
  State<RectifyWardValidator> createState() => _RectifyWardValidatorState();
}

class _RectifyWardValidatorState extends State<RectifyWardValidator> {

  final col = FirebaseFirestore.instance.collection('NSP1768802521725373');

  // ================= WARD RANGES =================
  static const Map<int, List<int>> wardRanges = {
    1:  [1, 805],
    2:  [806, 1541],
    3:  [1542, 1872],
    4:  [1873, 2474],
    5:  [2475, 3125],
    6:  [3126, 3622],
    7:  [3623, 4280],
    8:  [4281, 4807],
    9:  [4808, 5334],
    10: [5335, 6030],
    11: [6031, 6534],
    12: [6535, 6989],
    13: [6990, 7542],
    14: [7543, 7972],
    15: [7973, 99999], // safety upper bound
  };

  // ================= HELPERS =================
  int getCorrectWard(int serialNo) {
    for (final entry in wardRanges.entries) {
      final start = entry.value[0];
      final end = entry.value[1];
      if (serialNo >= start && serialNo <= end) {
        return entry.key;
      }
    }
    return -1;
  }

  bool isWrongWard(int serialNo, String ward) {
    final correct = getCorrectWard(serialNo);
    if (correct == -1) return true;
    return ward != correct.toString();
  }


  Future<void> rectifyWards() async {
    final snap = await col.get();

    int fixed = 0;

    for (final doc in snap.docs) {
      final data = doc.data() as Map<String, dynamic>;

      final serial = int.tryParse(data['serialNo'].toString()) ?? 0;
      final currentWard = (data['wardsankya'] ?? '').toString();

      final correctWard = getCorrectWard(serial);
      if (correctWard == -1) continue;

      if (currentWard != correctWard.toString()) {
        await doc.reference.update({
          'wardsankya': correctWard.toString(),
        });
        fixed++;
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Ward rectification done. Fixed: $fixed records")),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ward Verification Engine"),
        actions: [
          ElevatedButton.icon(
            onPressed: rectifyWards,
            icon: const Icon(Icons.build),
            label: const Text("Fix Wards"),
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

          final wrongDocs = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final serial = int.tryParse(data['serialNo'].toString()) ?? 0;
            final ward = (data['wardsankya'] ?? '').toString();
            return isWrongWard(serial, ward);
          }).toList();

          if (wrongDocs.isEmpty) {
            return const Center(
              child: Text(
                "✅ All ward numbers are correct",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: wrongDocs.length,
            itemBuilder: (context, i) {
              final doc = wrongDocs[i];
              final data = doc.data() as Map<String, dynamic>;

              final serial = data['serialNo'];
              final currentWard = data['wardsankya'];
              final correctWard = getCorrectWard(
                int.tryParse(serial.toString()) ?? 0,
              );
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text("${data['name']} (${data['nameEn']})"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Serial No: $serial"),
                      Text("Current Ward: $currentWard ❌"),
                      Text("Correct Ward: $correctWard ✅"),
                    ],
                  ),
                  trailing: const Icon(Icons.error, color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
