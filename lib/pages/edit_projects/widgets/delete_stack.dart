// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/pages/edit_projects/edit_project.dart';
import 'package:flutter/material.dart';

import '../../../helpers/helper.dart';
import '../../home_page/home_page.dart';

/// This widget lets the user delete a stack given a stack ID
class DeleteStackPopup extends StatefulWidget {
  final Function() callback;
  final Function() notifyParent;
  final id;
  final DocumentReference<Object?> query_doc;
  final stackName;

  const DeleteStackPopup({
      super.key,
      required this.query_doc,
      required this.id,
      required this.callback,
      required this.notifyParent,
      required this.stackName,
  });

  @override
  State<DeleteStackPopup> createState() => _DeleteStackPopupState();
}

class _DeleteStackPopupState extends State<DeleteStackPopup> {
  late DocumentReference<Object?> stackDoc;
  int stackNum = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Stack'),
      content: const Text('Are you sure you want to delete this stack?'),
      actions: [
        TextButton(
          onPressed: () async {
            print(widget.id);
            widget.query_doc.collection('Stack').doc(widget.id).delete();
            projectTools.remove(widget.stackName);
            stackDoc = widget.query_doc.collection('Stack').doc(widget.id);
            stackNum = await getBugsInStack(stackDoc);
            projectBugs -= stackNum;
            widget.callback();
            widget.notifyParent();
            selectedID = "";
            stackName = "Placeholder";
            stackType = "Placeholder";
            stackID = "";
            bugCount = null;
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
