import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBugButton extends StatefulWidget {
  final bool isSelected;
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;

  const AddBugButton(
      {super.key,
      required this.isSelected,
      required this.project_query_doc,
      required this.stack_id});

  @override
  State<AddBugButton> createState() => _AddBugButtonState();
}

class _AddBugButtonState extends State<AddBugButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bug_report),
      color: widget.isSelected
          ? const Color.fromARGB(255, 255, 0, 0)
          : Color.fromARGB(255, 193, 125, 47),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AddBugPopUp(
                project_query_doc: widget.project_query_doc,
                stack_id: widget.stack_id));
      },
    );
  }
}

class AddBugPopUp extends StatefulWidget {
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;
  const AddBugPopUp(
      {super.key, required this.project_query_doc, required this.stack_id});

  @override
  State<AddBugPopUp> createState() => _AddBugPopUpState();
}

class _AddBugPopUpState extends State<AddBugPopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Bug ${widget.stack_id}'),
      // content: const Text('Are you sure you want to add this bug?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Add'),
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
