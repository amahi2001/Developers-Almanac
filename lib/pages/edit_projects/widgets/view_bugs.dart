import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../edit_bug.dart';
import 'add_bugs.dart';

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

  @override
  void initState() {
    super.initState();
    print(widget.stackID);
    print("View Bugs");
    bugStream = widget.stackCollection
        .doc(widget.stackID)
        .collection("Bug")
        .orderBy('created_at', descending: true)
        .snapshots();
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
              color: const Color.fromARGB(255, 22, 66, 97),
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
                    //todo some text that says no data
                    String error = snapshot.error.toString();
                    print(error);
                    // return Text(error, style: const TextStyle(color: Colors.white));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading",
                        style: TextStyle(color: Colors.white));
                  }

                  return Column(children: [
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

                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5),
                            child: Card(
                              elevation: 10,
                              color: const Color.fromARGB(255, 30, 82, 119),
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
                                              //todo bug info
                                              child: Text(bug['bug_name'],
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 241, 240, 244),
                                                      fontSize: 20,
                                                      wordSpacing: 3))),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 6),
                                              //todo bug info
                                              child: Text(
                                                  bug['bug_description'],
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 230, 229, 232),
                                                      fontSize: 12,
                                                      wordSpacing: 5))),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        //todo navigate to edit bug/ view bug page
                                        print('edit bug');
                                        DocumentReference<Object?> bug_doc =
                                            widget.stackCollection
                                                .doc(widget.stackID)
                                                .collection("Bug")
                                                .doc(bug.id);
                                        //go to edit project page
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Edit_bug_page(
                                                      bug_query_doc: bug_doc,
                                                      bug_ID: bug.id,
                                                    )));
                                      },
                                    ),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.delete_sweep_rounded,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          //todo show "are you sure" dialog
                                          CollectionReference bugCollection =
                                              widget.stackCollection
                                                  .doc(widget.stackID)
                                                  .collection("Bug");
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  DeleteBugPopup(
                                                      bugCollection:
                                                          bugCollection,
                                                      bugID: bug.id));
                                        }),
                                  ]),
                            ),
                          );
                        })
                  ]);
                },
              ))),
    );
  }
}
