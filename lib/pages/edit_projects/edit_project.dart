// ignore_for_file: camel_case_types, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/pages/edit_projects/widgets/view_bugs.dart';
import 'package:devs_almanac/constants/style.dart';
import 'package:flutter/material.dart';
import 'widgets/add_bugs.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
import '../../auth/auth.dart';
import 'widgets/edit_stacks.dart';
import 'package:intl/intl.dart';

//Import the font package
import 'package:google_fonts/google_fonts.dart';

var bugName = "Placeholder";
var bugType = "Placeholder";
var stackID = "";
late CollectionReference collection;

List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
String _selectedStackType = StackType.first;
var selectedID = "";
final _projectInfoController = TextEditingController();

class Edit_project_page extends StatefulWidget {
  DocumentReference<Object?> project_query_doc;
  String project_ID;

  Edit_project_page({
    super.key,
    required this.project_query_doc,
    required this.project_ID,
  });

  @override
  State<Edit_project_page> createState() => _Edit_project_pageState();
}

class _Edit_project_pageState extends State<Edit_project_page> {
  refresh() {
    setState(() {
      print("refreshed edit project page");
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getProjectInfo() async {
    var doc = await widget.project_query_doc.get();
    return doc.data() as dynamic;
  }

  @override
  Widget build(BuildContext context) {
    print(selectedID);
    return Scaffold(
      appBar: AppBar(
        title: Text("Developer's Almanac", style: GoogleFonts.syneMono()),
        actions: <Widget>[
          // Clear Icon
          Builder(builder: (context) {
            return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const LogoutPopup(),
                  );
                });
          }),
        ],
        backgroundColor: AppStyle.backgroundColor,
      ),
      body: FutureBuilder(
          future: getProjectInfo(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return Text("No Data");
            }
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const project_preview_name(text: 'Project Title'),
                            project_preview_desc(
                                text: snapshot.data["project_title"]),
                            const SizedBox(
                              height: 20,
                            ),
                            const project_preview_name(
                                text: 'Project Description'),
                            project_preview_desc(
                                text: snapshot.data["project_description"]),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const project_preview_name(text: 'Project Member(s)'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AddMember(
                                            notifyParent: refresh,
                                            query_doc: widget.project_query_doc,
                                          ),
                                        );
                                      }, 
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(AppStyle.fieldText),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.person_add,
                                            size: 20,
                                            color: AppStyle.backgroundColor,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Add Member",
                                              style: TextStyle(
                                                color: AppStyle.backgroundColor
                                              )
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        
                                      }, 
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(AppStyle.fieldText),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.person_remove,
                                            size: 20,
                                            color: AppStyle.backgroundColor,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Remove Member",
                                              style: TextStyle(
                                                color: AppStyle.backgroundColor
                                              )
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ],
                                )
                              ],
                            ),
                            project_preview_desc(
                                text: snapshot.data["members"].toString()),
                            const SizedBox(
                              height: 20,
                            ),
                            const project_preview_name(text: 'Created'),
                            project_preview_desc(text: DateFormat.yMMMd().add_jm().format(snapshot.data["creation_date"].toDate())),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Horizontal Divider
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: const Divider(
                    height: 30,
                    thickness: 3,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65, right: 65, top:20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Stacks",
                            style: TextStyle(
                              color: AppStyle.sectionColor,
                              fontFamily: 'Times',
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Column(
                                    children: [
                                      AddStackPopUp(
                                          project_query_doc: widget.project_query_doc,
                                          project_id: widget.project_query_doc.id),
                                    ],
                                  )
                                );
                              }, 
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(AppStyle.sectionColor),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: AppStyle.backgroundColor,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Add Stack",
                                      style: TextStyle(
                                        color: AppStyle.backgroundColor
                                      )
                                    ),
                                  ),
                                ],
                              )
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: ViewStacks(
                                  project_query_doc: widget.project_query_doc,
                                  id: widget.project_query_doc.id,
                                  callback: refresh,
                                )),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 90),
                            child: SizedBox(
                              // width:
                              //     MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: Column(
                                children: [
                                  Card(
                                      elevation: 10,
                                      color: AppStyle.cardColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: AppStyle.borderColor,
                                              width: 1)),
                                      margin:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      // add conditional:
                                                      // if no projects, dont display sizedbox, otherwise return sizedBox
                                                      Center(
                                                          child: SizedBox(
                                                        height: 70,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 0.5,
                                                                    left: 15),
                                                            child: Column(
                                                                children: [
                                                                  bug_preview_name(
                                                                      text:
                                                                          '${bugType} : ${bugName}')
                                                                ]),
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          selectedID != ""
                                              ? ViewBugOverlay(
                                                  stackID: selectedID,
                                                  stackCollection: widget
                                                      .project_query_doc
                                                      .collection("Stack"))
                                              //notifyParent: refresh)
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, bottom: 20),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Click Stack Cards to view Stack Information",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }
}

