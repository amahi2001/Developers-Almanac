import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../main.dart';
import 'login_page.dart';

/// this widget let's us search through projects
class _searchTextField extends StatefulWidget {
  const _searchTextField({super.key});
  @override
  State<_searchTextField> createState() => __searchTextFieldState();
}

class __searchTextFieldState extends State<_searchTextField> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 300,
        child: TextField(
          autofocus: true, //Display the keyboard when TextField is displayed
          cursorColor: Colors.white,
          textAlign: TextAlign.left,

          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textInputAction: TextInputAction
              .search, //Specify the action button on the keyboard
          decoration: InputDecoration(
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

  @override
  void initState() {
    //if the user is not logged in and dev_mode is false, redirect to login page
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("user is not signed in");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        print('signed in as ${user.displayName}');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Code AppBar
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
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
                Builder(builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Scaffold.of(context)
                            .openEndDrawer(); // Open drawer if Profile Icon is clicked
                      });
                }),
              ]
            : [
                const _searchTextField(),
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
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        Scaffold.of(context)
                            .openEndDrawer(); // Open drawer if Profile Icon is clicked
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
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Projects",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Times',
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(
                child: SizedBox(
                  width: 900,
                ),
              ),
              // Add Project button
              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  //show popup to add project
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const AddProjectPopup(),
                    );
                  },
                ),
              ),
            ],
          ),
          projectsView(),
        ],
      ),
    );
  }
}

/// This widget lets the user view all of their projects
class projectsView extends StatefulWidget {
  const projectsView({super.key});

  @override
  State<projectsView> createState() => _projectsViewState();
}

class _projectsViewState extends State<projectsView> {
  //Querying FireStore
  CollectionReference projects =
      FirebaseFirestore.instance.collection('Projects');
  late Stream<QuerySnapshot> project_stream;

  @override
  void initState() {
    super.initState();
    String user_id = FirebaseAuth.instance.currentUser!.uid;
    // Querying FireStore
    project_stream = projects
        .orderBy("last_updated", descending: true)
        .where("userID", isEqualTo: user_id)
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
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?> project =
                  snapshot.data!.docs[index];
              return Card(
                color: Colors.deepPurple.shade100,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                        color: Colors.deepPurple.shade200, width: 1)),
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 6, right: 15, bottom: 3),
                            child: Text(project['project_title'],
                                style: TextStyle(
                                    color: Colors.deepPurple.shade900,
                                    fontSize: 20,
                                    wordSpacing: 3))),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 6),
                            child: Text(project.id,
                                style:
                                    TextStyle(fontSize: 12, wordSpacing: 5))),
                      ],
                    ),
                  ),
                  // delete project button
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
                            DeleteProjectPopup(projectID:project.id),
                      );
                    },
                  ),
                ]),
              );
            });
      },
    );
  }
}

///add projects popup
class AddProjectPopup extends StatefulWidget {
  const AddProjectPopup({super.key});

  @override
  State<AddProjectPopup> createState() => _AddProjectPopupState();
}

class _AddProjectPopupState extends State<AddProjectPopup> {
  final _formKey = GlobalKey<FormState>();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _projectTitleController,
              decoration: const InputDecoration(
                hintText: 'Project Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _projectDescriptionController,
              decoration: const InputDecoration(
                hintText: 'Project Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String creation_date = DateTime.now().toString();

            if (_formKey.currentState!.validate()) {
              //add project to firestore
              FirebaseFirestore.instance.collection('Projects').add({
                'project_title': _projectTitleController.text,
                'project_description': _projectDescriptionController.text,
                'userID': FirebaseAuth.instance.currentUser!.uid,
                'creation_date': today,
                'last_updated': today,
              });
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
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
class DeleteProjectPopup extends StatefulWidget {
  String projectID;
  DeleteProjectPopup({super.key, required this.projectID});

  @override
  State<DeleteProjectPopup> createState() => _DeleteProjectPopupState();
}

class _DeleteProjectPopupState extends State<DeleteProjectPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Project'),
      content: const Text('Are you sure you want to delete this project?'),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Projects')
                .doc(widget.projectID)
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