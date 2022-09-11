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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            await signInWithGoogle().then((value) {
              print("${value.user!.email} has logged in");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'HELLO')),
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
        ),
      ),
    );
  }
}

//logout button
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut().then((value) {
          print("User has signed out");
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
      child: const Text('Sign out'),
    );
  }
}