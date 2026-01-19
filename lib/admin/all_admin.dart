import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/add_consitutency.dart';
import 'package:nsp2026/admin/see_all_Admin.dart';
import 'package:nsp2026/login/login.dart';

import '../model/constituency.dart';

class AllAdmin extends StatelessWidget {
  const AllAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Select Admin from Constituency"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("constituency")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Constituency Found"));
          }

          final list = snapshot.data!.docs
              .map((doc) => Constituency.fromJson(
            doc.data() as Map<String, dynamic>,
          ))
              .toList();

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return Consclass(con: c,i: 1,);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (_)=>AddECIConstituency()));
      },child: Icon(Icons.upload_file_rounded,color: Colors.white,),),
    );
  }
}

class Consclass extends StatefulWidget {
  final Constituency con; final int i;
  const Consclass({super.key,required this.con,required this.i});

  @override
  State<Consclass> createState() => _ConsclassState();
}

class _ConsclassState extends State<Consclass> {

  bool on = false; 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(!on){
          setState(() {
            on=true;
          });
        }else{
          if(widget.i==0){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Login(str: widget.con.id,)));
          }else if(widget.i==1){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>SeeAllAdmin(cons: widget.con)));
          }else{
            
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration:on?BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 2)
          ): BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 1, // How much the shadow spreads
                  blurRadius: 3, // How blurred the shadow is
                  offset: const Offset(0, 1), // Changes the position of the shadow (x, y)
                ),
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  subtitle: Text("Unique Id : ${widget.con.id}", style: TextStyle(fontWeight: FontWeight.w300),),
                  title: Text("Constituence : ${widget.con.jila}, ${widget.con.boothNo}, ${widget.con.district}", style: TextStyle(fontWeight: FontWeight.w800),),
                  leading: Image.network("https://static.vecteezy.com/system/resources/previews/021/827/304/non_2x/simple-outline-map-of-uttar-pradesh-is-a-state-of-india-vector.jpg",width: 40,),
                ),
                r("State : ${widget.con.state}", "District : ${widget.con.district}"),
                r("Assembly : ${widget.con.assemblyConstituency}", "Boot No. : ${widget.con.boothNo}"),
                r("Panchayat : ${widget.con.grampanchayat}","Jila : ${widget.con.jila}", ),
                on?SizedBox(height: 12,):SizedBox(),
                on?Container(
                  width: MediaQuery.of(context).size.width-20,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Yes, Select this Constituency",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),),
                      SizedBox(width: 8,),Icon(Icons.arrow_forward,color: Colors.white,),
                    ],
                  ),
                ):SizedBox(),
                on?SizedBox(height: 3,):SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget t(String str)=>Text(str,style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),);
  Widget r(String str1, String str2){
    return Row(
      children: [
        SizedBox(width: 15,),
        Container(
          width: MediaQuery.of(context).size.width/2-10,
          child: t(str1),
        ),
        Container(
          width: MediaQuery.of(context).size.width/2-39,
          child: t(str2),
        )
      ],
    );
  }
}
