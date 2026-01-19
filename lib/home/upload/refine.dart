import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/main.dart';
import 'package:nsp2026/model/finalvoterlist.dart';
import 'package:nsp2026/model/votermodel.dart';
import 'package:translator/translator.dart';

class VoterListPage extends StatefulWidget {
  final List<FinalVoterList> voterList;
  final String id;

  const VoterListPage({
    super.key,
    required this.voterList, required this.id
  });

  @override
  State<VoterListPage> createState() => _VoterListPageState();
}

class _VoterListPageState extends State<VoterListPage> {

  void _editVoter(int index) async {
    final updated = await showDialog<FinalVoterList>(
      context: context,
      builder: (_) => EditVoterDialog(voter: widget.voterList[index]),
    );

    if (updated != null) {
      setState(() {
        widget.voterList[index] = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Voters (${widget.voterList.length})'),
      ),
      body: ListView.builder(
        itemCount: widget.voterList.length,
        itemBuilder: (context, index) {
          final v = widget.voterList[index];
          if (index == 0) {
            return Column(
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    width: w - 10,
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Global Data",
                            style: TextStyle(fontWeight: FontWeight.w700),),
                          Row(
                            children: [
                              Container(
                                  width: w / 2 - 20,
                                  child: Text("Jila : ${v.jila}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11),)),
                              Text("VikashKhand : ${v.vikaskhand}",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 11),),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Grampanchayat : ${v.grampanchayat}",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 11),),
                              SizedBox(width: 10,),
                              Text("Matdatakendra : ${v.matdankendra}",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 11),),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: w / 2 - 50,
                                  child: Text("Sambawad : ${v.sambawad}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11),)),
                              Text("Matdansthal : ${v.matdansthal}",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 11),),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  width: w / 2 - 50,
                                  child: Text("Wardansankyha : ${v.wardsankya}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11),)),
                              Text("Sammilitjaswagram : ${v.sammilitjaswagram}",
                                style: TextStyle(fontWeight: FontWeight.w700,
                                    fontSize: 11),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text((index + 1).toString(),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight
                            .w700, color: Colors.white),),
                    ),
                    title: Text('${v.name} / ${v.nameEn} (${v.age})'),
                    subtitle: Text(
                      'House: ${v.houseNo}\n'
                          'Father: ${v.fatherName} / ${v.fatherNameEn}\n'
                          'EPIC: ${v.epicNo} | ${v.gender} / ${v.genderEn}',
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editVoter(index),
                    ),
                  ),
                ),
              ],
            );
          }
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text((index + 1).toString(), style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),),
              ),
              title: Text('${v.name} / ${v.nameEn} (${v.age})'),
              subtitle: Text(
                'House: ${v.houseNo}\n'
                    'Father: ${v.fatherName} / ${v.fatherNameEn}\n'
                    'EPIC: ${v.epicNo} | ${v.gender} / ${v.genderEn}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editVoter(index),
              ),
            ),
          );
        },
      ),
      persistentFooterButtons: [
        on
            ? Center(child: CircularProgressIndicator(color: Colors.red,))
            : InkWell(
          onTap: () async {
            try {
              setState(() {
                on = true;
              });
              for (var voter in widget.voterList) {
                try {
                  await FirebaseFirestore.instance
                      .collection(widget.id)
                      .doc(voter.voterId)
                      .set(voter.toMap());
                } catch (e) {
                  await FirebaseFirestore.instance
                      .collection(widget.id)
                      .doc(voter.voterId)
                      .update(voter.toMap());
                }
              }
              setState(() {
                on = false;
              });
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => MyHomePage(title: "")));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All voters saved successfully')),
              );
            } catch (e) {
              setState(() {
                on = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${e}')),
              );
              print(e);
            }
          },
          child: Container(
            width: w - 20,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red
            ),
            child: Center(
              child: Text("Continue", style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.white),),
            ),
          ),
        ),
      ],
    );
  }

  bool on = false;

  Future<String> translate(String input) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(
      input,
      from: 'hi',
      to: 'en',
    );
    return translation.text;
  }

}

class EditVoterDialog extends StatefulWidget {
  final FinalVoterList voter;

  const EditVoterDialog({super.key, required this.voter});

  @override
  State<EditVoterDialog> createState() => _EditVoterDialogState();
}

class _EditVoterDialogState extends State<EditVoterDialog> {
  late TextEditingController houseC;
  late TextEditingController nameC;
  late TextEditingController nameEnC;
  late TextEditingController fatherC;
  late TextEditingController fatherEnC;
  late TextEditingController epicC;
  late TextEditingController genderC;
  late TextEditingController genderEnC;
  late TextEditingController ageC;

  @override
  void initState() {
    super.initState();
    houseC = TextEditingController(text: widget.voter.houseNo);
    nameC = TextEditingController(text: widget.voter.name);
    nameEnC = TextEditingController(text: widget.voter.nameEn);
    fatherC = TextEditingController(text: widget.voter.fatherName);
    fatherEnC = TextEditingController(text: widget.voter.fatherNameEn);
    epicC = TextEditingController(text: widget.voter.epicNo);
    genderC = TextEditingController(text: widget.voter.gender);
    genderEnC = TextEditingController(text: widget.voter.genderEn);
    ageC = TextEditingController(text: widget.voter.age.toString());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Voter'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _field('House No', houseC),
            _field('Name (Hindi)', nameC),
            _field('Name (English)', nameEnC),
            _field('Father Name (Hindi)', fatherC),
            _field('Father Name (English)', fatherEnC),
            _field('EPIC', epicC),
            _field('Gender (Hindi)', genderC),
            _field('Gender (English)', genderEnC),
            _field('Age', ageC, isNumber: true),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              FinalVoterList(
                serialNo: widget.voter.serialNo,
                voterId: widget.voter.voterId,
                houseNo: houseC.text.trim(),

                name: nameC.text.trim(),
                fatherName: fatherC.text.trim(),
                gender: genderC.text.trim(),

                nameEn: nameEnC.text.trim(),
                fatherNameEn: fatherEnC.text.trim(),
                genderEn: genderEnC.text.trim(),

                epicNo: epicC.text.trim(),
                age: int.tryParse(ageC.text) ?? widget.voter.age,

                // keep constituency data untouched
                consid: widget.voter.consid,
                jila: widget.voter.jila,
                vikaskhand: widget.voter.vikaskhand,
                grampanchayat: widget.voter.grampanchayat,
                matdankendra: widget.voter.matdankendra,
                sambawad: widget.voter.sambawad,
                matdansthal: widget.voter.matdansthal,
                wardsankya: widget.voter.wardsankya,
                sammilitjaswagram: widget.voter.sammilitjaswagram,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _field(String label,
      TextEditingController c, {
        bool isNumber = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: c,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
