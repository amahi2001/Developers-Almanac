// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:devs_almanac/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../auth/auth.dart';
import './widgets/home_page_widgets.dart' as wids;
import '../edit_projects/edit_project.dart';

String searchT = "";

String projectName = "";
String projectDescription = "";
String projectMembers = "";
String projectCreated = "";
List<String> projectTools = [];

Future<List<String>> getLangs(DocumentReference stackDoc) async {
  List<String> result = [];
  await stackDoc.collection("Bug").get().then((value) => {
        value.docs.forEach((bugDoc) {
          for (var solution in bugDoc["solution"]) {
            if (!result.contains(solution["language"]) &&
                solution["language"] != "Other") {
              result.add(solution["language"]);
            }
          }
        })
      });
  return result;
}

Future<List<String>> getStacksAndLangs(DocumentReference projectDoc) async {
  List<String> result = [];
  List<String> stackIds = [];

  await projectDoc
      .collection("Stack")
      .get()
      .then((value) => {
            //adding stacks
            value.docs.forEach(
              (stackDoc) async {
                if (!result.contains(stackDoc["stack_title"])) {
                  result.add(stackDoc["stack_title"]);
                }
                if (!stackIds.contains(stackDoc.id)) {
                  stackIds.add(stackDoc.id);
                }
              },
            ),
          })
      .catchError((error) => print("Failed to get stacks and langs: $error"));

  for (var id in stackIds) {
    DocumentReference stackDoc = projectDoc.collection("Stack").doc(id);
    List<String> langs = await getLangs(stackDoc);
    for (var lang in langs) {
      if (!result.contains(lang) && lang != "Other") {
        result.add(lang);
      }
    }
  }

  return result;
}

/// this widget let's us search through projects
class _searchTextField extends StatefulWidget {
  final Function() notifyParent;
  const _searchTextField({super.key, required this.notifyParent});

  @override
  State<_searchTextField> createState() => __searchTextFieldState();
}

class __searchTextFieldState extends State<_searchTextField> {
  final TextEditingController _projectSearchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectSearchBar.addListener(() {
      setState(() {
        searchT = _projectSearchBar.text;
        widget.notifyParent();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    searchT = _projectSearchBar.text;
    return SizedBox(
        width: 300,
        child: TextField(
          onChanged: (String value) async {
            //print(value);
            ProjectsView(notifyParent: () {});
          },
          controller: _projectSearchBar,
          autofocus: true, //Display the keyboard when TextField is displayed
          cursorColor: Colors.white,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textInputAction: TextInputAction
              .search, //Specify the action button on the keyboard
          decoration: const InputDecoration(
            //Style of TextField
            enabledBorder: UnderlineInputBorder(
                //Default TextField border
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                //Borders when a TextField is in focus
                borderSide: BorderSide(color: Colors.white)),
            hintText:
                'Search keywords', //Text that is displayed when nothing is entered.
            hintStyle: TextStyle(
              //Style of hintText
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ));
  }
}

/// This is the root widget of the home page .
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool typing = true;

  refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    CollectionReference Users = FirebaseFirestore.instance.collection('Users');
    Users.doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.data() == null) {
        Users.doc(user_id).set({
          'name': user_obj?.displayName,
          'email': user_obj?.email,
          'created': user_obj?.metadata.creationTime,
          'last_login': user_obj?.metadata.lastSignInTime
        });
      } else {
        Users.doc(user_id)
            .update({'last_login': user_obj?.metadata.lastSignInTime});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Code AppBar
      key: _scaffoldKey,
      appBar: AppBar(
        // leading: Image.asset("images/logo.png"),
        title: const Text("Developer's Almanac"),
        actions: !typing
            ? <Widget>[
                // Search Icon
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      typing = true;
                    });
                  },
                ),
                // Clear Icon
                Builder(builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        Scaffold.of(context)
                            .openEndDrawer(); // Open drawer if Profile Icon is clicked
                      });
                }),
              ]
            : [
                _searchTextField(notifyParent: refresh),
                // Clear Icon
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      typing = false;
                    });
                  },
                ),
                Builder(builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        // Scaffold.of(context)
                        //     .openEndDrawer(); // Open drawer if Profile Icon is clicked
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const LogoutPopup(),
                        );
                      });
                }),
              ],
        backgroundColor: const Color.fromARGB(255, 14, 41, 60),
      ),
      endDrawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout'),
            onTap: () {
              //logout popup from auth.dart
              showDialog(
                context: context,
                builder: (BuildContext context) => const LogoutPopup(),
              );
            },
          ),
        ],
      )),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Projects",
                  style: TextStyle(
                    color: AppStyle.sectionColor,
                    fontFamily: 'Times',
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Divider(
                  height: 50,
                  thickness: 5,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const wids.AddProjectPopup(),
                    );
                  },
                )
              ],
            ),
          ),
          // Horizontal Divider
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 45),
            child: Divider(
              height: 30,
              thickness: 3,
              color: AppStyle.sectionColor,
            ),
          ),
          const Divider(
            height: 30,
            thickness: 0,
            color: Color.fromARGB(255, 14, 41, 60),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 45),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                      width: 300,
                      height: 500,
                      child: ProjectsView(notifyParent: refresh)),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 500,
                    child: Column(
                      children: [
                        Card(
                          elevation: 10,
                          color: const Color.fromARGB(255, 22, 66, 97),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 146, 153, 192),
                                  width: 1)),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: SizedBox(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      // add conditional:
                                      // if no projects, dont display sizedbox, otherwise return sizedBox
                                      SizedBox(
                                        height: 450,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: SingleChildScrollView(
                                          child: ProjectInfoPreviewView(),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectInfoPreviewView extends StatefulWidget {
  ProjectInfoPreviewView({super.key});
  @override
  State<ProjectInfoPreviewView> createState() => _ProjectInfoPreviewViewState();
}

class _ProjectInfoPreviewViewState extends State<ProjectInfoPreviewView> {
  @override
  Widget build(Object context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5, left: 15),
      child: Column(children: [
        const project_preview_name(text: 'Project Title'),
        project_preview_desc(text: projectName),
        const project_preview_name(text: 'Project Description'),
        project_preview_desc(text: projectDescription),
        const project_preview_name(text: 'Project Member(s)'),
        project_preview_desc(text: projectMembers),
        const project_preview_name(text: 'Created'),
        project_preview_desc(text: projectCreated),
        const project_preview_name(text: 'Stack & Languages'),
        Visibility(
          visible: projectTools.isNotEmpty,
          child: Wrap(
            children: projectTools.map((tool) {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Chip(
                  label: Text(tool),
                  backgroundColor: AppStyle.sectionColor,
                ),
              );
            }).toList(),
          )
        )
      ]),
    );
  }
}

