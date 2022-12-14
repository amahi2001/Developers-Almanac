// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';

User? user_obj = FirebaseAuth.instance.currentUser;
String? user_id = user_obj?.uid;

// this file handle everything about authentication except the login page
// E.g. sign in, sign up, sign out (including styling)

Future<UserCredential> signInWithGoogle() async {
  /*this function is the google sign in method*/

  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  // googleProvider.setCustomParameters({
  //   'login_hint': 'user@example.com'
  // });

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

//logout popup
class LogoutPopup extends StatefulWidget {
  const LogoutPopup({super.key});
  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              print("user has signed out");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }).catchError(
              (e) => print(e)
            );
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
