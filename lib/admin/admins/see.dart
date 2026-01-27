import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/api.dart';
import 'package:translator/translator.dart' show GoogleTranslator;
import 'package:cloud_functions/cloud_functions.dart';

import '../../card/edit_voter.dart';
import '../../model/finalvoterlist.dart';

class Rectify2 extends StatefulWidget {
  const Rectify2({super.key});

  @override
  State<Rectify2> createState() => _Rectify2State();
}

class _Rectify2State extends State<Rectify2> {
  int gindex = 0;
  String id = "NSP1768802521725373";

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Rectify Data")),
      body: Column(
        children: [
          Container(
            height: 50,
            width: w,
            child: ListView.builder(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      gindex = index;
                    });
                  },
                  child: Container(
                    width: w / 4,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blue,
                        width: gindex == index ? 2 : 0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          list[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: on,
                child: Container(
                  width: w / 2 - 10,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: !ison ? Colors.blue : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: on,
                child: Container(
                  width: w / 2 - 10,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: ison ? Colors.blue : Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        'Yes, Done ',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(id).where("${list2[gindex]}",isEqualTo: ison)
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
          ),
        ],
      ),
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
        onLongPress:update_based_on_param,
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
                            translate(false);
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
                            translate(true);
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

  void translate(bool b)async{
    try {
      String name = await usetranslate(b, widget.v.name);
      String fname = await usetranslate(b, widget.v.fatherName);

      print("===================================================>");
      print(name);
      print(fname);

      if (name != "NA"&& fname != "NA") {
        await FirebaseFirestore.instance.collection(widget.id).doc(
            widget.v.voterId).update({
          "nameEn": name,
          "fatherNameEn":fname,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successful"),
          ),
        );
      }else if(fname!="NA"){
        await FirebaseFirestore.instance.collection(widget.id).doc(
            widget.v.voterId).update({
          "fatherNameEn":fname,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successful"),
          ),
        );
      }else if(name!="NA"){
        await FirebaseFirestore.instance.collection(widget.id).doc(
            widget.v.voterId).update({
          "nameEn": name,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successful"),
          ),
        );
      }

    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error $e"),
        ),
      );
    }
  }

  Future<String> usetranslate(bool b,String input) async {
    if(b){
      if (input.trim().isEmpty) {
        print("❌ Empty input blocked");
        return "NA";
      }
      try{
        print(input);
        final HttpsCallable transliterateFn =
        FirebaseFunctions.instanceFor(region: "us-central1")
            .httpsCallable("transliterate");
        final result = await transliterateFn.call({
          "text": input,
        });
        print("-----------");
        print(result);
        return result.data["output"];

        final dio = Dio();
        final response = await dio.post(
          "https://translation.googleapis.com/v3/projects/nsp2026/locations/global:translateText",
          options: Options(
            headers: {
              "Authorization": "Bearer ${Api.googleapi}",
              "Content-Type": "application/json",
            },
          ),
          data: {
            "contents": [input],
            "source_language_code": "hi",
            "target_language_code": "en",
            "mime_type": "text/plain",
            "transliteration_config": {
              "enable": true
            }
          },
        );
        print("-------------------------------------------->");
        print(response.statusCode);
        print(response.statusMessage);
        final text = response.data["translations"][0]["transliteratedText"];
        print(text);
        print(text);
        print("-------------------------------------------->");
        return text;
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
          ),
        );
        print(e);

        return "NA";
      }
    }else{
      try{
          final translator = GoogleTranslator();
          final translation = await translator.translate(
            input,
            from: 'hi',
            to: 'en',
          );
          return translation.text;
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error $e"),
          ),
        );
        return "NA";
      }
    }
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
