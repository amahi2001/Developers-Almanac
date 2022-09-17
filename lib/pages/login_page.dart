//login page
import 'package:flutter/material.dart';

import '../auth.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Login or Sign Up')),
      // ),
      body: Center(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Image.asset("images/logo.png"),
          SizedBox(
            height: 20,
          ),
          Text(
            "DEVELOPER'S ALMANAC",
            style: TextStyle(
                color: Colors.white, fontFamily: 'Times', fontSize: 50),
          ),
          SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
            onPressed: () async {
              await signInWithGoogle().then((value) {
                print("${value.user!.email} has logged in");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'Developer\'s Almanac')),
                );
              }).catchError(
                (e) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(e.toString()),
                ),
              );
            },
            icon: Icon(Icons.login),
            label: Text('Login with Google'),
          )
        ],
      )),
    );
  }
}
