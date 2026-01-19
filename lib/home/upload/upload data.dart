import 'package:flutter/material.dart';
import 'package:nsp2026/home/upload/refine.dart';
import 'package:nsp2026/model/finalvoterlist.dart';
import 'package:translator/translator.dart';

import '../../model/votermodel.dart';

class Upload extends StatefulWidget {
  String id ; final data;
  Upload({super.key,required this.id,required this.data});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Convert OCR Text"),
      ),
      body: Column(
        children: [
          on?LinearProgressIndicator(
            color: Colors.red,
          ):SizedBox(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Text("2",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            ),
            title: Text("Paste the OCR Text",style: TextStyle(fontWeight: FontWeight.w800),),
            subtitle: Text("Paste the OCR Text you got from Website. It will be read automatically"),
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: TextFormField(
              controller: name,
              minLines: 12,maxLines: 1000,
              decoration: const InputDecoration(
                labelText: 'Paste the Text from OCR',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        on?Center(child: CircularProgressIndicator(
          color: Colors.red,
        )):(voterList.isEmpty?InkWell(
          onTap: () async {
            try {
              get(true);
              await onParseButtonPressed(name.text);
              get(false);
            } catch (_) {
              get(false);
            }
          },
          child: Container(
            width: w-20,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red
            ),
            child: Center(
              child: Text("Start Converting",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
            ),
          ),
        ):Column(
          children: [
            Row(
              children: [
                SizedBox(width: 15,),
                InkWell(
                    onTap: (){
                      voterList=[];
                      setState(() {

                      });
                    },
                    child: Icon(Icons.refresh)),
                Spacer(),
                Text("Total Voters : ${voterList.length}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 19),),
                SizedBox(width: 15,)
              ],
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>VoterListPage(voterList: voterList, id: widget.id,)));
              },
              child: Container(
                width: w-20,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red
                ),
                child: Center(
                  child: Text("Continue",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }
  bool on = false;
  void get(bool t){
    setState(() {
      on=t;
    });
  }
  Future<FinalVoterList> parseFinalVoterRow(
      String row,
      Map<String, String> areaData,
      String consid,
      ) async {
    final parts = row.trim().split(RegExp(r'\s+'));

    int i = 0;

    // 1️⃣ serial number
    final serialNo = int.tryParse(parts[i++]) ?? 0;

    // 2️⃣ house no OR New / न्यू
    String houseNo = parts[i];
    if (houseNo.toLowerCase() == 'new' || houseNo == 'न्यू') {
      houseNo = '0';
      i++;
    } else {
      i++;
    }

    // 3️⃣ find EPIC if exists
    final epicIndex = parts.indexWhere(
          (e) => RegExp(r'^[A-Z]{3,}[A-Z0-9]{4,}$').hasMatch(e),
    );

    late String epicNo;
    late String gender;
    late int age;
    late List<String> nameParts;

    if (epicIndex != -1) {
      // ✅ EPIC EXISTS
      epicNo = parts[epicIndex];
      gender = parts[epicIndex + 1];
      age = int.tryParse(parts[epicIndex + 2]) ?? 0;
      nameParts = parts.sublist(i, epicIndex);
    } else {
      // ❌ EPIC DOES NOT EXIST
      epicNo = '';
      gender = parts[parts.length - 2];
      age = int.tryParse(parts.last) ?? 0;
      nameParts = parts.sublist(i, parts.length - 2);
    }

    // 4️⃣ Hindi name + father
    final name = nameParts.isNotEmpty ? nameParts.first : '';
    final fatherName =
    nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    // 5️⃣ English translations
    final nameEn = await translateSafe(name);
    final fatherNameEn = await translateSafe(fatherName);

    // 6️⃣ Gender mapping
    final genderEn = (gender == 'म' || gender == 'में')
        ? 'F'
        : (gender == 'पु')
        ? 'M'
        : gender;

    return FinalVoterList(
      serialNo: serialNo,
      voterId: serialNo.toString(),
      houseNo: houseNo,

      name: name,
      fatherName: fatherName,
      gender: gender,

      nameEn: nameEn,
      fatherNameEn: fatherNameEn,
      genderEn: genderEn,

      epicNo: epicNo,
      age: age,

      consid: consid,
      jila: areaData['jila'] ?? '',
      vikaskhand: areaData['vikaskhand'] ?? '',
      grampanchayat: areaData['grampanchayat'] ?? '',
      matdankendra: areaData['matdankendra'] ?? '',
      sambawad: areaData['sambawad'] ?? '',
      matdansthal: areaData['matdansthal'] ?? '',
      wardsankya: areaData['wardsankya'] ?? '',
      sammilitjaswagram: areaData['sammilitjaswagram'] ?? '',
    );
  }


  Future<String> translateSafe(String text) async {
    if (text.trim().isEmpty) return text;

    // Skip if already English
    if (!RegExp(r'[\u0900-\u097F]').hasMatch(text)) {
      return text;
    }

    return await translate(text); // your GoogleTranslator function
  }
  Future<String> translate(String input) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(
      input,
      from: 'hi',
      to: 'en',
    );
    return translation.text;
  }
  Future<void> onParseButtonPressed(String rawText) async {
    final lines = rawText
        .trim()
        .split(RegExp(r'\n+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final List<FinalVoterList> result = [];

    for (final line in lines) {
      final voter = await parseFinalVoterRow(
        line,
        widget.data, // area map
        widget.id,   // constituency id
      );
      result.add(voter);
    }

    voterList = result;

    debugPrint("Total voters: ${voterList.length}");
    setState(() {});
  }




  List<FinalVoterList> voterList = [];
  TextEditingController name = .new();



}
