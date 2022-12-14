import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/constants/style.dart';
import 'package:devs_almanac/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../edit_bugs/edit_bug_page.dart';

class ViewBugOverlay extends StatefulWidget {
  final Function() callback;
  final Function() notifyParent;
  final String stackID;
  final CollectionReference stackCollection;

  const ViewBugOverlay({
        super.key,
      required this.stackID,
      required this.stackCollection,
      required this.notifyParent,
      required this.callback,
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
  }

  @override
  Widget build(BuildContext context) {
    bugCollection =
        widget.stackCollection.doc(widget.stackID).collection("Bug");
    bugStream =
        bugCollection.orderBy('created_at', descending: true).snapshots();

    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 400,
        child: StreamBuilder<QuerySnapshot>(
          stream: bugStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              String error = snapshot.error.toString();
              print(error);
              return Text(error, style: const TextStyle(color: Colors.white));
            }
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return ListView(children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Object?> bug =
                        snapshot.data!.docs[index];
                    DocumentReference bugDoc = bugCollection.doc(bug.id);

                    return Card(
                      elevation: 10,
                      color: AppStyle.cardColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                              color: AppStyle.borderColor, width: 1)),
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, top: 6, right: 15, bottom: 3),
                                  ),
                                  Center(
                                    child: Text(bug['bug_name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppStyle.projectTitle,
                                            fontSize: 20,
                                            wordSpacing: 3)),
                                  ),
                                  const Divider(
                                    color: Colors.orange,
                                    thickness: 2,
                                    // indent: 10,
                                    // endIndent: 10,
                                  ),
                                  const Bug_Description_field_text(
                                      text: "Description:"),
                                  Bug_Description_Text(
                                      text: bug['bug_description']),
                                  const Bug_Description_field_text(
                                      text: "Created on:"),
                                  Bug_Description_Text(
                                      text: DateFormat.yMMMd()
                                          .add_jm()
                                          .format(bug['created_at'].toDate())),
                                  const Bug_Description_field_text(
                                      text: "Created By:"),
                                  Bug_Description_Text(text: bug['created_by']),
                                  const Bug_Description_field_text(
                                      text: "Was Solved:"),
                                  Bug_Description_Text(
                                      text: bug['is_solved'] ? "Yes" : "No"),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    //go to view bugs page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Edit_bug_page(
                                                  bug_ID: bug.id,
                                                  bug_query_doc: bugDoc,
                                                )));
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
                                            DeleteBugPopup(
                                                bugDoc: bugDoc,
                                                notifyParent:widget.notifyParent,
                                                callback: widget.callback,
                                                ));
                                  },
                                ),
                              ],
                            ),
                          ]),
                    );
                  })
            ]);
          },
        ));
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
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
              color: AppStyle.fieldText, fontSize: 18, wordSpacing: 3)),
    );
  }
}

class Bug_Description_Text extends StatelessWidget {
  final String text;
  const Bug_Description_Text({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 6, top: 6),
        child: Text(text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                color: AppStyle.white, fontSize: 15, wordSpacing: 5)));
  }
}

class DeleteBugPopup extends StatefulWidget {
  final Function() callback;
  final Function() notifyParent;
  final DocumentReference bugDoc;
  const DeleteBugPopup({
        super.key, 
        required this.bugDoc, 
        required this.notifyParent,
        required this.callback,
  });

  @override
  State<DeleteBugPopup> createState() => _DeleteBugPopupState();
}

class _DeleteBugPopupState extends State<DeleteBugPopup> {
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
            widget.bugDoc.delete().then((value) {
              print('deleted bug successfully: ${widget.bugDoc.id}');
            });
            setState(() {
              projectBugs -= 1;
            });
            widget.notifyParent();
            widget.callback();
            Navigator.of(context).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

class bug_preview_name extends StatelessWidget {
  final String text;
  const bug_preview_name({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(this.text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: AppStyle.fieldText,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 3))));
  }
}

class bug_preview_desc extends StatelessWidget {
  final String text;
  const bug_preview_desc({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(this.text,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    color: AppStyle.fieldText,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 3))));
  }
}
