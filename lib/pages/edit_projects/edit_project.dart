import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/pages/edit_projects/widgets/view_bugs.dart';
import 'package:flutter/material.dart';
import 'widgets/add_bugs.dart';
import 'widgets/add_collab.dart';
import 'widgets/add_stack.dart';
// import '/auth.dart';
import 'widgets/edit_stacks.dart';

const Color white = Color.fromARGB(255, 255, 255, 255);
const Color red = Color.fromARGB(255, 255, 0, 0);

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
    return Scaffold(
      appBar: AppBar(
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
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
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
                // project_preview_attr(text: widget.title),
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 6, right: 15),
                    child: Text(snapshot.data["project_title"],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 230, 229, 232),
                            fontSize: 25,
                            wordSpacing: 3))),
                project_preview_attr(
                    text: snapshot.data["project_description"]),
                project_preview_attr(text: snapshot.data["members"].toString()),
                project_preview_attr(
                    text: snapshot.data["creation_date"].toDate().toString()),
                // Horizontal Divider
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
                      child: const Icon(Icons.add),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => Column(
                                  children: [
                                    AddStackPopUp(
                                        project_query_doc:
                                            widget.project_query_doc,
                                        project_id:
                                            widget.project_query_doc.id),
                                  ],
                                ));
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 30,
                  thickness: 0,
                  color: Color.fromARGB(255, 14, 41, 60),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: ViewStacks(
                          project_query_doc: widget.project_query_doc,
                          id: widget.project_query_doc.id,
                          callback: () {},
                        )),
                  ],
                )
              ],
            );
          })),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: const Color.fromARGB(123, 223, 211, 211),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AddMember(
                    notifyParent: refresh,
                    query_doc: widget.project_query_doc,
                  ),
                );
              },
              child: const Icon(Icons.person_add),
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
                        QueryDocumentSnapshot<Object?> stack =
                            snapshot.data!.docs[index];

                        if (!snapshot.hasData) {
                          print('test phrase');
                          return const Text("No Data");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return InkWell(
                            onTap: (() {
                              setState(() {
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
                              });

                              //show Bugs in Stack
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      ViewBugOverlay(
                                        stackID: stack.id,
                                        stackCollection: stackCollection,
                                        stackTitle: stack['stack_title'],
                                        stackType: stack['stack_type'],
                                      ));
                            }),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 146, 153, 192),
                                        width: 1)),
                                color: index == _selectedIndex
                                    ? const Color.fromARGB(255, 14, 41, 60)
                                    : const Color.fromARGB(255, 22, 66, 97),
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(children: [
                                      Expanded(
                                        child: Text(
                                          '${stack['stack_type']}: ${stack['stack_title']}',
                                          style: TextStyle(
                                              color: index == _selectedIndex
                                                  ? red
                                                  : white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AddBugButton(
                                              isSelected:
                                                  index == _selectedIndex,
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
                                                          stack_type: stack[
                                                              'stack_type'],
                                                          technology: stack[
                                                              'stack_title'],
                                                        ));
                                              },
                                              color: index == _selectedIndex
                                                  ? red
                                                  : const Color.fromARGB(
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
                                              color: index == _selectedIndex
                                                  ? red
                                                  : white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]))));
                      }))
            ]));
      },
    );
  }
}

// Custom widget to show project info
class project_preview_attr extends StatelessWidget {
  final String text;
  const project_preview_attr({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 6, right: 15),
        child: Text(this.text,
            style: const TextStyle(
                color: Color.fromARGB(255, 241, 240, 244),
                fontFamily: 'Times',
                fontSize: 20,
                wordSpacing: 3)));
  }
}
