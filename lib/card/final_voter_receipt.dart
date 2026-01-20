import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver2_fixed/image_gallery_saver2_fixed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' show Share, XFile;
import 'dart:ui' as ui;
import 'dart:typed_data';
import '../function/global.dart';
import '../model/finalvoterlist.dart' show FinalVoterList;
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
    ask();
    requestWritePermission();
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
          width: w,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
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
                          Text("VOTER INFORMATION",style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w900
                          ),),
                          _section("Personal Details"),
                          receiptRow(label: "Name ", value: widget.voter.name),
                          receiptRow(label: "EPIC No", value: widget.voter.epicNo),
                          receiptRow(label: "Father/Husband/etc Name", value: widget.voter.fatherName),
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
                          receiptRow(label: "House No", value: widget.voter.houseNo),
                          receiptRow(label: "Jila", value: widget.voter.jila),
                          receiptRow(label: "Vikaskhand", value: widget.voter.vikaskhand),
                          receiptRow(label: "Gram Panchayat", value: widget.voter.grampanchayat),
                          receiptRow(label: "Matdan Kendra", value: widget.voter.matdankendra),
                          receiptRow(label: "Matdan Sthal", value: widget.voter.matdansthal),
                          receiptRow(label: "Ward Sankya", value: widget.voter.wardsankya),
                          receiptRow(label: "Sammilit Jaswa Gram", value: widget.voter.sammilitjaswagram),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
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
                      receiptRow(label: "House No", value: widget.voter.houseNo),
                      receiptRow(label: "Jila", value: widget.voter.jila),
                      receiptRow(label: "Vikaskhand", value: widget.voter.vikaskhand),
                      receiptRow(label: "Gram Panchayat", value: widget.voter.grampanchayat),
                      receiptRow(label: "Matdan Kendra", value: widget.voter.matdankendra),
                      receiptRow(label: "Matdan Sthal", value: widget.voter.matdansthal),
                      receiptRow(label: "Ward Sankya", value: widget.voter.wardsankya),
                      receiptRow(label: "Sammilit Jaswa Gram", value: widget.voter.sammilitjaswagram),
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
            setState(() => on = true);     // show receipt
            setState(() => progress = true);
            await Future.delayed(
              const Duration(milliseconds: 300),
            );
            await requestWritePermission();
            await saveReceiptToGallery();
            setState(() => progress = false);

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
                Text("Download Receipt",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.black),),
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

    final result = await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: "Voter_${widget.voter.voterId}",
    );

    debugPrint("Saved: $result");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Receipt saved to Gallery")),
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
          fontWeight: FontWeight.w800,
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
