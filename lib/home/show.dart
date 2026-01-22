import 'package:adaptive_theme/adaptive_theme.dart' show AdaptiveTheme;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nsp2026/extra/all_voters.dart';
import 'package:nsp2026/function/global.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/home/init.dart';
import 'package:nsp2026/home/upload.dart' show Up;
import 'package:nsp2026/login/all_constituency.dart';
import 'package:translator/translator.dart';
import '../admin/all_admin.dart';
import '../admin/view/add_view.dart';
import '../model/finalvoterlist.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Show extends StatefulWidget {
  final List<FinalVoterList> list;
  final String id;
  final void Function(int index) onFallback;
  const Show({super.key, required this.list, required this.id,   required this.onFallback,});

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  VoterStats calculateVoterStats(List<FinalVoterList> voters) {
    int male = 0;
    int female = 0;
    int noEpic = 0;

    final Set<int> serials = {};

    for (final v in voters) {
      if (v.genderEn.toLowerCase() == 'm') male++;
      if (v.genderEn.toLowerCase() == 'f') female++;
      if (v.epicNo.trim().isEmpty || v.voterId.trim().isEmpty) {
        noEpic++;
      }

      serials.add(v.serialNo);
    }

    // find max serial
    final int maxSerial = serials.isEmpty
        ? 0
        : serials.reduce((a, b) => a > b ? a : b);

    // find missing serials
    final List<int> missingSerials = [];
    for (int i = 1; i <= maxSerial; i++) {
      if (!serials.contains(i)) {
        missingSerials.add(i);
      }
    }

    return VoterStats(
      total: voters.length,
      male: male,
      female: female,
      noEpic: noEpic,
      missingSerials: missingSerials,
    );
  }

  void f() {
    final stats = calculateVoterStats(widget.list);

    print("Total voters: ${stats.total}");
    print("Male: ${stats.male}");
    print("Female: ${stats.female}");
    print("No EPIC/VoterId: ${stats.noEpic}");
    print("Missing serials: ${stats.missingSerials}");
    setState(() {
      total = stats.total;
      male = stats.male;
      female = stats.female;
      epic = stats.noEpic;
      my = stats.missingSerials;
    });
  }
  List<int> my = [];
  int total = 0, male = 0, female = 0, epic = 0;


  @override
  void initState() {
    super.initState();
    f();
  }



  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8,),
            CarouselSlider(
              options: CarouselOptions(
                height: 210,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
              items:
                  [
                    "assets/18d61285-e584-42de-9bb0-2d7dee71e7c0.jpg",
                    "assets/53c2814d-4ecd-4733-8d9e-54a2b11b1fb4.jpg",
                    "assets/d245ea8d-260a-4619-b467-197aefc0b6ac.jpg",
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            width: w - 25,
                            height:210,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(7),
                              image: DecorationImage(
                                image: AssetImage(i),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
            SizedBox(height: 8,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: w / 2 ,
                        height: w / 3 + 25,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/voting_hand_with_tricolour-scaled.jpg",
                                width: (w / 3 - 10) - 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("Total Voters",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,color: Colors.black),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text("${total}",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w800,color: Colors.black),),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          c(w,true),
                          SizedBox(height: 4),
                          c(w,false),
                        ],
                      ),
        
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade200
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    You may use ",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  widget.onFallback(1);

                                },
                                child: q(context,"assets/search.gif","Search")),
                            InkWell(
                                onTap: (){
                                  widget.onFallback(2);
                                },
                                child: q(context,"assets/profile.gif","Profile")),
                            InkWell(
                                onTap: (){
                                  Global.launch("https://ayus.dev.xyz");
                                },
                                child: q(context,"assets/support.png","Support")),
                            InkWell(
                                onTap: (){
                                  Global.launch("https://ayus.dev.xyz");
                                },
                                child: q(context,"assets/website.gif","Website")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            my.isEmpty?SizedBox():SizedBox(height: 10,),
            my.isEmpty?SizedBox():user2.isuploaddata?Container(
              width: w-20,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Missing Voters are : ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                    Flexible(child: ListView.builder(
                      itemCount: my.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(child: Text(my[index].toString()+ ",  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800)));
                      },
                    ))
                  ],
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade200
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    SuperAdmin Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>AllVoters(list: widget.list,id: widget.id,)));
                                },
                                child: q(context,"assets/voters.gif","All Voters")),
                            InkWell(
                                onTap: (){
                                  if(Global.check(context)){
                                    return ;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>AllConstituency(isedit: true,)));
                                },
                                child: q(context,"assets/14256604.png","Admin Panel")),
                            InkWell(
                                onTap: () async {
                                  if(Global.check(context)){
                                    return ;
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>EditVoters(id: widget.id, list: widget.list)));

                                },
                                child: q(context,"assets/edit.webp","Edit Voters")),
                            user2.isuploaddata?InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (_)=>Up(id: widget.id,)));;
                                },
                                child: q(context,"assets/upload.gif","Upload")):
                            InkWell(
                                onTap: (){
                                  Global.launch("https://wa.me/917978097489");
                                },
                                child: q(context,"assets/support.png","Support")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            /*Center(
              child: Container(
                width: w-15,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade200
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0,bottom: 15),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("    Constituency Related",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.start,),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q1(context,"assets/jila.jpg","jila"),
                            q1(context,"assets/vikash.jpg","vikaskhand"),
                             q1(context,"assets/grampanchayat.jpg","grampanchayat"),
                            q1(context,"assets/matdankendr.jpg","matdankendra"),
                          ],
                        ),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            q1(context,"assets/matdankendra.jpg","sambawad"),
                            q1(context,"assets/sambawad.jpg","matdansthal"),
                            q1(context,"assets/wardsankya.jpg","wardsankya"),
                            q1(context,"assets/sammilitjaswagram.webp","sammilitjaswagram"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),*/
            SizedBox(height: 130,),
          ],
        ),
      ),
    );
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return Column(
      children: [
        Container(
            width: d,
            height: d,
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(asset, height: d-50,))),
        SizedBox(height: 7),
        Text(str, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
      ],
    );
  }
  Widget q1(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 4 - 35;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>ViewTextListPage(
          consid: widget.id, village: str,
        )));
      },
      child: Column(
        children: [
          Container(
              width: d,
              height: d,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(asset, height: d-50,))),
          SizedBox(height: 7),
          Text(send(str), style: TextStyle(fontWeight: FontWeight.w400,fontSize: 9)),
        ],
      ),
    );
  }
  String send(String str){
    int i = 13;
    if(str.length>i){
      return str.substring(0,1).toUpperCase()+str.substring(1,i)+"...";
    }
    return str.substring(0,1).toUpperCase()+str.substring(1,);
  }
  Widget c(double w, bool f){
    return Container(
      width: w / 2 - 30,
      height: (w / 3 + 20) / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: f?Colors.pinkAccent:Colors.blue, width: 4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Row(
          children: [
            Image.asset(f?"assets/female.png":"assets/male.jpg",width: ((w / 3 + 20) / 2)*0.9,),
            SizedBox(width: 9,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f?"Total Female":"Total Male",style: TextStyle(fontSize: 11,color: Colors.black),),
                Text("${giveback(f?female.toString():male.toString())}",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 15,color: Colors.black),)
              ],
            )
          ],
        ),
      ),
    );
  }
  String giveback(String str){
    if(str.length<=3){
      return str;
    }
    return str.substring(0, 1) + "," + str.substring(1);
  }
}

class VoterStats {
  final int total;
  final int male;
  final int female;
  final int noEpic;
  final List<int> missingSerials;

  VoterStats({
    required this.total,
    required this.male,
    required this.female,
    required this.noEpic,
    required this.missingSerials,
  });
}

class EditVoters extends StatelessWidget {
  final String id;final List<FinalVoterList> list;
  const EditVoters({super.key, required this.id,required this.list, });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        title: Text("Edit Voters",style: TextStyle(color: Colors.white),),
      ),
      body: Home(id: id, list: list,yes: true,)
    );
  }
}

