import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
import '/auth.dart';
import 'widgets/edit_stacks.dart';

List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
String _selectedStackType = StackType.first;
var selectedID = "";
final _projectInfoController = TextEditingController();

class Edit_project_page extends StatefulWidget {
  DocumentReference<Object?> query_doc;

  Edit_project_page({super.key, required this.query_doc});

  @override
  State<Edit_project_page> createState() => _Edit_project_pageState();
}

class _Edit_project_pageState extends State<Edit_project_page> {
  @override
  void initState() {
    super.initState();
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
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Stacks",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Times',
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.left,
                  )),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                // heroTag: "btn2",
                child: const Icon(Icons.add),
                // backgroundColor: Color.fromARGB(123, 223, 211, 211),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Column(
                            children: [
                              AddStackPopUp(
                                  query_doc: widget.query_doc,
                                  id: widget.query_doc.id),
                            ],
                          ));
                },
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                      width: 500,
                      child: ViewStacks(
                        query_doc: widget.query_doc,
                        id: widget.query_doc.id,
                        callback: () {},
                      ))),
            ],
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              child: const Icon(Icons.person_add),
              backgroundColor: const Color.fromARGB(123, 223, 211, 211),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AddMember(
                    query_doc: widget.query_doc,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class EditStack extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  const EditStack(
      {super.key,
      required this.query_doc,
      required this.id});

  @override
  State<EditStack> createState() => __EditStackState();
}

class __EditStackState extends State<EditStack> {
  final _addStackKey = GlobalKey<FormState>();
  bool foundMatch = false;

  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          width: 100,
          height: 100,
        ),
        Form(
            key: _addStackKey,
            child: Container(
              width: 500,
              child: Column(
                children: [
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
                    id: widget.id,
                    callback: () {
                      callback();
                    },
                  ),
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
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
                        query_doc: widget.query_doc, stack_id: selectedID));
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
                              builder: (BuildContext context) => const AlertDialog(
                                  title: Text(
                                      "Error. Data already exists in database.")));
                        }
                        print("Match found. Not added to database");
                      });
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
    ));
  }
}

class ViewStacks extends StatefulWidget {
  final Function() callback;
  final id;
  final DocumentReference<Object?> query_doc;

  const ViewStacks(
      {super.key,
      required this.query_doc,
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
      stream: project_stream,
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
            height: 450,
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
                                child: Row(children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Container(
                                          color: Colors.transparent,
                                          width: 500,
                                          height: 60,
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  side: const BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 146, 153, 192),
                                                      width: 1)),
                                              color: index == _selectedIndex
                                                  ? const Color.fromARGB(
                                                      255, 14, 41, 60)
                                                  : const Color.fromARGB(
                                                      255, 22, 66, 97),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(children: [
                                                        Text(
                                                          '${project['stack_type']}: ${project['stack_title']}',
                                                          style: TextStyle(
                                                              color: index ==
                                                                      _selectedIndex
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 15),
                                                        ),
                                                        Expanded(
                                                            child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.edit),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        ModifyStack(
                                                                          query_doc:
                                                                              widget.query_doc,
                                                                          id: project
                                                                              .id,
                                                                          stack_type:
                                                                              project['stack_type'],
                                                                          technology:
                                                                              project['stack_title'],
                                                                        ));
                                                              },
                                                              color: index ==
                                                                      _selectedIndex
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      0,
                                                                      0)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext context) => DeleteStackPopup(
                                                                        query_doc:
                                                                            widget
                                                                                .query_doc,
                                                                        id: project
                                                                            .id));
                                                              },
                                                              color: index ==
                                                                      _selectedIndex
                                                                  ? const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      0,
                                                                      0)
                                                                  : const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            )
                                                          ],
                                                        )),
                                                      ]))
                                                ],
                                              ))))
                                ])));
                      }))
            ]));
      },
    );
  }
}

/// This widget lets the user modify a project given a project ID
