import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../function/global.dart';
import '../model/finalvoterlist.dart' show FinalVoterList;
import '../utils/save_image.dart';
import 'edit_voter.dart';
import 'package:permission_handler/permission_handler.dart';



class VoterReceiptPage extends StatefulWidget {
  final FinalVoterList voter;
  final String id;
  const VoterReceiptPage({
    super.key,
    required this.voter,required this.id
  });

  @override
  State<VoterReceiptPage> createState() => _VoterReceiptPageState();
}

class _VoterReceiptPageState extends State<VoterReceiptPage> {

  void initState(){
    if (!kIsWeb) {
      ask();
      requestWritePermission();
    }

  }
  Future<bool> ask() async {
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
  Future<bool> requestWritePermission() async {
    if (await Permission.storage.isGranted) {
      return true;
    }
    if (await Permission.storage.isPermanentlyDenied) {
      openAppSettings();
    }

    final status = await Permission.storage.request();
    return status.isGranted;
  }
  final GlobalKey _receiptKey = GlobalKey();
  bool on = false, progress = false;

  Widget t(double w, String str){
    return Text(
      str,
      style: TextStyle(
        color: Colors.black,
        fontSize: w * 0.05,            // responsive text
        fontWeight: FontWeight.w600,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: const Text("Voter Receipt",style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            setState(() {
              on = !on;
            });
          }, icon: Icon(Icons.picture_as_pdf,color:on?Colors.yellow:  Colors.white,)),
          IconButton(onPressed: (){
            if(Global.check(context)){
              return ;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditVoterPage(
                  voter: widget.voter,
                  collectionId: widget.id,
                ),
              ),
            );
          }, icon: Icon(Icons.edit,color:Colors.white)),
          SizedBox(width: 10,)
        ],
      ),
      body: on?RepaintBoundary(
        key: _receiptKey,
        child: Container(
          width: w,height : w * 0.5640625,
          child: Stack(
            children: [
              Image.asset("assets/template.jpg",width: w,),
              Positioned(
                left: w * 0.34,
                top: (w * 0.5640625) * 0.26,
                child: t(w,widget.voter.wardsankya)
              ),
              Positioned(
                  left: w * 0.755,
                  top: (w * 0.5640625) * 0.26,
                  child: t(w,widget.voter.serialNo.toString())
              ),
              Positioned(
                  left: w * 0.254,
                  top: (w * 0.5640625) * 0.443,
                  child: t(w,widget.voter.name)
              ),
              Positioned(
                  left: w * 0.47,
                  top: (w * 0.5640625) * 0.548,
                  child: t(w,widget.voter.fatherName)
              ),
              Positioned(
                  left: w * 0.375,
                  top: (w * 0.5640625) * 0.665,
                  child: t(w,widget.voter.houseNo)
              ),
              Positioned(
                  left: w * 0.257,
                  top: (w * 0.5640625) * 0.78,
                  child: t(w,widget.voter.age.toString())
              ),
              Positioned(
                  left: w * 0.74,
                  top: (w * 0.5640625) * 0.79,
                  child: t(w,widget.voter.gender.toString())
              ),
            ],
          ),
        ),
      ):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 10),
              child: Container(
                width: w-10,
                decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.shade300
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                  child: Column(
                    children: [
                      _section("Voter Information"),
                      receiptRow(label: "Serial No", value: widget.voter.serialNo.toString(), bold: true),
                      receiptRow(label: "Voter ID", value: widget.voter.voterId),
                      receiptRow(label: "EPIC No", value: widget.voter.epicNo),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 10),
              child: Container(
                width: w-10,
                decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.shade300
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                  child: Column(
                    children: [
                      _section("Personal Details"),
                      receiptRow(label: "Name (Hindi)", value: widget.voter.name),
                      receiptRow(label: "Name (English)", value: widget.voter.nameEn),
                      receiptRow(label: "Father Name (Hindi)", value: widget.voter.fatherName),
                      receiptRow(label: "Father Name (English)", value: widget.voter.fatherNameEn),
                      receiptRow(label: "Gender", value: "${widget.voter.gender} / ${widget.voter.genderEn}"),
                      receiptRow(label: "Age", value: widget.voter.age.toString()),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 10),
              child: Container(
                width: w-10,
                decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.shade300
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
                  child: Column(
                    children: [
                      _section("Constituency Information"),
                      receiptRow(label: "मकान नं॰", value: widget.voter.houseNo),
                      receiptRow(label: "वार्ड संख्या", value: widget.voter.wardsankya),
                      receiptRow(label: "जिला", value: widget.voter.jila),
                      receiptRow(label: "विकास खंड", value: widget.voter.vikaskhand),
                      receiptRow(label: "ग्राम पंचायत", value: widget.voter.grampanchayat),
                      receiptRow(label: "मतदान केंद्र", value: widget.voter.matdankendra),
                      receiptRow(label: "मतदान स्थल", value: widget.voter.matdansthal),
                      // receiptRow(label: "Sammilit Jaswa Gram", value: widget.voter.sammilitjaswagram),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
      persistentFooterButtons: [
        progress ? Center(child: CircularProgressIndicator(
          color: Colors.yellow,
        )):InkWell(
          onTap: () async {
            if(!on){
              setState(() => on = true);     // show receipt
              return ;
            }
            setState(() => progress = true);
            await saveReceiptToGallery();
            setState(() => progress = false);

          },
          child: Container(
            width: MediaQuery.of(context).size.width-20,
            height: 55,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: on?Colors.yellow:Colors.grey.shade400,
                border: Border.all(
                    color: Colors.black
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(on?"Yes Download Now":"Download Receipt",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black),),
                SizedBox(width: 12,),
                Icon(Icons.picture_as_pdf),
              ],
            ),
          ),
        ),
      ],
    );
  }
  Future<void> saveReceiptToGallery() async {
    final bytes = await _captureReceipt();

    await saveImage(bytes, "Voter_${widget.voter.voterId}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receipt saved")),
    );
  }

  Future<void> saveReceipt() async {
    final bytes = await _captureReceipt();

    await saveImage(bytes, "Voter_${widget.voter.voterId}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receipt saved")),
    );
  }


  Future<Uint8List> _captureReceipt() async {
    final boundary =
    _receiptKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage(pixelRatio: 3);
    final byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<String?> saveFile( document, String name) async {
    try {
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        final String downloadsPath = '${dir.path}';
        final String filePath = '$downloadsPath/$name.pdf';

        final File file = File(filePath);
        await file.writeAsBytes(await document.save());

        debugPrint('Saved exported PDF at: $filePath');
        return filePath;
      } else {
        debugPrint('Could not access external storage directory.');
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,color: Colors.black
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 1,
      color: Colors.grey.shade300,
    );
  }

  Widget receiptRow({
    required String label,
    required String value,
    bool bold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const Text(":  "),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
