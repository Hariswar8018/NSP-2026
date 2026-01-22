


import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/init.dart';

class Global {

  static Future<void> launch(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
    }
  }

  static bool check(BuildContext context){
    if(!user2.isadmin){
      const snackBar = SnackBar(
        content: Text('Sorry ! You don\'t have Necessary Permission. Please contact Admin'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return true;

    }else{

      return false;
    }
  }
  static Color grey = Colors.white;

  static bool themebool(BuildContext context) {
    switch (AdaptiveTheme.of(context).mode) {
      case AdaptiveThemeMode.light:
        return true;
      case AdaptiveThemeMode.dark:
        return false;
      default:
        return false;
    }
  }

}