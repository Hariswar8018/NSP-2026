import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/admins/check_and_update.dart';

import '../../card/edit_voter.dart';
import '../../model/finalvoterlist.dart';

class RectifyMultiWordView extends StatelessWidget {
  final CollectionReference col =
  FirebaseFirestore.instance.collection('NSP1768802521725373');

  RectifyMultiWordView({super.key});

  bool hasMultipleWords(String text) {
    if (text.trim().isEmpty) return false;
    return text.trim().contains(RegExp(r'\s+'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi-word Hindi Names"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: col.where("bool8",isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final filtered = docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['name'] ?? '').toString();
            final father = (data['fatherName'] ?? '').toString();
            return hasMultipleWords(name) || hasMultipleWords(father);
          }).toList();
          if (filtered.isEmpty) {
            return const Center(
              child: Text("✅ No multi-word Hindi names found"),
            );
          }
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, i) {
              final data = filtered[i].data() as Map<String, dynamic>;
              final voter = FinalVoterList.fromMap(data);
              return CardVoter(
                v: voter,
                id: "NSP1768802521725373",
                yes: 0,
                tobetrue: false,
              );
            },
          );
        },
      ),
    );
  }
}

