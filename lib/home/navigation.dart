


import 'package:adaptive_theme/adaptive_theme.dart' show AdaptiveTheme, AdaptiveThemeMode;
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/home/profile.dart';
import 'package:nsp2026/home/show.dart';
import 'package:nsp2026/home/upload.dart';
import 'package:nsp2026/model/finalvoterlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/all_admin.dart';
import '../function/global.dart';
import '../login/all_constituency.dart';
import '../main.dart';
import 'init.dart';

class Navigation extends StatefulWidget {
  final String id;
  final List<FinalVoterList> list;
  const Navigation({super.key,required this.id,required this.list});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(index: 0);

  void openFallbackScreen(int index) {
    if(index==3){
      index=2;
    }
    _controller.jumpTo(index);
    _pageController.jumpToPage(index);
    setState(() {

    });
  }

  int maxCount = 3;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Show(id: widget.id,list: widget.list,  onFallback: openFallbackScreen,),
      Home(id: widget.id,list: widget.list),
      Profile(id: widget.id,list: widget.list,  onFallback: openFallbackScreen,),
    ];
    return WillPopScope(
        onWillPop: () async {
          if(_controller.index!=0){
            openFallbackScreen(0);
            return false;
          }
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                title: const Text("Close the App ?"),
                content: const Text("You sure to Close the App"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, true);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );

          return shouldExit ?? false; // true = allow back
        },
      child: user2.ison? Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/logo-removebg-preview.png",width: 50,),
                      Text(
                        'VSL 2026',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,fontWeight: FontWeight.w900
                        ),
                      ),
                      Text(
                        'One Place for all your Voter Id Data',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  Navigator.pop(context);
                  openFallbackScreen(0);
                },
                leading: Icon(Icons.home_filled,),
                title: Text('Home',style: TextStyle( fontWeight: FontWeight.w800),),
              ),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  Navigator.pop(context);
                  openFallbackScreen(1);
                },
                leading: Icon(Icons.search,),
                title: Text('Search',style: TextStyle( fontWeight: FontWeight.w800),),
              ),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  Navigator.pop(context);
                  openFallbackScreen(3);
                },
                leading: Icon(Icons.person,),
                title: Text('Profile',style: TextStyle( fontWeight: FontWeight.w800),),
              ),
              SizedBox(height: 30,),
              user2.isadmin?Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Manage Control",style: TextStyle(
                    fontWeight: FontWeight.w800,fontSize: 18),),
              ):SizedBox(),
              user2.isadmin?ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  if(Global.check(context)){
                    return ;
                  }
                  Navigator.push(context,MaterialPageRoute(builder: (_)=>AllAdmin()));
                },
                leading: Icon(Icons.privacy_tip_outlined,),
                title: Text('Admin',style: TextStyle( fontWeight: FontWeight.w800),),
              ):SizedBox(),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Other Functions",style: TextStyle(
                    fontWeight: FontWeight.w800,fontSize: 18),),
              ),
              ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  Global.launch("https://wa.me/917978097489");
                },
                leading: Icon(Icons.support,),
                title: Text('Support',style: TextStyle( fontWeight: FontWeight.w800),),
              ),
              ListTile(
                onTap: (){
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
                      );});
                },
                trailing: Icon(Icons.arrow_forward),
                leading: Icon(Icons.login,color: Colors.red),
                title: Text('Log out',style: TextStyle(color: Colors.red, fontWeight: FontWeight.w800),),
              ),
              SizedBox(height: 70,)
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white
          ),
          title:  Text('NSP 2026',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            IconButton(onPressed: (){
              AdaptiveTheme.of(context).toggleThemeMode();
            }, icon: Icon(Icons.sunny,color: Colors.white,)),
            IconButton(onPressed: (){
              openFallbackScreen(1);
            }, icon: Icon(Icons.search,color: Colors.yellow,)),
            IconButton(onPressed: (){
              openFallbackScreen(3);
            }, icon: Icon(Icons.person,color: Colors.blue,)),
            IconButton(onPressed: (){
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
            }, icon: Icon(Icons.login,color: Colors.red,)),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
        ),
        extendBody: true,
        bottomNavigationBar: (bottomBarPages.length <= maxCount)
            ? AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          showLabel: true,
          textOverflow: TextOverflow.visible,
          maxLine: 1,
          shadowElevation: 5,
          kBottomRadius: 28.0,
          notchColor: Colors.black87,
          removeMargins: true,
          bottomBarWidth: 500,
          showShadow: false,
          durationInMilliSeconds: 300,
          itemLabelStyle: const TextStyle(fontSize: 10),
          elevation: 1,
          bottomBarItems: const [
            BottomBarItem(
              inActiveItem: Icon(
                Icons.home_filled,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.home_filled,
                color: Colors.white,
              ),
              itemLabel: 'Overview',
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.search, color: Colors.blueGrey),
              activeItem: Icon(
                Icons.person_search,
                color: Colors.white,
              ),
              itemLabel: 'Search',
            ),
            BottomBarItem(
              inActiveItem: Icon(
                Icons.person,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.person,
                color: Colors.white,
              ),
              itemLabel: 'Profile',
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.0,
        )
            : null,
      ):Scaffold(
        appBar: AppBar(
          title: Text("ACCESS REMOVED",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900),),
          actions: [
            IconButton(onPressed: (){
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
            }, icon: Icon(Icons.login,color: Colors.red,)),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/14256604.png",width: 100,),
            SizedBox(height: 20,),
            Text("SuperAdmin Removed your Access !",style: TextStyle(fontSize:20,fontWeight: FontWeight.w900),),
            Text(textAlign: TextAlign.center,"Please Logout and Find Another Username and Password from SuperAdmin")
          ],
        ),
      ),
    );
  }
}


class VoterRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FinalVoterList>> fetchVoters(String collectionId) async {
    final snap = await _firestore.collection(collectionId).get();

    return snap.docs
        .map((doc) => FinalVoterList.fromMap(
      doc.data() as Map<String, dynamic>,
    ))
        .toList();
  }
}
