// ignore_for_file: avoid_print, invalid_return_type_for_catch_error, camel_case_types

import 'package:devs_almanac/constants/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
//Import the font package
import 'package:google_fonts/google_fonts.dart';

import '../../auth/auth.dart';
import './widgets/home_page_widgets.dart' as wids;
import '../edit_projects/edit_project.dart';

//helpers
import '../../helpers/helper.dart';

import 'dart:math' as math;

String searchT = "";

String projectName = "";
String projectDescription = "";
String projectMembers = "";
String projectCreated = "";
List<String> projectTools = [];
int projectBugs = 0;
int _selectedIndex = -1;

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
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextField(
          onChanged: (String value) async {
            //print(value);
            ProjectsView(notifyParent: () {});
          },
          controller: _projectSearchBar,
          autofocus: true, //Display the keyboard when TextField is displayed
          cursorColor: Colors.white,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
          ),
          textInputAction: TextInputAction
              .search, //Specify the action button on the keyboard
          decoration: InputDecoration(
            //Style of TextField
            enabledBorder: const UnderlineInputBorder(
                //Default TextField border
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(
                //Borders when a TextField is in focus
                borderSide: BorderSide(color: Colors.white)),
            hintText:
                'Search keywords', //Text that is displayed when nothing is entered.
            hintStyle: GoogleFonts.poppins(
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
  bool typing = false;

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
    var username = user_obj?.displayName;
    // var screenWidth = MediaQuery.of(context).size.width;
    // var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      // Code AppBar
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
        centerTitle: true,
        title: Text("Developer's Almanac", style: GoogleFonts.syneMono()),
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const LogoutPopup(),
                        );
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const LogoutPopup(),
                        );
                      });
                }),
              ],
        backgroundColor: AppStyle.backgroundColor,
      ),
      body: ListView(
        // used to be:
        // physics: const NeverScrollableScrollPhysics(),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 30,
          ),
          // Welcome message
          Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Text(
                "Welcome back, $username",
                //overflow: TextOverflow.ellipsis,
                softWrap: true,
                textDirection: ui.TextDirection.ltr,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 47,
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.left,
              )),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Projects",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: AppStyle.sectionColor,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    height: 50,
                    thickness: 5,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const wids.AddProjectPopup(),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppStyle.sectionColor),
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
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("Add Project",
                              style:
                                  TextStyle(color: AppStyle.backgroundColor)),
                        ),
                      ],
                    )),
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
          Divider(
            height: 30,
            thickness: 0,
            color: AppStyle.backgroundColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45, right: 45),
            child: Row(
              children: [
                // Shows the projects view
                Expanded(
                  // Shows list of projects
                  child: SizedBox(
                      // width: 300,
                      height: 500,
                      child: ProjectsView(notifyParent: refresh)),
                ),
                // Shows the project description view
                Expanded(
                  child: SizedBox(
                    // Doesn't make a difference:
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 500,
                    child: Column(
                      children: [
                        Flexible(
                          child: Card(
                            elevation: 10,
                            color: AppStyle.cardColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: AppStyle.borderColor, width: 1)),
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Wrap(
                                  children: [
                                    SingleChildScrollView(
                                      child: ProjectInfoPreviewView(),
                                    ),
                                  ],
                                ),
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
    return Wrap(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // const project_preview_name(text: 'Project Title'),
            // project_preview_desc(text: projectName),
            Align(
              alignment: Alignment.center,
              child: Text(
                projectName,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: AppStyle.projectTitle, fontSize: 35, wordSpacing: 3),
              ),
            ),
            const Divider(
              color: Colors.orangeAccent,
              thickness: 3,
            ),
            const SizedBox(
              height: 25,
            ),
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
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Chip(
                        label: Text(tool),
                        backgroundColor: AppStyle.sectionColor,
                      ),
                    );
                  }).toList(),
                )),
            const project_preview_name(text: '# of bugs'),
            Visibility(
                visible: projectBugs > 0,
                child: project_preview_desc(text: projectBugs.toString())),
          ]),
        ),
      ],
    );
  }
}

/// This widget lets the user view all of their projects
class ProjectsView extends StatefulWidget {
  final Function() notifyParent;
  ProjectsView({super.key, required this.notifyParent});

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
        for (var result in querySnapshot.docs) {
          result.reference.delete();
        }
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
          return Text(error, style: GoogleFonts.poppins(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        bool snapshotIsEmpty =
            (!snapshot.hasData || snapshot.data!.docs.isEmpty);

        if (snapshotIsEmpty) {
          return Text("No Projects to show",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 30));
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
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 75,
                  child: InkWell(
                    focusColor: const Color.fromARGB(255, 2, 24, 42),
                    borderRadius: BorderRadius.circular(5),
                    splashColor: const Color.fromARGB(255, 59, 173, 255),
                    highlightColor: const Color.fromARGB(255, 2, 24, 42),
                    onTap: () async => {
                      projectTools = await getStacksAndLangs(project.reference),
                      projectBugs = await getBugCount(project.reference),
                      setState(() {
                        _selectedIndex = index;
                        projectName = project['project_title'];
                        projectDescription = project['project_description'];
                        projectMembers = project['members'].toString();
                        projectCreated = DateFormat.yMMMd()
                            .add_jm()
                            .format(project['creation_date'].toDate());
                        widget.notifyParent();
                      }),
                    },
                    child: Card(
                      elevation: 10,
                      color: index == _selectedIndex
                          ? const Color.fromARGB(53, 27, 27, 27)
                          : AppStyle.cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: index == _selectedIndex
                              ? const BorderSide(
                                  color: Color.fromARGB(255, 227, 242, 162),
                                  width: 2)
                              : const BorderSide(
                                  color: Color.fromARGB(255, 39, 138, 209),
                                  width: 1)),
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: AppStyle.projectColor[project['color_id']],
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(5))),
                                            height: 50,
                                            width: 50,
                                            child: Center(
                                                child: Text(project['project_title'][0],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 25,
                                                        color: AppStyle.white))))),
                                  ),
                                  // if user adds image, show that instead
                                  //child: Image.network('https://cdn0.iconfinder.com/data/icons/artcore/512/folder_system.png')),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 9, right: 15),
                                            child: Text(project['project_title'],
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    color: AppStyle.projectTitle,
                                                    fontSize: 20,
                                                    wordSpacing: 3))),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Text(
                                                "Updated on ${DateFormat.yMMMd().add_jm().format(project['last_updated'].toDate())}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    color: const Color.fromARGB(
                                                        255, 230, 229, 232),
                                                    fontSize: 12,
                                                    wordSpacing: 5))),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
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
                                ],
                            )
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
