


import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/home/profile.dart';
import 'package:nsp2026/home/show.dart';
import 'package:nsp2026/home/upload.dart';
import 'package:nsp2026/model/finalvoterlist.dart';

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


  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Show(id: widget.id,list: widget.list,),
      Home(id: widget.id,list: widget.list),
      Up(id: widget.id), Profile(),
    ];
    return WillPopScope(
        onWillPop: () async {
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
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Search'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Admin'),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('All Data'),
              ),
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
            IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.yellow,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.person,color: Colors.blue,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.login,color: Colors.red,)),
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
          color: Colors.white,
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
                Icons.upload,
                color: Colors.blueGrey,
              ),
              activeItem: Icon(
                Icons.upload_file_rounded,
                color: Colors.white,
              ),
              itemLabel: 'Upload',
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
