import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/view.dart';

class ViewTextListPage extends StatefulWidget {
  String consid; String village;
   ViewTextListPage({super.key,required this.consid, required this.village});

  @override
  State<ViewTextListPage> createState() => _ViewTextListPageState();
}

class _ViewTextListPageState extends State<ViewTextListPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _addViewText(String name) async {
    final id = DateTime.now().toString();

    final viewText = ViewText(
      id: id,
      name: name.trim(),
    );

    await FirebaseFirestore.instance
        .collection("constituency")
        .doc(widget.consid)
        .collection(widget.village)
        .doc(id)
        .set(viewText.toJson());
  }

  /// 🔹 Show dialog to add name
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Name"),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  await _addViewText(nameController.text);
                }
                nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("Select from ${widget.village.substring(0,1).toUpperCase()}${widget.village.substring(1)} List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("constituency")
            .doc(widget.consid)
            .collection(widget.village)
            .orderBy("name")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data!.docs
              .map((doc) => ViewText.fromJson(
            doc.data() as Map<String, dynamic>,
          ))
              .toList();

          if (list.isEmpty) {
            return const Center(child: Text("No Data Found"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              return ListTile(
                onTap: (){
                  Navigator.pop(context,list[i].name );
                },
                leading: const Icon(Icons.text_fields),
                title: Text(list[i].name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
