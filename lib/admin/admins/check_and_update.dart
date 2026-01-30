import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/admins/rectify%20english.dart';
import 'package:nsp2026/api.dart';
import 'package:translator/translator.dart' show GoogleTranslator;
import 'package:cloud_functions/cloud_functions.dart';

import '../../card/edit_voter.dart';
import '../../model/finalvoterlist.dart';

class Rectify3 extends StatefulWidget {
  const Rectify3({super.key});

  @override
  State<Rectify3> createState() => _Rectify3State();
}

class _Rectify3State extends State<Rectify3> {
  int gindex = 0;
  String id = "NSP1768802521725373";

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                title: const Text("Close the App ?"),
                content: const Text("You sure to Close the App"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
          return shouldExit ?? false; // true = allow back
        },
        child: Scaffold(
          appBar: AppBar(title: Text("Rectify Data"),
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>RectifySimple()));
              }, icon: Icon(Icons.update))
            ],),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(id)
                .where("bool9",isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) return const Center(child: Text("No data"));
              final data = docs[0].data() as Map<String, dynamic>;
              final voter = FinalVoterList.fromMap(data);
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final voter = FinalVoterList.fromMap(data);
                  return CardVoter(
                    v: voter,
                    id: id,
                    yes: gindex,
                    tobetrue: !ison,
                  );
                },
              );
            },
          ),
        )
    );
  }

  bool ison = false;

  void on() {
    setState(() {
      ison = !ison;
    });
  }

  List<String> list = [
    'Name Confirm',
    'English Translate',
    'Wards Confirm',
    "Other",
    "Confirm",
  ];
  List<String> list2 = [
    "bool1",
    'transliteradone',
    "bool2",
    "bool3",
    "bool4",
    "bool5",
  ];}


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
              height: widget.yes==1?300:240,
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
                      children: <Widget>[
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
                        InkWell(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance.collection(widget.id).doc(
                                  widget.v.voterId).update({
                                "bool8": true,
                              });
                            }catch(e){
                              print(e);
                            }
                          },
                          child: Container(
                            height: 60,width: 60,
                            color: Colors.black,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        c(0, back(0)),
                        c(2, back(2)),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        c(3, back(3)),
                        c(4, back(4)),
                      ],
                    ),

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
    child: Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque, // IMPORTANT
        onTap: () async {
          try {
            await FirebaseFirestore.instance.collection(widget.id).doc(
                widget.v.voterId).update({
              "${list7[s]}": !boo,
            });
          }catch(e){
            print(e);
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
            child: Row(
              children: [
                Text(list[s]+" : ",style: TextStyle(fontSize: 16,color: Colors.black),),
                Text(boo?"YES":"NO",style: TextStyle(fontSize: 16,color: Colors.black),),
                boo?Icon(Icons.verified,color: Colors.green,size: 16,):Icon(Icons.close,size: 16,color: Colors.red,)
              ],
            ),
          ),
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
  List<String> list7 = [
    "bool1",
    'transliteradone',
    "bool2",
    "bool3",
    "bool4",
    "bool5",
  ];
}
