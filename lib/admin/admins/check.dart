import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/admins/see.dart';

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
        stream: col.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          // 🔥 Filter only multi-word Hindi names
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
class CardVoter extends StatefulWidget {
  final FinalVoterList v;

  int yes;
  String id; bool tobetrue;

  CardVoter({super.key, required this.v, required this.id, required this.yes,required this.tobetrue});

  @override
  State<CardVoter> createState() => _CardVoterState();
}

class _CardVoterState extends State<CardVoter> {

  update_based_on_param() async {
    await FirebaseFirestore.instance.collection(widget.id).doc(widget.v.voterId).update({
      "${list2[widget.yes]}":widget.tobetrue,
    });
  }
  List<String> list2 = [
    "bool1",
    'transliteradone',
    "bool2",
    "bool3",
    "bool4",
    "bool5",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EditVoterPage(voter: widget.v, collectionId: widget.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: ValueListenableBuilder<AdaptiveThemeMode>(
          valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
          builder: (context, mode, _) {
            final isLight = mode == AdaptiveThemeMode.light;
            return Container(
              height: widget.yes==1?230:150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade50, width: 0.5),
                color: isLight ? Color(0xffF5F5F5) : Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 8), // X, Y
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              end: Alignment.topCenter,
                              begin: Alignment.bottomCenter,
                              colors: [
                                Colors.yellow,
                                Colors.orangeAccent,
                                Colors.yellow,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.v.voterId,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.v.epicNo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 9),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.yellow,
                                        Colors.orangeAccent,
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "वार्ड संख्या : " + widget.v.wardsankya,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Name: ${widget.v.name} ( ${widget.v.nameEn} )",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "${widget.v.gender}/${widget.v.genderEn[0]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.work),
                        Text(
                          " Father: ${widget.v.fatherName} (${widget.v.fatherNameEn})",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.home),
                        Text(" House: ${widget.v.houseNo}"),
                        const SizedBox(width: 12),
                        const Icon(Icons.person),
                        Text(" Age: ${widget.v.age}"),
                      ],
                    ),
                    Container(
                      height: 30,
                      child:ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return c(index,back(index) );
                        },
                      ),
                    ),
                    widget.yes==1?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: (){
                          },
                          child: Container(
                            width: w/2-20,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text("Offline Transliterate",style: TextStyle(
                                color: Colors.white,fontWeight: FontWeight.w900),)),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                          },
                          child: Container(
                            width: w/2-20,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text("Online Transliterate",style: TextStyle(
                                color: Colors.white,fontWeight: FontWeight.w900),)),
                          ),
                        ),
                      ],
                    ):SizedBox()
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool back(int i){
    if(i ==0){
      return widget.v.bool1;
    }if(i ==1){
      return widget.v.transliteradone;
    }if(i ==2){
      return widget.v.bool2;
    }if(i ==3){
      return widget.v.bool3;
    }else{
      return widget.v.bool4;
    }
  }
  Widget c(int s, bool boo)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Container(
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 1),
        child: Row(
          children: [
            Text(list[s]+" : ",style: TextStyle(fontSize: 10,color: Colors.black),),
            Text(boo?"YES":"NO",style: TextStyle(fontSize: 10,color: Colors.black),),
            boo?Icon(Icons.verified,color: Colors.green,size: 10,):Icon(Icons.close,size: 10,color: Colors.red,)
          ],
        ),
      ),
    ),
  );
  List<String> list = [
    'Name',
    'Translate',
    'Wards',
    "Other",
    "Confirm",
  ];
}
