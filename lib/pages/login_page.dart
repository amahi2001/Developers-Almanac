//login page
// ignore_for_file: avoid_print

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
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(
                height: 120,
              ),
              SizedBox(
                width: 500,
                child: Text(
                  "WHAT IS DEVELOPER'S ALMANAC ?",
                  style: GoogleFonts.abrilFatface(
                      color: Colors.orange, fontSize: 60),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 450,
                      // height: 500,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text("RECREATE",
                                style: GoogleFonts.syneMono(
                                  color: AppStyle.sectionColor,
                                  fontSize: 50,
                                )),
                            Text(
                              "Bugs, Errors",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                      width: 450,
                      // height: 500,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text("REINFORCE",
                                style: GoogleFonts.syneMono(
                                  color: AppStyle.sectionColor,
                                  fontSize: 50,
                                )),
                            Text(
                              "Learning practices [ programming language, framework ]",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                      width: 450,
                      // height: 500,
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text("REFINE",
                                style: GoogleFonts.syneMono(
                                  color: AppStyle.sectionColor,
                                  fontSize: 50,
                                )),
                            Text(
                              "blah blah blah something idk",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 20),
                            )
                          ],
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
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 25),
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
                  child: Column(
                    children: [
                      Text(
                        "Traditional methods of logging errors such as commit messages and issue logs on version control services (e.g GitHub, Gitlab, BitBucket, etc) are disorganized",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        " - Poor visualization, breakdown, intimidating for beginners and new maintainers",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
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
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 250,
                      child: Text(
                        "An Individual trying to learn a new stack/ framework",
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
                      width: 250,
                      child: Text(
                        "Dev teams who are looking to meticulously log bugs",
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
                      width: 250,
                      child: Text(
                        "Developers who are trying to minimize debug time",
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
                      width: 250,
                      child: Text(
                        "Educator’s who implement project-based learning",
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
                      width: 250,
                      child: Text(
                        "Anyone else who wants to learn from their mistakes",
                        style: GoogleFonts.poppins(
                            color: AppStyle.sectionColor, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
