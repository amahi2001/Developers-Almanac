import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../edit_bug.dart';
import '../edit_project.dart';

class ViewBugOverlay extends StatefulWidget {
  final String stackID;
  final CollectionReference stackCollection;
  final String stackTitle;
  final String stackType;

  const ViewBugOverlay({
    super.key,
    required this.stackID,
    required this.stackCollection,
    required this.stackTitle,
    required this.stackType,
  });

  @override
  State<ViewBugOverlay> createState() => _ViewBugOverlayState();
}

class _ViewBugOverlayState extends State<ViewBugOverlay> {
  late Stream<QuerySnapshot> bugStream;
  late CollectionReference bugCollection;

  @override
  void initState() {
    super.initState();
    bugCollection =
        widget.stackCollection.doc(widget.stackID).collection("Bug");
    bugStream =
        bugCollection.orderBy('created_at', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Card(
              elevation: 10,
              color: theme_color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 146, 153, 192), width: 1)),
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: StreamBuilder<QuerySnapshot>(
                stream: bugStream,
                builder: (BuildContext context,
                   
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    String error = snapshot.error.toString();
                    print(error);
                    return Text(error,
                        style: const TextStyle(color: Colors.white));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading",
                       
                        style: TextStyle(color: Colors.white));
                  }

                  return ListView(children: [
                    SizedBox(
                      height: 60,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.stackType}: ${widget.stackTitle}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            wordSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Bug Count: ${snapshot.data!.size}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          wordSpacing: 3,
                        ),
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          QueryDocumentSnapshot<Object?> bug =
                              snapshot.data!.docs[index];
                          DocumentReference bugDoc = bugCollection.doc(bug.id);

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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15,
                                                top: 6,
                                                right: 15,
                                                bottom: 3),
                                            child: Center(
                                              child: Text(bug['bug_name'],
                                  
                                                  style: const TextStyle(
                                                      color: Colors.orange,
                                                      fontSize: 20,
                                                      wordSpacing: 3)),
                                            )),
                                        const Divider(
                                          color: Colors.orange,
                                          thickness: 2,
                                          // indent: 10,
                                          // endIndent: 10,
                                        ),
                                        const Bug_Description_field_text(text: "Description:"),
                                        Bug_Description_Text(
                                            text: bug['bug_description']),
                                        const Bug_Description_field_text(text: "Created on:"),
                                        Bug_Description_Text(
                                            text: bug['created_at']
                                                .toDate()
                                                .toString()),
                                        const Bug_Description_field_text(text: "Was Solved:"),
                                        Bug_Description_Text(
                                            text: bug['is_solved'] ? "Yes" : "No"),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_note_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      //todo go to edit bug page
                                    },
                                  ),
                                  // Delete project button
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_sweep_rounded,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DeleteBugPopup(bugDoc: bugDoc));
                                    },
                                  ),
                                ]),
                          );
                        })
                  ]);
                },
              ))),
    );
  }
}

class Bug_Description_field_text extends StatelessWidget {
  final String text;
  const Bug_Description_field_text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(text,
          style: const TextStyle(color: Colors.limeAccent, fontSize: 18, wordSpacing: 3)),
    );
  }
}

class Bug_Description_Text extends StatelessWidget {
  final String text;
  const Bug_Description_Text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 6, top: 6),
        child: Text(text,
            style:
                const TextStyle(color: white, fontSize: 15, wordSpacing: 5)));
  }
}

class DeleteBugPopup extends StatelessWidget {
  final DocumentReference bugDoc;
  const DeleteBugPopup({super.key, required this.bugDoc});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Bug'),
      content: const Text('Are you sure you want to delete this bug?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            bugDoc.delete().then((value) {
              print('deleted bug successfully: ${bugDoc.id}');
            });
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
