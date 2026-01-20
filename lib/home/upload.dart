

import 'package:flutter/material.dart';
import 'package:nsp2026/home/init.dart';
import 'package:nsp2026/home/upload/scan.dart';

class Up extends StatefulWidget {
  final String id;
  const Up({super.key,required this.id});

  @override
  State<Up> createState() => _UpState();
}

class _UpState extends State<Up> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Image.asset("assets/images (9).png"),
            ),
          ),
          Text(textAlign: TextAlign.center,"Upload Data for this Constituency",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 22),),
          SizedBox(height: 10,),
          Text(textAlign: TextAlign.center,"Upload New Data or Update Old Voter id for your Constituency",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
          SizedBox(height: 25,),
          InkWell(
            onTap: (){
              if(user2.isuploaddata){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Scan(id: widget.id)));
              }else{
                const snackBar = SnackBar(
                  content: Text('You don\'t have Upload Access. Please Contact Admin'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width-20,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file_rounded),SizedBox(width: 8,),
                  Text("Upload Data Now",style: TextStyle(fontWeight: FontWeight.w700),)
                ],
              ),
            ),
          ),
          SizedBox(height: 65,),
        ],
      ),
    );
  }
}
