import 'package:flutter/material.dart';

class Rectify2 extends StatefulWidget {
  const Rectify2({super.key});

  @override
  State<Rectify2> createState() => _Rectify2State();
}

class _Rectify2State extends State<Rectify2> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rectify Function"),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            width: w,
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      ),
    );
  }
}
