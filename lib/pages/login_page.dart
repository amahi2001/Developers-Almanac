//login page
// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
// Import the font package
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth.dart';
import '../constants/style.dart';
import 'home_page/home_page.dart';
// Import animated background
import 'package:animated_background/animated_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
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

  // Animated Background
  ParticleOptions particles = const ParticleOptions(
    baseColor: Color.fromARGB(255, 255, 255, 255),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 70,
    spawnMaxRadius: 15.0,
    spawnMaxSpeed: 100.0,
    spawnMinSpeed: 30,
    spawnMinRadius: 7.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: const Text('Login or Sign Up')),
      // ),
      appBar: AppBar(
        leading: Image.asset("images/logo.png"),
        centerTitle: true,
        title: Text("Developer's Almanac", style: GoogleFonts.syneMono()),
        actions: <Widget>[
          Builder(builder: (context) {
            return SizedBox(
              width: 200,
              child: SignInButton(
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
              ),
            );
          }),
        ],
        backgroundColor: AppStyle.backgroundColor,
      ),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options: particles),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 120,
                ),
                Text(
                  "WHAT IS DEVELOPER'S ALMANAC ?",
                  style: GoogleFonts.abrilFatface(
                      color: Colors.orange, fontSize: 60),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        // width: 400, height: 170,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Container(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  )
                                ]),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text("RECREATE",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.syneMono(
                                        color: AppStyle.sectionColor,
                                        fontSize: 50,
                                      )),
                                  Text(
                                    "Bugs, \nErrors",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                            ))),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        // width: 400, height: 80,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                )
                              ]),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text("REINFORCE",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.syneMono(
                                      color: AppStyle.sectionColor,
                                      fontSize: 50,
                                    )),
                                Text(
                                  "Learning practices \n [ programming language, framework ]",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 20),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                        // width: 400, height: 500,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.13,
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                )
                              ]),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text("REFINE",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.syneMono(
                                      color: AppStyle.sectionColor,
                                      fontSize: 50,
                                    )),
                                Text(
                                  "Your code \n Your craft",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      "“ A web app that allows developers to log bugs and errors in a framework and/or project specific manner throughout a project’s lifecycle “",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 500,
                  child: Text(
                    "PROBLEM",
                    style: GoogleFonts.abrilFatface(
                        color: Colors.orange, fontSize: 60),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      width: 1000,
                      child: Text(
                        "Traditional methods of logging errors such as commit messages and issue logs on version control services (e.g GitHub, Gitlab, BitBucket, etc) are disorganized \n  * Poor visualization, breakdown, intimidating for beginners and new maintainers",
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      )),
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 500,
                    child: Text(
                      "WHO ARE YOU ?",
                      style: GoogleFonts.abrilFatface(
                          color: Colors.orange, fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: 250,
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "An Individual trying \n to learn a new stack/ \n framework",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: AppStyle.sectionColor, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // const VerticalDivider(
                    //   width: 20,
                    //   thickness: 10,
                    //   indent: 5,
                    //   endIndent: 5,
                    //   color: Colors.orangeAccent,
                    // ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: 250,
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "Dev teams who are \n looking to \n meticulously log \n bugs",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: AppStyle.sectionColor, fontSize: 20),
                          textAlign: TextAlign.center,
                          // QA, cyber security (zero days, bug reproduction)
                          // Extensive docs for maintainers"
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: 250,
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "Developers who are \n trying to minimize \n debug time",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: AppStyle.sectionColor, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: 250,
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "Educator’s who \n implement project- \n based learning",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: AppStyle.sectionColor, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        // width: 250,
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "Anyone else who \n wants to learn \n from their \n mistakes",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: AppStyle.sectionColor, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 500,
                    child: Text(
                      "OUR VISION",
                      style: GoogleFonts.abrilFatface(
                          color: Colors.orange, fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 1000,
                    child: Text(
                      "To improve the lives of programmers / developers. Through the creation of this application, we hope to see a decrease in the amount of time taken to solve a recurring bug / roadblock or reproduce a roadblock in hopes of increasing productivity (and sanity)",
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
