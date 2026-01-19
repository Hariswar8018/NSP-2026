import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/home/upload/scan.dart';
import 'package:nsp2026/home/upload/upload%20data.dart';

import '../admin/view/add_view.dart';
import '../model/finalvoterlist.dart';

class Home extends StatefulWidget {
  final String id;final List<FinalVoterList> list;
  const Home({super.key, required this.id,required this.list});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<FinalVoterList> allVoters;
  List<FinalVoterList> filteredVoters = [];

  @override
  void initState() {
    super.initState();
    allVoters = widget.list;
    filteredVoters = widget.list;
  }

  void applyFilter() {
    final voterIdQuery = voterid.text.trim().toLowerCase();
    final nameQuery = name.text.trim().toLowerCase();
    final fatherQuery = father.text.trim().toLowerCase();
    final ageQuery = age.text.trim().toLowerCase();
    final genderQuery = gender.text.trim().toLowerCase();
    final houseQuery = house.text.trim().toLowerCase();

    // area queries
    final jilaQ = jilaC.text.trim().toLowerCase();
    final vikaskhandQ = vikaskhandC.text.trim().toLowerCase();
    final grampanchayatQ = grampanchayatC.text.trim().toLowerCase();
    final matdankendraQ = matdankendraC.text.trim().toLowerCase();
    final sambawadQ = sambawadC.text.trim().toLowerCase();
    final matdansthalQ = matdansthalC.text.trim().toLowerCase();
    final wardsankyaQ = wardsankyaC.text.trim().toLowerCase();
    final sammilitjaswagramQ =
    sammilitjaswagramC.text.trim().toLowerCase();

    filteredVoters = allVoters.where((v) {
      bool match = true;

      // 🔹 voter id / epic
      if (voterIdQuery.isNotEmpty) {
        match &= v.epicNo.toLowerCase().contains(voterIdQuery);
      }

      // 🔹 NAME SEARCH (Hindi vs English)
      if (nameQuery.isNotEmpty) {
        match &= hindi
            ? v.name.toLowerCase().contains(nameQuery)
            : v.nameEn.toLowerCase().contains(nameQuery);
      }

      if (fatherQuery.isNotEmpty) {
        match &= hindi
            ? v.fatherName.toLowerCase().contains(fatherQuery)
            : v.fatherNameEn.toLowerCase().contains(fatherQuery);
      }

      // 🔹 other filters
      if (ageQuery.isNotEmpty) {
        match &= v.age.toString().contains(ageQuery);
      }
      if (genderQuery.isNotEmpty) {
        match &= v.genderEn.toLowerCase().contains(genderQuery);
      }
      if (houseQuery.isNotEmpty) {
        match &= v.houseNo.toLowerCase().contains(houseQuery);
      }

      // 🔹 AREA FILTERS
      if (jilaQ.isNotEmpty) {
        match &= v.jila.toLowerCase().contains(jilaQ);
      }
      if (vikaskhandQ.isNotEmpty) {
        match &= v.vikaskhand.toLowerCase().contains(vikaskhandQ);
      }
      if (grampanchayatQ.isNotEmpty) {
        match &= v.grampanchayat.toLowerCase().contains(grampanchayatQ);
      }
      if (matdankendraQ.isNotEmpty) {
        match &= v.matdankendra.toLowerCase().contains(matdankendraQ);
      }
      if (sambawadQ.isNotEmpty) {
        match &= v.sambawad.toLowerCase().contains(sambawadQ);
      }
      if (matdansthalQ.isNotEmpty) {
        match &= v.matdansthal.toLowerCase().contains(matdansthalQ);
      }
      if (wardsankyaQ.isNotEmpty) {
        match &= v.wardsankya.toLowerCase().contains(wardsankyaQ);
      }
      if (sammilitjaswagramQ.isNotEmpty) {
        match &= v.sammilitjaswagram
            .toLowerCase()
            .contains(sammilitjaswagramQ);
      }

      return match;
    }).toList();

    // 🔹 OPTIONAL: SORT (hierarchy → serial)
    filteredVoters.sort((a, b) {
      int c;
      c = a.jila.compareTo(b.jila);
      if (c != 0) return c;

      c = a.vikaskhand.compareTo(b.vikaskhand);
      if (c != 0) return c;

      c = a.grampanchayat.compareTo(b.grampanchayat);
      if (c != 0) return c;

      c = a.matdankendra.compareTo(b.matdankendra);
      if (c != 0) return c;

      return a.serialNo.compareTo(b.serialNo);
    });

    setState(() {});
  }

  bool hindi = true, b2=false, on = false;

