

import 'package:card_loading/card_loading.dart' show CardLoading;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nsp2026/home/navigation.dart';

import '../function/global.dart';
import '../model/finalvoterlist.dart';
import '../model/user.dart';
import 'package:hive/hive.dart';
import '../model/finalvoterlist.dart';

class VoterCache {

  static Future<void> updateOne(String id, FinalVoterList updated) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');

    final index = box.values.toList().indexWhere(
          (v) => v.voterId == updated.voterId,
    );

    if (index != -1) {
      await box.putAt(index, updated);
    }
  }

  static Future<void> deleteOne(String id, String voterId) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');

    final index = box.values.toList().indexWhere(
          (v) => v.voterId == voterId,
    );

    if (index != -1) {
      await box.deleteAt(index);
    }
  }

  static Future<void> save(String id, List<FinalVoterList> voters) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');
    await box.clear();
    await box.addAll(voters);
  }

  static Future<List<FinalVoterList>> load(String id) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');
    return box.values.toList();
  }

  static Future<bool> exists(String id) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');
    return box.isNotEmpty;
  }

  static Future<void> clear(String id) async {
    final box = await Hive.openBox<FinalVoterList>('voters_$id');
    await box.clear();
  }
}

class VoterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FinalVoterList>> fetchVoters(String collectionId) async {
    final snap = await _firestore.collection(collectionId).get();

    return snap.docs
        .map((doc) => FinalVoterList.fromMap(doc.data() as Map<String, dynamic>,
    ))
        .toList();
  }
  Future<LoginModel?> fetchUser(
      String collectionId,
      String username,
      ) async {
    final snap = await FirebaseFirestore.instance
        .collection(collectionId)
        .doc("logins")
        .collection("logins")
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    return LoginModel.fromMap(
      snap.docs.first.data(),
    );
  }

}
late LoginModel user2 ;
class InitCla extends StatefulWidget {
  final String id; final String username;
  const InitCla({super.key,required this.id,required this.username});

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
  static LoginModel? user1 ;
  Future<void> loadVoters({bool forceFirestore = false}) async {

    // 1️⃣ If NOT forced, try Hive first
    if (!forceFirestore) {
      final hasLocal = await VoterCache.exists(widget.id);

      if (hasLocal) {
        allVoters = await VoterCache.load(widget.id);
        filteredVoters = allVoters;

        CacheState.setHive();   // 🔹 GLOBAL FLAG

        user1 = await repo.fetchUser(widget.id, widget.username);
        user2 = user1!;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Navigation(
              id: widget.id,
              list: filteredVoters,
            ),
          ),
        );
         _refreshFromFirestoreSilently();
        return;
      }
    }

    allVoters = await repo.fetchVoters(widget.id);
    await VoterCache.save(widget.id, allVoters);

    filteredVoters = allVoters;

    CacheState.setFirestore();  // 🔹 GLOBAL FLAG

    user1 = await repo.fetchUser(widget.id, widget.username);
    user2 = user1!;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Navigation(
          id: widget.id,
          list: filteredVoters,
        ),
      ),
    );
  }

  Future<void> _refreshFromFirestoreSilently() async {
    final remote = await repo.fetchVoters(widget.id);
    await VoterCache.save(widget.id, remote);
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
