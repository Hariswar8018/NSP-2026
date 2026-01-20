import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/constituency.dart';
import '../model/view.dart';

class AddECIConstituency extends StatefulWidget {
  Constituency? cons ;
  AddECIConstituency({super.key,required this.cons});

  @override
  State<AddECIConstituency> createState() => _AddECIConstituencyState();
}

class _AddECIConstituencyState extends State<AddECIConstituency> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController jila = TextEditingController();
  final TextEditingController vikaskhand = TextEditingController();
  final TextEditingController grampanchayat = TextEditingController();
  final TextEditingController matdankendra = TextEditingController();
  final TextEditingController sambawad = TextEditingController();
  final TextEditingController matdansthal = TextEditingController();
  final TextEditingController wardsankya = TextEditingController();
  final TextEditingController sammilitjaswagram = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController assemblyConstituency = TextEditingController();
  final TextEditingController boothNo = TextEditingController();

  void initState(){
    if(widget.cons!=null){
      state.text = widget.cons!.state;
      district.text = widget.cons!.district;
      assemblyConstituency.text = widget.cons!.assemblyConstituency;
      boothNo.text = widget.cons!.boothNo;

      id = widget.cons!.id;

      jila.text = widget.cons!.jila;
      vikaskhand.text = widget.cons!.vikaskhand;
      grampanchayat.text=widget.cons!.grampanchayat;
      matdankendra.text = widget.cons!.matdankendra;

      sambawad.text = widget.cons!.sambawad;
      matdansthal.text = widget.cons!.matdansthal;
      wardsankya.text = widget.cons!.wardsankya;
      sammilitjaswagram.text = widget.cons!.sammilitjaswagram;
    }else{
      id = "NSP" + DateTime.now().microsecondsSinceEpoch.toString();
    }
    setState(() {

    });
  }
   late String id ;
  @override
  void dispose() {
    jila.dispose();
    vikaskhand.dispose();
    grampanchayat.dispose();
    matdankendra.dispose();
    sambawad.dispose();
    matdansthal.dispose();
    wardsankya.dispose();
    sammilitjaswagram.dispose();
    state.dispose();
    district.dispose();
    assemblyConstituency.dispose();
    boothNo.dispose();

    super.dispose();
  }

  Widget _field(double w, String label, TextEditingController controller) {
    return Container(
      constraints: BoxConstraints(maxWidth: w - 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Map<String, String> getFormData() {
    return {
      'jila': jila.text.trim(),
      'vikaskhand': vikaskhand.text.trim(),
      'grampanchayat': grampanchayat.text.trim(),
      'matdankendra': matdankendra.text.trim(),
      'sambawad': sambawad.text.trim(),
      'matdansthal': matdansthal.text.trim(),
      'wardsankya': wardsankya.text.trim(),
      'sammilitjaswagram': sammilitjaswagram.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text(widget.cons==null?"Add Default Constituency":"Edit Constituency")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Icon(Icons.ev_station_rounded),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Constituency Domain",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              ),
              _field(w, "State", state),
              _field(w, "District", district),
              _field(w, "Assembly Constituency", assemblyConstituency),
              _field(w, "Booth No", boothNo),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Icon(Icons.baby_changing_station_sharp),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("District Level Form",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              ),
              _field(w, "Jila", jila),
              _field(w, "Vikaskhand", vikaskhand),
              _field(w, "Grampanchayat", grampanchayat),

              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Icon(Icons.baby_changing_station_sharp),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Default Value ( Optional )",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22),),
              ),
              _field(w, "Matdan Kendra", matdankendra),
              _field(w, "Sambawad", sambawad),
              _field(w, "Matdan Sthal", matdansthal),
              _field(w, "Ward Sankya", wardsankya),
              _field(w, "Sammilit Jaswa Gram", sammilitjaswagram),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            final data = getFormData();
            try {
              final data = toConstituency(id);
              if(widget.cons==null){
                await FirebaseFirestore.instance
                    .collection("constituency")
                    .doc(data.id)
                    .set(data.toJson());
              }else{
                await FirebaseFirestore.instance
                    .collection("constituency")
                    .doc(data.id)
                    .update(data.toJson());
                Navigator.pop(context);
                return ;
              }
              try {
                await given(id, village: "jila", villagename: jila.text.trim());
                await given(
                  id,
                  village: "grampanchayat",
                  villagename: grampanchayat.text.trim(),
                );
                await given(
                  id,
                  village: "sambawad",
                  villagename: sambawad.text.trim(),
                );
                await given(
                  id,
                  village: "vikaskhand",
                  villagename: vikaskhand.text.trim(),
                );
                await given(
                  id,
                  village: "matdankendra",
                  villagename: matdankendra.text.trim(),
                );
                await given(
                  id,
                  village: "matdansthal",
                  villagename: matdansthal.text.trim(),
                );
                await given(
                  id,
                  village: "wardsankya",
                  villagename: wardsankya.text.trim(),
                );
                await given(
                  id,
                  village: "sammilitjaswagram",
                  villagename: sammilitjaswagram.text.trim(),
                );
              } catch (e) {
              } finally {
                Navigator.pop(context);
              }
            } catch (e) {
              final snackBar = SnackBar(
                content: Text('${e}'),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.cons==null?Icon(Icons.add):Icon(Icons.update),
                SizedBox(width: 8),
                Text(
                  widget.cons==null?"Yes, Add this Constituency":"Yes, Edit Now",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> given(
    String id, {
    required String village,
    required String villagename,
  }) async {
    String temporaryid = DateTime.now().microsecondsSinceEpoch.toString();
    final viewText = ViewText(id: temporaryid, name: villagename);
    await FirebaseFirestore.instance
        .collection("constituency")
        .doc(id)
        .collection(village)
        .doc(temporaryid)
        .set(viewText.toJson());
  }

  Constituency toConstituency(String id) {
    return Constituency(
      id: id,
      state: state.text.trim(),
      district: district.text.trim(),
      assemblyConstituency: assemblyConstituency.text.trim(),
      boothNo: boothNo.text.trim(),
      jila: jila.text.trim(),
      vikaskhand: vikaskhand.text.trim(),
      grampanchayat: grampanchayat.text.trim(),
      matdankendra: matdankendra.text.trim(),
      sambawad: sambawad.text.trim(),
      matdansthal: matdansthal.text.trim(),
      wardsankya: wardsankya.text.trim(),
      sammilitjaswagram: sammilitjaswagram.text.trim(),
    );
  }



}
