
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewBugOverlay extends StatefulWidget {
  final String stackID;
  final CollectionReference stackCollection;

  const ViewBugOverlay({super.key, required this.stackID, required this.stackCollection});

  @override
  State<ViewBugOverlay> createState() => _ViewBugOverlayState();
}

class _ViewBugOverlayState extends State<ViewBugOverlay> {

  late Stream<QuerySnapshot> bugStream;

  @override
  void initState() {
    super.initState();
    print(widget.stackID);
    bugStream = widget.stackCollection.doc(widget.stackID).collection('Bugs').snapshots();
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
      stream: bugStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          //todo some text that says no data
          // String error = snapshot.error.toString();
          // print(error);
          // return Text(error, style: const TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading", style: TextStyle(color: Colors.white));
        }

        return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?> bug =
                  snapshot.data!.docs[index];
              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: InkWell(
                    onTap: () => {
                      //todo navigate to edit bug/ view bug page
                    },
                    child: Card(
                      elevation: 10,
                      color: const Color.fromARGB(255, 22, 66, 97),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          top: 6,
                                          right: 15,
                                          bottom: 3),
                                          //todo bug info
                                      child: Text("some info",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 241, 240, 244),
                                              fontSize: 20,
                                              wordSpacing: 3))),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15, bottom: 6),
                                          //todo bug info
                                      child: Text(
                                          "bug info",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 229, 232),
                                              fontSize: 12,
                                              wordSpacing: 5))),
                                ],
                              ),
                            ),
                            // Delete project button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_sweep_rounded,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                //todo show "are you sure" dialog
                              },
                            ),
                          ]),
                    ),
                  ),
                ),
              );
            });
      },
    );

  }
}