import 'package:adaptive_theme/adaptive_theme.dart'
    show AdaptiveTheme, AdaptiveThemeMode;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/function/global.dart';
import 'package:nsp2026/home/upload/scan.dart';
import 'package:nsp2026/home/upload/upload%20data.dart';

import '../admin/view/add_view.dart';
import '../card/edit_voter.dart';
import '../card/final_voter_receipt.dart' show VoterReceiptPage;
import '../model/finalvoterlist.dart';

class Home extends StatefulWidget {
  final String id;
  final List<FinalVoterList> list;
  final bool yes;

  const Home({
    super.key,
    required this.id,
    required this.list,
    this.yes = false,
  });

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

  TextEditingController serial = .new();

  void applyFilter() {
    final voterIdQuery = voterid.text.trim().toLowerCase();
    final nameQuery = name.text.trim().toLowerCase();
    final fatherQuery = father.text.trim().toLowerCase();
    final ageQuery = age.text.trim().toLowerCase();
    final genderQuery = gender.text.trim().toLowerCase();
    final houseQuery = house.text.trim().toLowerCase();

    final serialQuery = serial.text.trim().toLowerCase();
    final wardQuery = wardsankyaC.text.trim().toLowerCase();
    final matdansthalQuery = matdansthalC.text.trim().toLowerCase();
    final sammilitQuery =
    sammilitjaswagramC.text.trim().toLowerCase();

    filteredVoters = allVoters.where((v) {
      bool match = true;

      // 🔹 VOTER ID / EPIC
      if (voterIdQuery.isNotEmpty) {
        match &= v.epicNo.toLowerCase().contains(voterIdQuery);
      }

      // 🔹 NAME (Hindi / English)
      if (nameQuery.isNotEmpty) {
        match &= v.name.toLowerCase().contains(nameQuery) ||
            v.nameEn.toLowerCase().contains(nameQuery);
      }

      // 🔹 PARENT NAME (Hindi / English)
      if (fatherQuery.isNotEmpty) {
        match &= v.fatherName.toLowerCase().contains(fatherQuery) ||
            v.fatherNameEn.toLowerCase().contains(fatherQuery);
      }

      // 🔹 HOUSE
      if (houseQuery.isNotEmpty) {
        match &= v.houseNo.toLowerCase().contains(houseQuery);
      }

      // 🔹 GENDER
      if (genderQuery.isNotEmpty) {
        match &= v.genderEn.toLowerCase().contains(genderQuery) ||
            v.gender.toLowerCase().contains(genderQuery);
      }

      // 🔹 AGE
      if (ageQuery.isNotEmpty) {
        match &= v.age.toString().contains(ageQuery);
      }

      // 🔹 SERIAL NUMBER
      if (serialQuery.isNotEmpty) {
        match &= v.serialNo.toString().contains(serialQuery);
      }

      // 🔹 WARD NUMBER
      if (wardQuery.isNotEmpty) {
        match &= v.wardsankya.toLowerCase().contains(wardQuery);
      }

      // 🔹 MATDANSTHAL
      if (matdansthalQuery.isNotEmpty) {
        match &= v.matdansthal.toLowerCase().contains(matdansthalQuery);
      }

      // 🔹 SAMMILIT JASWA GRAM
      if (sammilitQuery.isNotEmpty) {
        match &=
            v.sammilitjaswagram.toLowerCase().contains(sammilitQuery);
      }

      return match;
    }).toList();

    // 🔹 Optional sort (serial number)
    filteredVoters.sort(
          (a, b) => a.serialNo.compareTo(b.serialNo),
    );

    setState(() {});
  }

  bool hindi = true, b2 = false, on = false;

