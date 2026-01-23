


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/main.dart';

import '../../model/finalvoterlist.dart';

class Rectify extends StatefulWidget {
   Rectify({super.key});

  @override
  State<Rectify> createState() => _RectifyState();
}

class _RectifyState extends State<Rectify> {
  bool showOnlyMissingFlags = false;
  Future<void> bulkNormalizeFlags() async {
    final col = FirebaseFirestore.instance.collection(s1);
    final snap = await col.get();
    final batch = FirebaseFirestore.instance.batch();

    int count = 0;

    const keys = [
      'transliteradone',
      'bool1','bool2','bool3','bool4','bool5',
      'bool6','bool7','bool8','bool9'
    ];

    for (final doc in snap.docs) {
      final data = doc.data();

      bool needsUpdate = false;
      final Map<String, dynamic> updateMap = {};

      for (final key in keys) {
        if (!data.containsKey(key)) {
          updateMap[key] = false;
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        batch.update(doc.reference, updateMap);
        count++;
      }
    }

    if (count > 0) {
      await batch.commit();
    }

    debugPrint("Normalized $count documents with missing flags");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rectify"),
        actions: [
          Switch(
            value: showOnlyMissingFlags,
            onChanged: (v) {
              setState(() => showOnlyMissingFlags = v);
            },
          ),
          Text("Show only docs without flags"),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: bulkNormalizeFlags,
            child: Text("Normalize Missing Fields"),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(s1)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final voters = docs.map((doc) {
            return FinalVoterList.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
          final flagKeys = [
            'transliteradone',
            'bool1','bool2','bool3','bool4','bool5',
            'bool6','bool7','bool8','bool9'
          ];

          final filtered = showOnlyMissingFlags
              ? docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return flagKeys.any((k) => !data.containsKey(k));
          }).toList()
              : docs;
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final data = filtered[i].data() as Map<String, dynamic>;
              final voter = FinalVoterList.fromMap(data);

              return ListTile(
                title: Text(voter.name),
                subtitle: Text(voter.epicNo),
              );
            },
          );
        },
      ),
    );
  }
}
