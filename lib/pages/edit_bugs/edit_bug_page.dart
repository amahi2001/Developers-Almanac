import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/constants/style.dart';
import 'package:devs_almanac/pages/edit_bugs/widgets/edit_bug_details.dart';
import 'package:flutter/material.dart';

//syntax highlight
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';

import '../../auth/auth.dart';
import 'widgets/add_solution.dart';
import 'widgets/edit_solution.dart';
import '../edit_projects/widgets/view_bugs.dart';
import 'package:intl/intl.dart';
//Import the font package
import 'package:google_fonts/google_fonts.dart';

class Edit_bug_page extends StatefulWidget {
  final DocumentReference<Object?> bug_query_doc;
  final String bug_ID;

  Edit_bug_page({super.key, required this.bug_query_doc, required this.bug_ID});

  @override
  State<Edit_bug_page> createState() => _Edit_bug_pageState();
}

class _Edit_bug_pageState extends State<Edit_bug_page> {
  @override
  void initState() {
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  Future<dynamic> getBugInfo() async {
    var doc = await widget.bug_query_doc.get();
    return doc.data() as dynamic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Developer's Almanac", style: GoogleFonts.syneMono()),
          actions: <Widget>[
            // Clear Icon
            Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const LogoutPopup(),
                    );
                  });
            }),
          ],
          backgroundColor: AppStyle.backgroundColor,
        ),
        body: FutureBuilder(
          future: getBugInfo(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return const Text("No Data");
            }

            List code = snapshot.data["solution"];

            return ListView(
              children: [
                /* Bug description ----------------------------------------------*/
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const bug_preview_name(text: 'Bug Name'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                EditBugDetail(
                                                    notifyParent: refresh,
                                                    bug_query_doc: widget.bug_query_doc, 
                                                    bug_name: snapshot.data["bug_name"], 
                                                    bug_description: snapshot.data["bug_description"], 
                                                    bug_error: snapshot.data["error_output"]
                                                )
                                          );
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(AppStyle.fieldText),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.bug_report,
                                              size: 20,
                                              color: AppStyle.backgroundColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text("Edit Bug Information",
                                                  style: TextStyle(
                                                      color: AppStyle
                                                          .backgroundColor)),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                            bug_preview_desc(text: snapshot.data["bug_name"]),
                            const SizedBox(
                              height: 20,
                            ),
                            const bug_preview_name(text: 'Bug Description'),
                            bug_preview_desc(
                                text: snapshot.data['bug_description']),
                            const SizedBox(
                              height: 20,
                            ),
                            const bug_preview_name(text: 'Error Output'),
                            bug_preview_desc(
                                text: snapshot.data["error_output"]),
                            const SizedBox(
                              height: 20,
                            ),
                            const bug_preview_name(text: 'Bug Created'),
                            bug_preview_desc(
                                text: DateFormat.yMMMd().add_jm().format(
                                    snapshot.data["created_at"].toDate())),
                            const SizedBox(
                              height: 20,
                            ),
                            const bug_preview_name(text: 'Created By'),
                            bug_preview_desc(text: snapshot.data["created_by"]),
                            Divider(
                              height: 30,
                              thickness: 0,
                              color: AppStyle.backgroundColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Horizontal Divider
                const Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: Divider(
                    height: 30,
                    thickness: 3,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Divider(
                    height: 30,
                    thickness: 0,
                    color: AppStyle.backgroundColor,
                  ),
                ),
                /*Bug Solutions -------------------------------------------------*/
                Padding(
                    padding: const EdgeInsets.only(left: 65, right: 65),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Bug Solution(s)",
                                    style: TextStyle(
                                      color: AppStyle.sectionColor,
                                      fontFamily: 'Times',
                                      fontSize: 25,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AddSolution(
                                                  query_doc:
                                                      widget.bug_query_doc,
                                                  notifyParent: refresh,
                                                ));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppStyle.sectionColor),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 20,
                                            color: AppStyle.backgroundColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5),
                                            child: Text("Add Solution",
                                                style: TextStyle(
                                                    color: AppStyle
                                                        .backgroundColor)),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //Solution List ------------------------------------------------
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: code.length,
                                  itemBuilder: (context, index) {
                                    Map bugInfo = code[index];
                                    // print(bugInfo);
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Card(
                                          elevation: 10,
                                          color: AppStyle.cardColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              side: BorderSide(
                                                  color: AppStyle.borderColor,
                                                  width: 1)),
                                          margin: const EdgeInsets.fromLTRB(
                                              5, 5, 5, 10),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Bug_Description_field_text(
                                                          text: "Language:"),
                                                      Bug_Description_Text(
                                                          text: bugInfo[
                                                              'language']),
                                                      const Bug_Description_field_text(
                                                          text: "Created On:"),
                                                      bug_preview_desc(
                                                          text: DateFormat
                                                                  .yMMMd()
                                                              .add_jm()
                                                              .format(DateTime
                                                                  .parse(bugInfo[
                                                                      'time']))),
                                                      const Bug_Description_field_text(
                                                          text:
                                                              "Solution Name"),
                                                      Bug_Description_Text(
                                                          text: bugInfo[
                                                              'solution_name']),
                                                      const Bug_Description_field_text(
                                                          text: "Solution:"),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Wrap(
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 15,
                                                                        right: 15,
                                                                        bottom: 6,
                                                                        top: 6),
                                                                child: Card(
                                                                  color: const Color(0xff002b36),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      side: BorderSide(
                                                                          color: AppStyle
                                                                              .borderColor,
                                                                          width:
                                                                              1)),
                                                                  child: Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      
                                                                    child: HighlightView(
                                                                        bugInfo[
                                                                      'solution'],
                                                                        language: bugInfo[
                                                                      'language'],
                                                                        theme: solarizedDarkTheme
                                                                      ,
                                                                        textStyle:
                                                                      const TextStyle(
                                                                      
                                                                    fontFamily:
                                                                        'Ubuntu',
                                                                    fontSize: 16,
                                                                        ),
                                                                      ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      iconPadding(
                                                        child: IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .edit_note_outlined,
                                                              size: 30,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      ModifySolution(
                                                                        notifyParent:
                                                                            refresh,
                                                                        query_doc:
                                                                            widget.bug_query_doc,
                                                                        bug_index:
                                                                            index,
                                                                        bug_info:
                                                                            bugInfo,
                                                                        solution_list:
                                                                            code,
                                                                      ));
                                                            }),
                                                      ),
                                                      iconPadding(
                                                        //delete solution
                                                        child: IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_sweep_rounded,
                                                              size: 30,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      DeleteSolutionPopup(
                                                                        notifyParent:
                                                                            refresh,
                                                                        query_doc:
                                                                            widget.bug_query_doc,
                                                                        bug_index:
                                                                            index,
                                                                        solution_list:
                                                                            code,
                                                                      ));
                                                            }),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ))),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            );
          }),
        ));
  }
}

// Custom widget to show project info
class bug_preview_desc extends StatelessWidget {
  final String text;
  const bug_preview_desc({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 6, right: 15),
        child: Text(text,
            softWrap: true,
            style: TextStyle(
                color: AppStyle.descriptionText,
                fontFamily: 'Times',
                fontSize: 20,
                wordSpacing: 3)));
  }
}

class bug_preview_name extends StatelessWidget {
  final String text;
  const bug_preview_name({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 6, right: 15),
        child: Text(this.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: AppStyle.fieldText,
                fontFamily: 'Times',
                fontSize: 22,
                wordSpacing: 3)));
  }
}

class iconPadding extends StatelessWidget {
  final Widget child;
  const iconPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        //delete solution
        child: child);
  }
}
