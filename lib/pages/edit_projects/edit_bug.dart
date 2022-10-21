import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/pages/edit_projects/widgets/view_bugs.dart';
import 'package:flutter/material.dart';
import 'widgets/add_bugs.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
import '/auth.dart';
import 'widgets/edit_stacks.dart';

class Edit_bug_page extends StatefulWidget {
  final DocumentReference<Object?> bug_query_doc;
  final String bug_ID;

  Edit_bug_page({
    super.key,
    required this.bug_query_doc,
    required this.bug_ID
  });

  @override
  State<Edit_bug_page> createState() => _Edit_bug_pageState();
}

class _Edit_bug_pageState extends State<Edit_bug_page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer's Almanac"),
        actions: <Widget>[
          // Clear Icon
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer(); // Open drawer if Profile Icon is clicked
                });
          }),
        ],
        backgroundColor: const Color.fromARGB(255, 14, 41, 60),
      ),
      body: ListView(
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Edit Bug",
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
        ]
      )
    );
  }
}


