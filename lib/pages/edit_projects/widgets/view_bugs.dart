
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

  late Stream<DocumentSnapshot> bugStream;

  @override
  void initState() {
    super.initState();
    print(widget.stackID);
    bugStream = widget.stackCollection.doc(widget.stackID).snapshots();
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder(builder: (context, snapshot) {
        
        if (snapshot.hasData) {
          return Container(
            child: Text(snapshot.data.toString()),
          );
        } else {
          return Container(
            child: Text("No data"),
          );
        }
      });
      
  }
}