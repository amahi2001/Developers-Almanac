// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/constants/style.dart';
import 'package:flutter/material.dart';
import '../../home_page/home_page.dart';
import '../edit_project.dart' as global;
//adding and viewing stacks

late String _selectedStackType = global.StackType.first;
var selectedID = "";

final _projectInfoController = TextEditingController();

class AddStackPopUp extends StatefulWidget {
  final Function() notifyParent;
  final project_id;
  final DocumentReference<Object?> project_query_doc;
  const AddStackPopUp(
      {super.key,
      required this.project_query_doc,
      required this.project_id,
      required this.notifyParent});

  @override
  State<AddStackPopUp> createState() => __AddStackPopUpState();
}

class __AddStackPopUpState extends State<AddStackPopUp> {
  final _addStackKey = GlobalKey<FormState>();
  bool foundMatch = false;

  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
        width: 100,
        height: 100,
      ),
      AlertDialog(
        title: const Padding(
            padding: EdgeInsets.all(3.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Add Stack",
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        content: Form(
            key: _addStackKey,
            child: Container(
              width: 500,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Row(children: const [
                        Text('Current Stacks',
                            selectionColor: Colors.white,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ])),
                  viewStacksInAdd(
                    query_doc: widget.project_query_doc,
                    id: widget.project_id,
                    callback: () {
                      callback();
                    },
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: DropdownButton(
                            underline: const SizedBox(),
                            value: _selectedStackType,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedStackType = value!;
                              });
                            },
                            items: global.StackType.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 900,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: _projectInfoController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter Technology:',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Project Technology';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, left: 1.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(23, 255, 255, 255),
                        ),
                      )),
                ],
              ),
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  child: const Text("Cancel"),
                  onPressed: (() => Navigator.pop(context))),
              TextButton(
                  child: const Text('Add Stack'),
                  onPressed: () {
                    if (_addStackKey.currentState!.validate()) {
                      print(foundMatch);
                      widget.project_query_doc
                          .collection('Stack')
                          .get()
                          .then((querySnapshot) {
                        querySnapshot.docs.forEach((result) {
                          if (_selectedStackType == result['stack_type'] &&
                              _projectInfoController.text ==
                                  result['stack_title']) {
                            foundMatch = true;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const AlertDialog(
                                        title: Text(
                                            "Error. Data already exists in database.")));
                          }
                          print("Match found. Not added to database");
                        });
                        if (foundMatch == false) {
                          widget.project_query_doc.collection("Stack").add({
                            'stack_type': _selectedStackType,
                            'stack_title': _projectInfoController.text,
                          });
                          projectTools.add(_projectInfoController.text);
                          widget.notifyParent();
                          print("Added to database");
                        }
                        foundMatch = false;
                      });
                    }
                  }),
            ],
          ),
        ],
      ),
    ]));
  }
}

class viewStacksInAdd extends StatefulWidget {
  final Function() callback;
  final id;
  final DocumentReference<Object?> query_doc;

  const viewStacksInAdd(
      {super.key,
      required this.query_doc,
      required this.id,
      required this.callback});

  @override
  State<viewStacksInAdd> createState() => _viewStacksInAddState();
}

class _viewStacksInAddState extends State<viewStacksInAdd> {
  late Stream<QuerySnapshot> stack_stream;
  var _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    stack_stream = widget.query_doc.collection("Stack").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stack_stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          String error = snapshot.error.toString();
          print(error);
          return Text(error, style: const TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading", style: TextStyle(color: Colors.white));
        }

        print("WENT TO VIEWSTACK");

        return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(24, 14, 41, 60),
            ),
            width: 500,
            height: 250,
            child: Column(children: [
              Flexible(
                  flex: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?> project =
                            snapshot.data!.docs[index];

                        if (!snapshot.hasData) {
                          print('test phrase');
                          return const Text("Loading.....");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading",
                              style: TextStyle(color: Colors.white));
                        }

                        return Container(
                            width: 500,
                            height: 60,
                            child: Row(children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  child: Container(
                                      color: const Color.fromARGB(
                                          172, 255, 255, 255),
                                      width: 500,
                                      height: 60,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  color: AppStyle.borderColor,
                                                  width: 1)),
                                          color: AppStyle.cardColor,
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(children: [
                                                    Text(
                                                      '${project['stack_type']}: ${project['stack_title']}',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                          fontSize: 15),
                                                    ),
                                                  ]))
                                            ],
                                          ))))
                            ]));
                      }))
            ]));
      },
    );
  }
}

