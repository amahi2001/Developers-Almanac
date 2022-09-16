import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

// this file handle everything about authentication
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

//login page
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

//logout popup
class LogoutPopup extends StatefulWidget {
  const LogoutPopup({super.key, required this.user_email});
  final String user_email;
  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: Text('Are you sure you want to logout?'),
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
              (e) => AlertDialog(
                title: const Text('Error'),
                content: Text(e.toString()),
              ),
            );
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
