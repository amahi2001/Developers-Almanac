import 'package:devs_almanac/auth.dart';
import 'package:flutter/material.dart';

// TO BE DELETED
// void main() => runApp(const AppBarApp());

// class AppBarApp extends StatelessWidget {
//   const AppBarApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: AppBarHome(),
//     );
//   }
// }

// class AppBarHome extends StatelessWidget {
//   const AppBarHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//       title: const Text("Developer's Almanac"),
//     ));
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool typing = false;

  // Code for search bar
  Widget _searchTextField() {
    return TextField(
      autofocus: true, //Display the keyboard when TextField is displayed
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction:
          TextInputAction.search, //Specify the action button on the keyboard
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Code AppBar
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
        title: !typing ? Text("Developer's Almanac") : _searchTextField(),
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
                )
              ]
            : [
                // Clear Icon
                IconButton(
                  icon: Icon(
                    Icons.clear,
                  ),
                  onPressed: () {
                    setState(() {
                      typing = false;
                    });
                  },
                )
              ],
        backgroundColor: Color.fromARGB(255, 14, 41, 60),
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Logout'),
          ),
        ],
      )),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Projects",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Times',
              fontSize: 30,
            ),
          ),
          SizedBox(
            width: 900,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      )),
    );
  }
}
