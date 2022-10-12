import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
import '/auth.dart';

class Edit_project_page extends StatefulWidget {
  DocumentReference<Object?> query_doc;

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
  late Future<bool> isStackEmpty;
  @override
  void initState() {
    super.initState();
    stack_snap = Stack();
    isStackEmpty = stack_snap.then((value) => value.docs.isEmpty);
  }

  CollectionReference projects =
      FirebaseFirestore.instance.collection('Projects');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //retain the appbar from the previous page
        // title:
        //     const Text("Edit Project", style: TextStyle(color: Colors.white)),
        // backgroundColor: const Color.fromARGB(255, 14, 41, 60),
        // centerTitle: true,
        title: const Text("Developer's Almanac"),
        actions: <Widget>[
          // Clear Icon
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Scaffold.of(context)
                      .openEndDrawer(); // Open drawer if Profile Icon is clicked
                });
          }),
        ],
        backgroundColor: const Color.fromARGB(255, 14, 41, 60),
      ),
      body: ListView(
        children: [
          Row(
            children: const [
              Expanded(
                child: Text(
                  "Edit Project",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times',
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(
                height: 70,
                thickness: 5,
              ),
            ],
          ),
          const Divider(
            height: 30,
            thickness: 3,
            color: Colors.white,
          ),
          const Divider(
            height: 30,
            thickness: 0,
            color: Color.fromARGB(255, 14, 41, 60),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(Icons.person_add),
              backgroundColor: Color.fromARGB(123, 223, 211, 211),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AddMember(
                    query_doc: widget.query_doc,
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(Icons.add),
              backgroundColor: Color.fromARGB(123, 223, 211, 211),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Column(children: [
                  AddStackPopUp(query_doc: widget.query_doc, snap_shot: stack_snap, id: widget.query_doc.id),
                ],)
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
