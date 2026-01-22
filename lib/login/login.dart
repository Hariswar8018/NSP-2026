import 'package:flutter/material.dart';
import 'package:nsp2026/function/login_signup.dart';
import 'package:nsp2026/home/all_data.dart';
import 'package:nsp2026/home/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/init.dart';
import '../model/user.dart';

class Login extends StatefulWidget {
  final String str;
  const Login({super.key,required this.str});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
 
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  Future<void> login() async {
    final username = usernameC.text.trim();
    final password = passwordC.text.trim();


    LoginModel? user = await Users.login(context, username: username, password: password, name: widget.str);
    if(user!=null){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('id', widget.str);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>InitCla(id: widget.str,username: username,)));
    }
    debugPrint('Username: $username');
    debugPrint('Password: $password');
  }

  @override
  void dispose() {
    usernameC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo-removebg-preview (1).png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameC,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordC,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: login,
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login,color: Colors.black,),
                      SizedBox(width: 8),
                      Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
