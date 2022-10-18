import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'widgets/add_bugs.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
import '/auth.dart';
import 'widgets/edit_stacks.dart';

List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
String _selectedStackType = StackType.first;
var selectedID = "";
final _projectInfoController = TextEditingController();

class Edit_project_page extends StatefulWidget {
  DocumentReference<Object?> project_query_doc;

  Edit_project_page({super.key, required this.project_query_doc});

  @override
  State<Edit_project_page> createState() => _Edit_project_pageState();
}

class _Edit_project_pageState extends State<Edit_project_page> {
  @override
  void initState() {
    super.initState();
  }

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
                Scaffold.of(context).openEndDrawer(); // Open drawer if Profile Icon is clicked
              }
            );
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
                )
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => Column(
                      children: [
                        AddStackPopUp(
                          project_query_doc: widget.project_query_doc,
                          project_id: widget.project_query_doc.id
                        ),
                      ],
                    )
                  );
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
                    project_query_doc: widget.project_query_doc,
                    id: widget.project_query_doc.id,
                    callback: () {},
                  )
                )
              ),
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
                    query_doc: widget.project_query_doc,
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

class ViewStacks extends StatefulWidget {
  final Function() callback;
  final id;
  final DocumentReference<Object?> project_query_doc;

  const ViewStacks({
        super.key,
      required this.project_query_doc,
      required this.id,
      required this.callback
  });

  @override
  State<ViewStacks> createState() => _ViewStacksState();
}

class _ViewStacksState extends State<ViewStacks> {
  late Stream<QuerySnapshot> stackStream;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    stackStream = widget.project_query_doc.collection("Stack").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stackStream,
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
            child: Column(
              children: [
                Flexible(
                    flex: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Object?> stack = snapshot.data!.docs[index];

                          if (!snapshot.hasData) {
                            print('test phrase');
                            return const Text("Loading.....");
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text(
                              "Loading",
                                style: TextStyle(color: Colors.white)
                            );
                          }
                          return InkWell(
                              onTap: (() => setState(() {
                                  for (var x in StackType) {
                                    if (stack['stack_type'] == x) {
                                      _selectedStackType = x;
                                    }
                                  }
                                  if (_selectedIndex == index) {
                                    _selectedIndex = -1;
                                  } else {
                                    _selectedIndex = index;
                                    _projectInfoController.text =
                                        stack['stack_title'];
                                  }
                                  selectedID = stack.id;
                                  widget.callback();
                              })),
                              child: Container(
                                  width: 500,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 0.2,
                                          color: Color.fromARGB(172, 14, 41, 60)
                                      ),
                                    )
                                  ),
                                  child: Row(children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Container(
                                            color: Colors.transparent,
                                            width: 500,
                                            height: 60,
                                            child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    side: const BorderSide(
                                                        color: Color.fromARGB(255, 146, 153, 192),
                                                        width: 1
                                                    )
                                                ),
                                                color: index == _selectedIndex
                                                    ? const Color.fromARGB(255, 14, 41, 60)
                                                    : const Color.fromARGB(255, 22, 66, 97),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                        padding: const EdgeInsets.all(5),
                                                        child: Row(children: [
                                                          Text(
                                                            '${stack['stack_type']}: ${stack['stack_title']}',
                                                            style: TextStyle(
                                                                color: index ==_selectedIndex
                                                                    ? const Color.fromARGB(255,255,255,255)
                                                                    : const Color.fromARGB(255, 255, 255,255),
                                                                fontSize: 15
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:MainAxisAlignment.end,
                                                                children: [
                                                                  AddBugButton(
                                                                    isSelected: index == _selectedIndex,
                                                                    project_query_doc: widget.project_query_doc,
                                                                    stack_id: stack.id,
                                                                  ),
                                                                  IconButton(
                                                                    icon: const Icon(Icons.edit),
                                                                    onPressed: () {
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) => ModifyStack(
                                                                            query_doc: widget.project_query_doc,
                                                                            id: stack.id,
                                                                            stack_type: stack['stack_type'],
                                                                            technology: stack['stack_title'],
                                                                          )
                                                                      );
                                                                    },
                                                                    color: index ==  _selectedIndex
                                                                        ? const Color.fromARGB( 255, 255, 0, 0)
                                                                        : const Color.fromARGB(255, 255,255, 255),
                                                                  ),
                                                                  IconButton(
                                                                    icon: const Icon(Icons.delete),
                                                                    onPressed: () {
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) => DeleteStackPopup(
                                                                            query_doc: widget.project_query_doc,
                                                                            id: stack.id
                                                                        )
                                                                      );
                                                                    },
                                                                    color: index == _selectedIndex
                                                                        ? const Color.fromARGB(255, 255, 0, 0)
                                                                        : const Color.fromARGB(255,255,255,255),
                                                                  ),
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
