
import 'package:flutter/material.dart';
import 'package:nsp2026/admin/all_admin.dart';
import 'package:nsp2026/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void initState(){
    v();
  }
  v() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    s = await prefs.getString('username')??"NA";
    setState(() {

    });
  }
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
                c1(w, Icon(Icons.privacy_tip_outlined), "SuperAdmin", "Yes"),
                c1(w, Icon(Icons.upload), "Could Upload", "No"),
                c1(w, Icon(Icons.warning), "Account Active", "Yes"),
              ],
            ),
            SizedBox(height: 13,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Profiles",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){

                        },
                        child: a(Icon(Icons.payment,color: Colors.green,),"Orders","Track all your Bookings in one place")),
                    InkWell(
                        onTap: (){

                        },
                        child: a(Icon(Icons.account_balance,color: Colors.green,),"Payments","View and Manage Payments")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Support",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                        },
                        child: a(Icon(Icons.support,color: Colors.green,),"Get Help","Get instant and view FAQs")),
                    InkWell(
                        onTap: (){
                        },
                        child: a(Icon(Icons.info,color: Colors.green,),"About Us","Known About us")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("For SuperAdmin",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 19),),
                    InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (_)=>AllAdmin()));
                        },
                        child: a(Icon(Icons.security_sharp,color: Colors.red,),"Admin Panel","Control Everything from SuperAdmin Panel")),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: w,
              color: Colors.white,
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
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Center(child: Image.asset("assets/logo.png",width: w/3,)),
                    Center(child: Text("NSP 2026 App v1.0.0",style: TextStyle(color: Colors.grey.shade500),)),
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
    subtitle: Text(str2,style: TextStyle(fontWeight: FontWeight.w300),),
    trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey.shade400,),
  );

  Widget c1(double w , Widget c1,String str, String str2){
    return Container(
      width: w/3-10,
      height: 85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4)
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

class Global{
  static Color grey = Colors.white;
}