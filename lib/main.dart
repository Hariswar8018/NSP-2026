import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nsp2026/login/all_constituency.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'home/init.dart';
import 'home/navigation.dart';
import 'model/hive/final.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FinalVoterListAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp( MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,this.savedThemeMode});
  final AdaptiveThemeMode? savedThemeMode;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true).copyWith(
        textTheme: ThemeData.light(useMaterial3: true)
            .textTheme
            .apply(fontFamily: 'OpenSans'),
      ),
      dark: ThemeData.dark(useMaterial3: true).copyWith(
        textTheme: ThemeData.dark(useMaterial3: true)
            .textTheme
            .apply(fontFamily: 'OpenSans'),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'vsl',
        theme: theme,
        darkTheme: darkTheme,
        home: MyHomePage(title: ""),
      ),
    );
  }
}
String s1 = "NSP1768802521725373";
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState(){
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String s = await prefs.getString('username')??"NA";
    if(s!="NA"){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => InitCla(id: s1,username: s,),
        ),
      );
    }else{
      Future.delayed(const Duration(seconds: 3), () async {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>  Login(str: s1),
          ),
        );
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image(
                image: AssetImage('assets/logo-removebg-preview (1).png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
    );
  }
}
