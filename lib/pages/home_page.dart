import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../main.dart';
import 'login_page.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool typing = true;

  //Querying FireStore
  CollectionReference projects =
      FirebaseFirestore.instance.collection('Projects');
  late Stream<QuerySnapshot> project_stream;

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
      }
      else{
        print('signed in as ${user.displayName}');
      }
    });
    String user_id = FirebaseAuth.instance.currentUser!.uid;
    // Querying FireStore
    project_stream = projects.snapshots();
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
              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: project_stream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text(data['project_title']),
                    // subtitle: Text(data['description']),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
