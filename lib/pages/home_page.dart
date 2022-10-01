import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../main.dart';
import 'home_page/widgets/home_page_widgets.dart';
import 'login_page.dart';

String searchT = "";
var numCalled = 0;

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
            projectsView();
            numCalled += 1;
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
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(
                height: 70,
                thickness: 5,
              ),
            ],
          ),
          Divider(
            height: 30,
            thickness: 3,
            color: Colors.white,
          ),
          Divider(
            height: 30,
            thickness: 0,
            color: Color.fromARGB(255, 14, 41, 60),
          ),
          projectsView(),
        ],
      ),
      // Add Project button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(123, 223, 211, 211),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AddProjectPopup(),
          );
        },
      ),
    );
  }
}

/// This widget lets the user view all of their projects
class projectsView extends StatefulWidget {
  projectsView({super.key});

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
    project_stream = projects
        .where("userID", isEqualTo: user_id)
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

              return Card(
                color: const Color.fromARGB(255, 22, 66, 97),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 146, 153, 192), width: 1)),
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 241, 240, 244),
                                    fontSize: 20,
                                    wordSpacing: 3))),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 6),
                            child: Text(project.id,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 230, 229, 232),
                                    fontSize: 12,
                                    wordSpacing: 5))),
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
                            DeleteProjectPopup(projectID: project.id),
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