  Widget r(double w, String name, String name2 , TextEditingController c1, TextEditingController c2){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            String str = await Navigator.push(context, MaterialPageRoute(builder: (_)=>
                ViewTextListPage(
              consid: widget.id, village: name,
            )));
            setState(() {
              c1.text = str;
            });
          },
          child: Container(
            width:w/2-11,height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              enabled: false,
              controller: c1,
              decoration: InputDecoration(
                labelText: name.substring(0,1).toUpperCase()+name.substring(1),
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            String str = await Navigator.push(context, MaterialPageRoute(builder: (_)=>
                ViewTextListPage(
                  consid: widget.id, village: name2,
                )));
            setState(() {
              c2.text = str;
            });
          },
          child: Container(
            width:w/2-11,height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              readOnly: true,
              controller: c2,
              decoration: InputDecoration(
                labelText: name2.substring(0,1).toUpperCase()+name2.substring(1),
                enabled: false,
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          on?Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: w-90,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    child: Center(child: Text(" 🔍  ︎Click on Down Button to Search...",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 17),)),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        on=!on;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color:  Colors.orange,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(
                          child: Icon(Icons.arrow_downward_rounded)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ):Center(
            child: Container(
              width: w-15,height: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,width: 3
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  b2?r(w,  "jila", "vikaskhand", jilaC, vikaskhandC):
                  Container(
                    constraints:  BoxConstraints(
                      maxWidth: w-30,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: TextFormField(
                      onSaved: (_) => applyFilter(),
                      controller: name,
                      decoration:  InputDecoration(
                        labelText:hindi?"व्यक्ति का नाम": 'Name of Electoral',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  b2?r(w,  "grampanchayat", "matdankendra", grampanchayatC, matdankendraC):Container(
                    constraints:  BoxConstraints(
                      maxWidth: w-30,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: TextFormField(
                      onSaved: (_) => applyFilter(),
                      controller: father,
                      decoration: InputDecoration(
                        labelText:hindi?'व्यक्ति के पिता/पति/आदि का नाम': 'Parent Name ',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  b2?r(w,  "sambawad", "matdansthal", sambawadC, matdansthalC):Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width:w/3-5,height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: TextFormField(
                          onSaved: (_) => applyFilter(),
                          controller: house,
                          decoration: const InputDecoration(
                            labelText: 'House ',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width:w/3-25,height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: TextFormField(
                          onSaved: (_) => applyFilter(),
                          controller: gender,
                          decoration: const InputDecoration(
                            labelText: 'M/F',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        width:w/3-5,height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: TextFormField(
                          onSaved: (_) => applyFilter(),
                          controller: age,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  b2?r(w,  "wardsankya", "sammilitjaswagram", wardsankyaC, sammilitjaswagramC):Container(
                    constraints:  BoxConstraints(
                      maxWidth: w-30,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: TextFormField(
                      onFieldSubmitted: (_) => applyFilter(),
                      controller: voterid,
                      decoration: const InputDecoration(
                        labelText: 'Voter ID',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap:applyFilter,
                        child: Container(
                          width: w/2-25,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3)
                          ),
                          child: Center(child: Text("Search 🔍",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17),)),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            hindi=!hindi;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: hindi?Colors.yellow: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Text(hindi?"अ":"A",style: TextStyle(
                                color: hindi?Colors.black:Colors.white,
                                fontWeight: FontWeight.w900,fontSize: 23),),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            b2=!b2;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: !b2?Colors.blue.shade200: Colors.pinkAccent.shade200,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Text(!b2?"1":"2",style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,fontSize: 23),),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            on=!on;
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color:  Colors.orange,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Icon(Icons.arrow_upward)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
          Flexible(
            child: filteredVoters.isEmpty
                ? const Center(
              child: Text("No Voter Id for this Area with required Parameter"),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredVoters.length,
              itemBuilder: (context, index) {
                final v = filteredVoters[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Text(
                                  v.voterId,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.epicNo,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Name: ${v.name} ( ${v.nameEn} )",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "${v.gender}/${v.genderEn[0]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.work),
                              Text(
                                " Father: ${v.fatherName} (${v.fatherNameEn})",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.home),
                              Text(" House: ${v.houseNo}"),
                              const SizedBox(width: 12),
                              const Icon(Icons.person),
                              Text(" Age: ${v.age}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }

  TextEditingController father = TextEditingController();
  TextEditingController name = .new();
  TextEditingController voterid = .new();

  TextEditingController age = TextEditingController();
  TextEditingController gender = .new();
  TextEditingController house = .new();
  final TextEditingController jilaC = TextEditingController();
  final TextEditingController vikaskhandC = TextEditingController();
  final TextEditingController grampanchayatC = TextEditingController();
  final TextEditingController matdankendraC = TextEditingController();
  final TextEditingController sambawadC = TextEditingController();
  final TextEditingController matdansthalC = TextEditingController();
  final TextEditingController wardsankyaC = TextEditingController();
  final TextEditingController sammilitjaswagramC = TextEditingController();

}
