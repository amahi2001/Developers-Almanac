import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/constants/style.dart';
import 'package:flutter/material.dart';

//syntax highlight
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

import '../edit_projects/edit_project.dart';
import 'edit_solution.dart';
import '../edit_projects/widgets/view_bugs.dart';

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

  Future<dynamic> getBugInfo() async {
    var doc = await widget.bug_query_doc.get();
    return doc.data() as dynamic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Developer's Almanac"),
          actions: <Widget>[
            // Clear Icon
            Builder(builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Scaffold.of(context)
                        .openEndDrawer(); // Open drawer if Profile Icon is clicked
                  });
            }),
          ],
          backgroundColor: const Color.fromARGB(255, 14, 41, 60),
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

            return Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            const bug_preview_name(text: 'Bug Name'),
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
                                text: snapshot.data["created_at"]
                                    .toDate()
                                    .toString()),
                            const Divider(
                              height: 30,
                              thickness: 0,
                              color: Color.fromARGB(255, 14, 41, 60),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // Horizontal Divider
                  const Divider(
                    height: 30,
                    thickness: 3,
                    color: Colors.white,
                  ),
                  const Divider(
                    height: 30,
                    thickness: 0,
                    color: Color.fromARGB(255, 14, 41, 60),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                              AddSolution(
                                                query_doc: widget.bug_query_doc,
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: code.length,
                                    itemBuilder: (context, index) {
                                      Map bugInfo = code[index];
                                      // print(bugInfo);
                                      return Card(
                                         elevation: 10,
                                        color: theme_color,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            side: const BorderSide(
                                                color: Color.fromARGB(255, 146, 153, 192),
                                                width: 1)),
                                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Bug_Description_field_text(text: "Language:"),
                                                Bug_Description_Text(text: bugInfo['language']),
                                                const Bug_Description_field_text(text: "Created On:"),
                                                Bug_Description_Text(text: bugInfo['time']),
                                                const Bug_Description_field_text(text: "Solution:"),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 6, top: 6),
                                                  child: HighlightView(
                                                    bugInfo['solution'],
                                                    language: bugInfo['language'],
                                                    theme: githubTheme,
                                                    textStyle: const TextStyle(
                                                      fontFamily: 'Ubuntu',
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_note_outlined,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                        ModifySolution(
                                                          query_doc: widget.bug_query_doc,
                                                          bug_index: index,
                                                          bug_info: bugInfo,
                                                          solution_list: code,
                                                        )
                                                    );
                                                  }
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete_sweep_rounded,
                                                      size: 30,
                                                      color: Colors.red,
                                                    ),
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) => DeleteSolutionPopup(
                                                        query_doc: widget.bug_query_doc, 
                                                        bug_index: index,
                                                        solution_list: code,
                                                      )
                                                    );
                                                  }
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      );
                                    }
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ]
                    )
                  )
                ],
              ),
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
        child: Text(this.text,
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
            style: TextStyle(
                color: AppStyle.fieldText,
                fontFamily: 'Times',
                fontSize: 22,
                wordSpacing: 3)));
  }
}
