
import 'package:adaptive_theme/adaptive_theme.dart' show AdaptiveTheme, AdaptiveThemeMode;
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/all_admin.dart';
import 'package:nsp2026/home/show.dart';
import 'package:nsp2026/home/upload.dart';
import 'package:nsp2026/home/upload/upload%20data.dart';
import 'package:nsp2026/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nsp2026/extra/all_voters.dart';
import 'package:nsp2026/function/global.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/login/all_constituency.dart';
import 'package:translator/translator.dart';
import '../admin/all_admin.dart';
import '../admin/view/add_view.dart';
import '../model/finalvoterlist.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../extra/all_voters.dart';
import '../login/all_constituency.dart';
import '../model/finalvoterlist.dart';
import 'init.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.list, required this.id,   required this.onFallback,});
  final List<FinalVoterList> list;
  final String id;
  final void Function(int index) onFallback;  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState(){
    v();
  }
  void v() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    s = await prefs.getString('username')??"NA";
    isLight =  AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light;
    setState(() {

    });
  }
   bool isLight=false;

  String s = "";
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 70),
            Center(
              child: Container(
                height: 120,width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    height: 110,width: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage("assets/11748483.png"))
                    ),
                    child: Center(child: Text("",
                      style: TextStyle(color: Colors.grey.shade800,fontSize: 37),)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Center(child: Text("$s",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17),)),
            Center(child: Text("My Username")),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                c1(w, Icon(Icons.privacy_tip_outlined), "SuperAdmin",user2.isadmin?"Yes": "No"),
                c1(w, Icon(Icons.upload), "Could Upload",user2.isuploaddata?"Yes": "No"),
                c1(w, Icon(Icons.warning), "Account Active", "Yes"),
              ],
            ),
            SizedBox(height: 13,),
            Container(
              width: w,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Most Used Functions",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          widget.onFallback(1);
                        },
                        child: a(Icon(Icons.person_search,color: Colors.lightBlueAccent,),"Search Voters","Search Voters through respective Data")),
                    user2.isuploaddata?InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>Up(id: widget.id,)));
                        },
                        child: a(Icon(Icons.upload,color: Colors.brown,),"Upload Voters","Upload New Voters through Respective Scanning")):SizedBox(),
                    InkWell(
                        onTap: (){
                          Global.launch("https://ayus.dev.xyz");
                        },
                        child: a(Icon(Icons.open_in_new,color: Colors.black,),"View Website","View your Website Oline People Could use")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Support & All Data",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          if(Global.check(context)){
                            return ;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>AllVoters(list: widget.list,id: widget.id,)));

                        },
                        child: a(Icon(Icons.menu,color: Colors.blue,),"All Voters","Get the List of All Voters")),
                    InkWell(
                        onTap: (){
                          Global.launch("https://wa.me/917978097489");
                        },
                        child: a(Icon(Icons.support,color: Colors.green,),"Get Help","Get instant and view FAQs")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            user2.isadmin?Container(
              width: w,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("For SuperAdmin",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          if(Global.check(context)){
                            return ;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>EditVoters(id: widget.id, list: widget.list)));

                        },
                        child: a(Icon(Icons.person_remove_alt_1,color: Colors.red,),"Edit Voters","Edit the List of Voters Gracefully")),
                    InkWell(
                        onTap: (){
                          if(Global.check(context)){
                            return ;
                          }
                          Navigator.push(context,MaterialPageRoute(builder: (_)=>AllAdmin()));
                        },
                        child: a(Icon(Icons.security_sharp,color: Colors.red,),"Admin Panel","Control Everything from SuperAdmin Panel")),
                  ],
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 15,),
            Container(
              width: w,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Rectangle (no rounded edges)
                                ),
                                title: const Text("Log out ?"),
                                content: const Text("You sure to Log out from the App"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false), // Cancel
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setString('username', "NA");
                                      await prefs.setString('id',"NA");
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MyApp()));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.resolveWith(
                                            (states) => Colors.red,   // your color here
                                      ),
                                    ),
                                    child: const Text("OK",style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.login,color: Colors.red,),
                          title: Text("Log Out",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.red),),
                        )
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              width: w,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Center(child: Image.asset("assets/logo.jpg",width: w/3,)),
                    Center(child: Text("VSL 2026 App v1.0.0",style: TextStyle(color: Colors.grey.shade500),)),
                    SizedBox(height: 60,),
                   ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget a(Widget a1,String str,String str2)=>ListTile(
    leading: CircleAvatar(
        backgroundColor: Global.grey,
        child: a1
    ),
    title: Text(str,style: TextStyle(fontWeight: FontWeight.w700),),
    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,size: 18,),
  );

  Widget c1(double w , Widget c1,String str, String str2){
    return Container(
      width: w/3-10,
      height: 85,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isLight?Colors.black:Colors.grey,width: 0.3
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            c1,
            Text(str,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 10),),
            Spacer(),
            Row(
              children: [
                Spacer(), Text(str2,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13),)
              ],
            )
          ],
        ),
      ),
    );
  }
}

