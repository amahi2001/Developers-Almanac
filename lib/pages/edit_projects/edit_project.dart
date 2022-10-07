import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'widgets/add_stack.dart';

class Edit_project_page extends StatefulWidget {
  // String project_id;
  // String? user_id;
  // String project_title;
  // String project_description;

  DocumentReference<Object?> query_doc;

  // Edit_project_page({super.key, required this.project_id, required this.project_description, required this.project_title, required this.user_id});
  Edit_project_page({super.key, required this.query_doc});

  @override
  State<Edit_project_page> createState() => _Edit_project_pageState();
}

class _Edit_project_pageState extends State<Edit_project_page> {
  Future<QuerySnapshot<Map<String, dynamic>>> Stack() async {
    final StackSnap = await widget.query_doc.collection('Stack').get();
    return StackSnap;
  }

  late Future<QuerySnapshot<Map<String, dynamic>>> stack_snap;
  late Future<bool>isStackEmpty;

  @override
  void initState() {
    super.initState();
    stack_snap = Stack();
    isStackEmpty = stack_snap.then((value) => value.docs.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //retain the appbar from the previous page
        title: const Text("Edit Project", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 14, 41, 60),
        centerTitle: true,
      ),
      body: Container(
          child: Row(
        children: [
          Column(children: [
            FloatingActionButton(onPressed: () {
              showDialog(context: context, 
              builder: (BuildContext context) => const AddStackPopUp(),
              );
            }, child: const Icon(Icons.add)),
            Text(widget.query_doc.id, style: TextStyle(color: Colors.white)),
          ])
        ],
      )),
    );
  }
}