/// This widget lets the user view all of their projects
class ProjectsView extends StatefulWidget {
  final Function() notifyParent;
  ProjectsView({super.key, required this.notifyParent});
  //ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  //Querying FireStore
  CollectionReference projects =
      FirebaseFirestore.instance.collection('Projects');
  late Stream<QuerySnapshot> project_stream;

  @override
  void initState() {
    super.initState();

    // Figure out how to add data to container in beginning
    projectName = "Placeholder";
    projectDescription = "Placeholder";
    projectMembers = "Placeholder";
    projectCreated = "Placeholder";

    void deleteAll() {
      projects.get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          result.reference.delete();
        });
      });
    }

    //! do not delete this method
    // deleteAll();

    super.initState();
    project_stream = projects
        .where("members", arrayContains: user_obj?.email)
        .orderBy("last_updated", descending: true)
        .snapshots();
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

        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?> project =
                  snapshot.data!.docs[index];

              if (!(project['project_title'].toLowerCase())
                  .contains(searchT.toLowerCase())) {
                return const Card();
              }

              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: InkWell(
                    onTap: () async => {
                      projectTools = await getStacksAndLangs(project.reference),
                      print(projectTools),
                      setState(() {
                        projectName = project['project_title'];
                        projectDescription = project['project_description'];
                        projectMembers = project['members'].toString();
                        projectCreated =
                            project['creation_date'].toDate().toString();
                        widget.notifyParent();
                      }),
                    },
                    child: Card(
                      elevation: 10,
                      color: theme_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(
                              color: Color.fromARGB(255, 146, 153, 192),
                              width: 1)),
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 6,
                                          right: 15,
                                          bottom: 3),
                                      child: Text(project['project_title'],
                                          style: TextStyle(
                                              color: AppStyle.projectTitle,
                                              fontSize: 20,
                                              wordSpacing: 3))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 6),
                                      child: Text(
                                          "Updated on ${project['last_updated'].toDate()}",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 229, 232),
                                              fontSize: 12,
                                              wordSpacing: 5))),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit_note_outlined,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                //
                                DocumentReference<Object?> project_doc =
                                    projects.doc(project.id);
                                //go to edit project page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Edit_project_page(
                                              project_query_doc: project_doc,
                                              project_ID: project.id,
                                            )));
                              },
                            ),
                            // Delete project button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_sweep_rounded,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      wids.DeleteProjectPopup(
                                          projectID: project.id),
                                );
                              },
                            ),
                          ]),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
