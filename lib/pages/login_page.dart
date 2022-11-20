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
          child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            // const SizedBox(
            //   height: 100,
            // ),
            Image.asset("images/logo.png"),
            SizedBox(
              //height: 25,
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Text(
              "DEVELOPER'S ALMANAC",
              softWrap: true,
              style: GoogleFonts.robotoSlab(color: Colors.white, fontSize: 50),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              //height: 50,
              height: MediaQuery.of(context).size.height * 0.1,
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
        ),
      )),
    );
  }
}
