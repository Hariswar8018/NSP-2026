


import 'package:flutter/material.dart';
import 'package:nsp2026/function/global.dart';
import 'package:nsp2026/home/upload/data_details.dart';
import 'package:nsp2026/home/upload/upload%20data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Scan extends StatefulWidget {
  final String id ;
  const Scan({super.key,required this.id});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  Future<bool> requestMediaPermission() async {
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      return true;
    }

    if (await Permission.photos.request().isGranted) {
      return true;
    }

    if (await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }
  void initState(){
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.i2ocr.com/free-online-hindi-ocr'));
    call();
  }
  Future<void> call() async {
    final granted = await requestMediaPermission();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied")),
      );
    }

  }
  late WebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Data"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Text("1",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
            ),
            title: Text("Scan the Pdf "),
            subtitle: Text("Scan 1 page of Pdf here to get the value"),
          ),
          SizedBox(height: 30,),
          ListTile(
            onTap: (){
              Global.launch("https://www.i2ocr.com/free-online-hindi-ocr");
            },
             leading: Icon(Icons.document_scanner_outlined,size: 35,),
            title: Text("Convert 1 Pdf Page to Text"),
            subtitle: Text("Open the web page and convert the Pdf to Text"),
            trailing: Icon(Icons.open_in_new,color: Colors.red,),
          ),
          SizedBox(height: 10,),
          Center(child: Text("OR",style: TextStyle(fontWeight: FontWeight.w800),),),
          SizedBox(height: 10,),
          Flexible(
            child: WebViewWidget(controller: controller),
          ),
          SizedBox(height: 25,),
        ],
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AreaInputForm(id: widget.id)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width-20,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow,
              border: Border.all(
                color: Colors.black
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Proceed to Convert",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black),),
                SizedBox(width: 12,),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
