//login page
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//Import the font package
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth.dart';
import 'home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    // if the user is signed in go to home page
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print('user was already signed in as ${user.displayName}');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const MyHomePage(title: 'Developer\'s Almanac')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Login or Sign Up')),
      // ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset("images/logo.png"),
          const SizedBox(
            height: 25,
          ),
          Text(
            "DEVELOPER'S ALMANAC",
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 40),
          ),
          const SizedBox(
            height: 50,
          ),
          SignInButton(
            Buttons.Google,
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
                (e) => print(e),
              );
            },
          )
        ],
      )),
    );
  }
}
