import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/login/login.dart';

import '../admin/all_admin.dart';
import '../model/constituency.dart';

class AllConstituency extends StatefulWidget {
  final bool isedit ;
  const AllConstituency({super.key,this.isedit = false});

  @override
  State<AllConstituency> createState() => _AllConstituencyState();
}

class _AllConstituencyState extends State<AllConstituency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(widget.isedit?"Edit Constituency":"Select Constituency",style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("constituency")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Constituency Found"));
          }

          final list = snapshot.data!.docs
              .map((doc) => Constituency.fromJson(
            doc.data() as Map<String, dynamic>,
          ))
              .toList();

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return Consclass(con: c,i: widget.isedit?3: 0,);
            },
          );
        },
      ),
    );
  }
}

