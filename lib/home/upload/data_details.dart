import 'package:flutter/material.dart';
import 'package:nsp2026/home/upload/upload%20data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/view/add_view.dart';

class AreaInputForm extends StatefulWidget {
 final String id;
  const AreaInputForm({super.key,required this.id});

  @override
  State<AreaInputForm> createState() => _AreaInputFormState();
}

class _AreaInputFormState extends State<AreaInputForm> {
  final TextEditingController jila = TextEditingController();
  final TextEditingController vikaskhand = TextEditingController();
  final TextEditingController grampanchayat = TextEditingController();
  final TextEditingController matdankendra = TextEditingController();
  final TextEditingController sambawad = TextEditingController();
  final TextEditingController matdansthal = TextEditingController();
  final TextEditingController wardsankya = TextEditingController();
  final TextEditingController sammilitjaswagram = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastValues();
  }

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
    super.dispose();
  }

  /// 🔹 Load last saved values
  Future<void> _loadLastValues() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      jila.text = prefs.getString('jila') ?? '';
      vikaskhand.text = prefs.getString('vikaskhand') ?? '';
      grampanchayat.text = prefs.getString('grampanchayat') ?? '';
      matdankendra.text = prefs.getString('matdankendra') ?? '';
      sambawad.text = prefs.getString('sambawad') ?? '';
      matdansthal.text = prefs.getString('matdansthal') ?? '';
      wardsankya.text = prefs.getString('wardsankya') ?? '';
      sammilitjaswagram.text = prefs.getString('sammilitjaswagram') ?? '';
    });
  }

  /// 🔹 Save values
  Future<void> saveValues() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jila', jila.text.trim());
    await prefs.setString('vikaskhand', vikaskhand.text.trim());
    await prefs.setString('grampanchayat', grampanchayat.text.trim());
    await prefs.setString('matdankendra', matdankendra.text.trim());
    await prefs.setString('sambawad', sambawad.text.trim());
    await prefs.setString('matdansthal', matdansthal.text.trim());
    await prefs.setString('wardsankya', wardsankya.text.trim());
    await prefs.setString(
        'sammilitjaswagram', sammilitjaswagram.text.trim());
  }

  Widget _field(double w, String label, TextEditingController controller) {
    return Container(
      constraints: BoxConstraints(maxWidth: w - 20),
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

  Map<String, String> getAreaData() {
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
      appBar: AppBar(
        title: Text('Data Details of User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.yellow,
                child: Text("2",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
              ),
              title: Text("Fill the Voter Global Data"),
              subtitle: Text("Fill the Global Page Data of the User"),
            ),
            SizedBox(height: 20,),
            Icon(Icons.eleven_mp_outlined,color: Colors.blue,size: 35,),
            Text("Important Details",style: TextStyle(fontWeight: FontWeight.w800),),
            _field(w, "Jila", jila),
            contain(w,jila,"jila"),
            _field(w, "Vikaskhand", vikaskhand),
            contain(w,vikaskhand,"vikaskhand"),
            _field(w, "Grampanchayat", grampanchayat),
            contain(w,grampanchayat,"grampanchayat"),
            _field(w, "Matdan Kendra", matdankendra),
            contain(w,matdankendra,"matdankendra"),
            SizedBox(height: 20,),
            Icon(Icons.other_houses,color: Colors.red,size: 35,),
            Text("Other Details",style: TextStyle(fontWeight: FontWeight.w800),),
            _field(w, "Sambawad", sambawad),
            contain(w,sambawad,"sambawad"),
            _field(w, "Matdan Sthal", matdansthal),
            contain(w,matdansthal,"matdansthal"),
            _field(w, "Ward Sankya", wardsankya),
            contain(w,wardsankya,"wardsankya"),
            _field(w, "Sammilit Jaswa Gram", sammilitjaswagram),
            contain(w,sammilitjaswagram,"sammilitjaswagram"),
            const SizedBox(height: 30),
          ],
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            await saveValues();
            final datae = getAreaData();
            debugPrint(datae.toString());
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Upload(id: widget.id, data: datae,)));
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
                Icon(Icons.verified),
                SizedBox(width: 8),
                Text(
                  "Proceed, All Data are Correct",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Widget contain(double w, TextEditingController controller, String name){
    return InkWell(
      onTap: () async {
        String str = await Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewTextListPage(
          consid: widget.id, village: name,
        )));
        setState(() {
          controller.text=str;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 23),
            Container(
              width: w/2+60,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
               color: Colors.red,
              ),
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Text("Add from Constituency Data",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900),),
                  SizedBox(width: 8,), Icon(Icons.arrow_forward,color: Colors.white,)
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
