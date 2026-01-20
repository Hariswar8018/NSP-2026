import 'package:flutter/material.dart';

import '../card/final_voter_receipt.dart';
import '../model/finalvoterlist.dart' show FinalVoterList;

class AllVoters extends StatefulWidget {
  final String id;
  const AllVoters({super.key,required this.list,required this.id});
  final List<FinalVoterList> list;
  @override
  State<AllVoters> createState() => _AllVotersState();
}

class _AllVotersState extends State<AllVoters> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        title: Text("All Voters",style: TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          final v = widget.list[index];

          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoterReceiptPage(voter: v, id: widget.id,),
                ),
              );
            },
            child: Padding(
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
            ),
          );
        },
      ),
    );
  }
}