class ViewStacks extends StatefulWidget {
  final Function() callback;
  final id;
  final DocumentReference<Object?> project_query_doc;

  const ViewStacks(
      {super.key,
      required this.project_query_doc,
      required this.id,
      required this.callback});

  @override
  State<ViewStacks> createState() => _ViewStacksState();
}

class _ViewStacksState extends State<ViewStacks> {
  late Stream<QuerySnapshot> stackStream;
  late CollectionReference stackCollection;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    stackCollection = widget.project_query_doc.collection("Stack");
    stackStream = stackCollection.snapshots();
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

        print("View Stack");

        return Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(24, 14, 41, 60),
            ),
            // width: MediaQuery.of(context).size.width * 0.5,
            // height: MediaQuery.of(context).size.height * 0.45,
            child: Column(children: [
              Row(
                children: [
                  Text(
                    'Stack Count: ${snapshot.data!.size}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      wordSpacing: 3,
                    ),
                  ),
                ],
              ),
              Divider(
                height: 30,
                thickness: 10,
                color: AppStyle.backgroundColor,
              ),
              Flexible(
                  flex: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?> stack =
                            snapshot.data!.docs[index];

                        if (!snapshot.hasData) {
                          return const Text("No Data");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        return InkWell(
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Color.fromARGB(255, 59, 173, 255),
                            highlightColor: Color.fromARGB(255, 2, 24, 42),
                            onTap: (() {
                              setState(() {
                                for (var x in StackType) {
                                  if (stack['stack_type'] == x) {
                                    _selectedStackType = x;
                                  }
                                }
                                if (_selectedIndex != index) {
                                  _selectedIndex = index;
                                  _projectInfoController.text =
                                      stack['stack_title'];
                                }

                                bugName = stack['stack_title'];
                                bugType = stack['stack_type'];
                                selectedID = stack.id;
                                collection = stackCollection;
                                widget.callback();
                              });
                            }),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: index == _selectedIndex
                                        ? const BorderSide(
                                            color: Color.fromARGB(255, 221, 226, 255),
                                            width: 2)
                                        : BorderSide(
                                            color: AppStyle.borderColor,
                                            width: 1)),
                                color: index == _selectedIndex
                                  ? const Color.fromARGB(53, 27, 27, 27)
                                  : AppStyle.cardColor,
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(children: [
                                      Expanded(
                                        child: Padding(padding: EdgeInsets.all(10), child:Text(
                                          '${stack['stack_type']}: ${stack['stack_title']}',
                                          style: TextStyle(
                                              color: AppStyle.white, fontSize: 15),
                                        ),
                                      )),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          AddBugButton(
                                            isSelected: index == _selectedIndex,
                                            project_query_doc:
                                                widget.project_query_doc,
                                            stack_id: stack.id,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      ModifyStack(
                                                        query_doc: widget
                                                            .project_query_doc,
                                                        id: stack.id,
                                                        stack_type:
                                                            stack['stack_type'],
                                                        technology: stack[
                                                            'stack_title'],
                                                      ));
                                            },
                                            color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      DeleteStackPopup(
                                                          query_doc: widget
                                                              .project_query_doc,
                                                          id: stack.id));
                                            },
                                            color: AppStyle.white,
                                          ),
                                        ],
                                      )),
                                    ]))));
                      }))
            ]));
      },
    );
  }
}

// Custom widget to show project info
class project_preview_desc extends StatelessWidget {
  final String text;
  const project_preview_desc({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
        child: Text(this.text,
            softWrap: true,
            style: TextStyle(
                color: AppStyle.descriptionText,
                fontFamily: 'Times',
                fontSize: 20,
                wordSpacing: 3)));
  }
}

class project_preview_name extends StatelessWidget {
  final String text;
  const project_preview_name({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 30, top: 10, right: 30),
        child: Text(this.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppStyle.fieldText,
                fontFamily: 'Times',
                fontSize: 22,
                wordSpacing: 3)));
  }
}