  Widget r(
    double w,
    String name,
    String name2,
    TextEditingController c1,
    TextEditingController c2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
              width: w / 2 - 20,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: TextFormField(
                controller: c1,
                decoration: InputDecoration(
                  labelText:
                      name.substring(0, 1).toUpperCase() + name.substring(1),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
          ),
          Container(
              width: w / 2 - 20,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: TextFormField(
                controller: c2,
                decoration: InputDecoration(
                  labelText:
                      name2.substring(0, 1).toUpperCase() + name2.substring(1),
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget r2(
      double w,
      String name,
      String name2,
      TextEditingController c1,
      TextEditingController c2,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: w / 2 - 20,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: TextFormField(
              controller: c1,
              decoration: InputDecoration(
                labelText:
                name.substring(0, 1).toUpperCase() + name.substring(1),
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            width: w / 2 - 20,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: TextFormField(
              controller: c2,
              decoration: InputDecoration(
                labelText:
                name2.substring(0, 1).toUpperCase() + name2.substring(1),
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          on
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: w - 90,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xff487791),
                                Colors.blue.shade300,
                                Color(0xff203F5B),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 9,
                            ),
                            child: Container(
                              width: w - 80,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 15),
                                  Icon(Icons.search, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text(
                                    "Search",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              on = !on;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(Icons.arrow_downward_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: w - 15,
                    height: 255,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        b2
                            ? Container(
                                constraints: BoxConstraints(maxWidth: w - 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: TextFormField(
                                  onFieldSubmitted: (_) => applyFilter(),
                                  controller: voterid,
                                  decoration: const InputDecoration(
                                    labelText: 'Voter ID',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              )
                            : Container(
                                constraints: BoxConstraints(maxWidth: w - 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: TextFormField(
                                  onSaved: (_) => applyFilter(),
                                  controller: name,
                                  decoration: InputDecoration(
                                    hintText: hindi
                                        ? "व्यक्ति का नाम"
                                        : 'Name of Electoral',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                        b2
                            ? r(
                                w,
                                "serail no",
                                "Ward Sankhya",
                                serial,
                                wardsankyaC,
                              )
                            : Container(
                                constraints: BoxConstraints(maxWidth: w - 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: TextFormField(
                                  onSaved: (_) => applyFilter(),
                                  controller: father,
                                  decoration: InputDecoration(
                                    labelText: hindi
                                        ? 'व्यक्ति के पिता/पति/आदि का नाम'
                                        : 'Parent Name ',
                                    isDense: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                        b2
                            ? r(
                                w,
                                "matdansthal",
                                "sammilitjaswagram",
                          matdansthalC, sammilitjaswagramC,
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: w / 3 - 5,
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
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
                                      width: w / 3 - 25,
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
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
                                      width: w / 3 - 5,
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
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
                              ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: applyFilter,
                                child: Container(
                                  width: w / 2 - 45,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      end: Alignment.topLeft,
                                      begin: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue.shade900,
                                        Colors.lightBlueAccent,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "🔍  Search",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    hindi = !hindi;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.yellowAccent.shade700,
                                        Colors.yellow.shade100,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      hindi ? "अ" : "A",
                                      style: TextStyle(
                                        color: hindi
                                            ? Colors.black
                                            : Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    b2 = !b2;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue.shade700,
                                        Colors.blue.shade100,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      !b2 ? "1" : "2",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 23,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    on = !on;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.orange.shade900,
                                        Colors.orangeAccent.shade100,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.arrow_upward),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
          Flexible(
            child: filteredVoters.isEmpty
                ? const Center(
                    child: Text(
                      "No Voter Id for this Area with required Parameter",
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredVoters.length,
                    itemBuilder: (context, index) {
                      final v = filteredVoters[index];
                      return CardVoter(v: v, id: widget.id, yes: widget.yes);
                    },
                  ),
          ),
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

class CardVoter extends StatefulWidget {
  final FinalVoterList v;

  bool yes;
  String id;

  CardVoter({super.key, required this.v, required this.id, required this.yes});

  @override
  State<CardVoter> createState() => _CardVoterState();
}

class _CardVoterState extends State<CardVoter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.yes) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EditVoterPage(voter: widget.v, collectionId: widget.id),
            ),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VoterReceiptPage(voter: widget.v, id: widget.id),
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
              height: 150,
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
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
