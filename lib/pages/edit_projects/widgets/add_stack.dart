import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
late String _selectedStackType = StackType.first;
var selectedID = "";

final _projectInfoController = TextEditingController();

class AddStackPopUp extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;
  const AddStackPopUp(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id});

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
                child: Text("Add / Modify Stacks",
                    style: TextStyle(fontWeight: FontWeight.bold)))),
        content: Form(
            key: _addStackKey,
            child: Container(
              width: 500,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1.0),
                        child: DropdownButton(
                            underline: const SizedBox(),
                            value: _selectedStackType,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedStackType = value!;
                              });
                            },
                            items: StackType.map((String value) {
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
                        child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Row(children: const [
                              Text('Current Stacks',
                                  selectionColor: Colors.white,
                                  style: TextStyle(fontSize: 15)),
                            ]))),
                  ),
                  ViewStacks(
                    query_doc: widget.query_doc,
                    snap_shot: widget.snap_shot,
                    id: widget.id,
                    callback: () {
                      callback();
                    },
                  ),
                ],
              ),
            )),
        actions: [
           Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => ModifyStackPopup(
                          query_doc: widget.query_doc,
                          snap_shot: widget.snap_shot,
                          id: selectedID));
                },
                child: const Text('Modify Stack'),
              ),
              TextButton(
                  child: const Text('Add Stack'),
                  onPressed: () {
                    if (_addStackKey.currentState!.validate()) {
                      print(foundMatch);
                      widget.query_doc
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
                                  title: Text("Error. Data already exists in database.")
                                )
                            );
                            }
                            print("Match found. Not added to database");
                          }
                        );
                        if (foundMatch == false) {
                          widget.query_doc.collection("Stack").add({
                            'stack_type': _selectedStackType,
                            'stack_title': _projectInfoController.text,
                          });
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

class ViewStacks extends StatefulWidget {
  final Function() callback;
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;

  const ViewStacks(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id,
      required this.callback});

  @override
  State<ViewStacks> createState() => _ViewStacksState();
}

class _ViewStacksState extends State<ViewStacks> {
  late Stream<QuerySnapshot> project_stream;
  var _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    project_stream = widget.query_doc.collection("Stack").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.query_doc.collection("Stack").snapshots(),
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

                        return GestureDetector(
                            onTap: (() => setState(() {
                                  for (int i = 0; i < StackType.length; i++) {
                                    if (project['stack_type'] == StackType[i]) {
                                      _selectedStackType =
                                          StackType.elementAt(i);
                                    }
                                  }
                                  if (_selectedIndex == index) {
                                    _selectedIndex = -1;
                                  } else {
                                    _selectedIndex = index;
                                    _projectInfoController.text =
                                        project['stack_title'];
                                  }
                                  selectedID = project.id;
                                  widget.callback();
                                })),
                            child: Container(
                                width: 500,
                                height: 60,
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 0.2,
                                      color: Color.fromARGB(172, 14, 41, 60)),
                                )),
                                child: Row(children: [ Flexible( fit: FlexFit.tight ,
                                  child: Container(                                  
                                    color: Colors.transparent,
                                    width: 500,
                                    height: 60,
                                    child: Card(
                                        color: index == _selectedIndex
                                            ? Color.fromARGB(255, 14, 41, 60)
                                            : Color.fromARGB(
                                                255, 255, 255, 255),
                                        child: Column(children: [
                                          Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Row(children: [
                                                Text(
                                                  '${project['stack_type']}: ${project['stack_title']}',
                                                  style: TextStyle(
                                                      color: index ==
                                                              _selectedIndex
                                                          ? Color.fromARGB(255,
                                                              255, 255, 255)
                                                          : Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      fontSize: 15),
                                                ),
                                                Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                  IconButton(
                                                  icon: const Icon(Icons.delete), 
                                                  onPressed: () { 
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                        DeleteStackPopup(query_doc: widget.query_doc,
                                                      snap_shot: widget.snap_shot,
                                                      id: project.id)
                                                    );
                                                  },
                                                  color: index == _selectedIndex
                                                          ? Color.fromARGB(255, 255, 0, 0)
                                                          : Color.fromARGB(255, 14, 41, 60),
                                                  )],
                                              )),
                                        ]))],
                                  ))))
                                ])));
                      }))
            ]));
      },
    );
  }
}



/// This widget lets the user delete a project given a project ID
class DeleteStackPopup extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;

  const DeleteStackPopup(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id});

  @override
  State<DeleteStackPopup> createState() => _DeleteStackPopupState();
}

class _DeleteStackPopupState extends State<DeleteStackPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Stack'),
      content: const Text('Are you sure you want to delete this stack?'),
      actions: [
        TextButton(
          onPressed: () {
            print(widget.id);
            widget.query_doc
                .collection('Stack')
                .doc(widget.id)
                .delete();
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}



/// This widget lets the user delete a project given a project ID
class ModifyStackPopup extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;

  const ModifyStackPopup(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id});

  @override
  State<ModifyStackPopup> createState() => _ModifyStackPopupState();
}

class _ModifyStackPopupState extends State<ModifyStackPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Stack'),
      content: const Text('Are you sure you want to modify this stack?'),
      actions: [
        TextButton(
          onPressed: () {
             widget.query_doc.collection('Stack').doc(selectedID).update(
              {'stack_type': _selectedStackType, 'stack_title': _projectInfoController.text }
            );
            Navigator.pop(context);
          },
          child: const Text('Modify'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}