

import 'package:card_loading/card_loading.dart' show CardLoading;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsp2026/home/navigation.dart';

import '../model/finalvoterlist.dart';

class VoterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FinalVoterList>> fetchVoters(String collectionId) async {
    final snap = await _firestore.collection(collectionId).get();

    return snap.docs
        .map((doc) => FinalVoterList.fromMap(
      doc.data() as Map<String, dynamic>,
    ))
        .toList();
  }
}

class InitCla extends StatefulWidget {
  final String id;
  const InitCla({super.key,required this.id});

  @override
  State<InitCla> createState() => _InitClaState();
}

class _InitClaState extends State<InitCla> {
  List<FinalVoterList> allVoters = [];
  List<FinalVoterList> filteredVoters = [];
  bool loading = true;

  final repo = VoterRepository();
  @override
  void initState() {
    super.initState();
    loadVoters();
  }

  Future<void> loadVoters() async {
    allVoters = await repo.fetchVoters(widget.id);
    filteredVoters = allVoters;
    setState(() => on = true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>Navigation(
      id: widget.id, list: filteredVoters,
    )));
  }

  bool on= false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: on?SizedBox():Column(
        children: [
          CardLoading(
            height: 250,
            width: w-20,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            margin: EdgeInsets.only(bottom: 10),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: CardLoading(
                    height: h/6,
                    width: w-10,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                );
              },

            ),
          ),
        ],
      )
    );
  }
}
