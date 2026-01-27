import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home/init.dart';
import '../model/finalvoterlist.dart' show FinalVoterList;
class EditVoterPage extends StatefulWidget {
  final FinalVoterList voter;
  final String collectionId; // Firestore collection

  const EditVoterPage({
    super.key,
    required this.voter,
    required this.collectionId,
  });

  @override
  State<EditVoterPage> createState() => _EditVoterPageState();
}

class _EditVoterPageState extends State<EditVoterPage> {
  late TextEditingController houseC;
  late TextEditingController nameC;
  late TextEditingController fatherC;
  late TextEditingController genderC;
  late TextEditingController ageC;
  late TextEditingController epicC;
  late TextEditingController nameEnC;
  late TextEditingController fatherEnC;
  @override
  void initState() {

    super.initState();
    final v = widget.voter;

    houseC = TextEditingController(text: v.houseNo);
    nameC = TextEditingController(text: v.name);
    fatherC = TextEditingController(text: v.fatherName);
    genderC = TextEditingController(text: v.gender);
    ageC = TextEditingController(text: v.age.toString());
    epicC = TextEditingController(text: v.epicNo);
    nameEnC = TextEditingController(text: v.nameEn);
    fatherEnC = TextEditingController(text: v.fatherNameEn);
  }

  @override
  void dispose() {
    houseC.dispose();
    nameC.dispose();
    fatherC.dispose();
    genderC.dispose();
    ageC.dispose();
    epicC.dispose();
    super.dispose();
  }

  Widget editField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: const Text("Edit Voter",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onLongPress: () async {
                await FirebaseFirestore.instance
                    .collection(widget.collectionId)
                    .doc(widget.voter.voterId)
                    .delete();
                Navigator.pop(context);
              },
              onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            editField(label: "House No", controller: houseC),
            editField(label: "Name (Hindi)", controller: nameC),
            editField(label: "Father Name (Hindi)", controller: fatherC),
            editField(label: "Name (English)", controller: nameEnC),
            editField(label: "Father Name (English)", controller: fatherEnC),
            editField(label: "Gender (म / पु)", controller: genderC),
            editField(
              label: "Age",
              controller: ageC,
              keyboardType: TextInputType.number,
            ),
            editField(label: "EPIC No", controller: epicC),

            const SizedBox(height: 20),
          ],
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: _updateVoter,
            child: const Text(
              "Update Voter",
              style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> _updateVoter() async {
    try {
      final updatedMap = widget.voter.toMap()
        ..addAll({
          'houseNo': houseC.text.trim(),
          'name': nameC.text.trim(),
          'fatherName': fatherC.text.trim(),
          'gender': genderC.text.trim(),
          'age': int.tryParse(ageC.text.trim()) ?? widget.voter.age,
          'epicNo': epicC.text.trim(),
          "nameEn":nameEnC.text.trim(),
          "fatherNameEn":fatherEnC.text.trim(),
        });

      await FirebaseFirestore.instance
          .collection(widget.collectionId)
          .doc(widget.voter.voterId)
          .update(updatedMap);

      Navigator.pop(context, true); // success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update failed: $e")),
      );
    }
  }

}

