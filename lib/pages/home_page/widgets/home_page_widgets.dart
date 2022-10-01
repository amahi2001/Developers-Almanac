import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

///add projects popup
class AddProjectPopup extends StatefulWidget {
  const AddProjectPopup({super.key});

  @override
  State<AddProjectPopup> createState() => _AddProjectPopupState();
}

class _AddProjectPopupState extends State<AddProjectPopup> {
  final _formKey = GlobalKey<FormState>();
  final _projectTitleController = TextEditingController();
  final _projectDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _projectTitleController,
              decoration: const InputDecoration(
                hintText: 'Project Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _projectDescriptionController,
              decoration: const InputDecoration(
                hintText: 'Project Description',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a project description';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String creation_date = DateTime.now().toString();

            if (_formKey.currentState!.validate()) {
              //add project to firestore
              FirebaseFirestore.instance.collection('Projects').add({
                'project_title': _projectTitleController.text,
                'project_description': _projectDescriptionController.text,
                'userID': FirebaseAuth.instance.currentUser!.uid,
                'creation_date': today,
                'last_updated': today,
              });
              Navigator.pop(context);
            }
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

/// This widget lets the user delete a project given a project ID
class DeleteProjectPopup extends StatefulWidget {
  String projectID;
  DeleteProjectPopup({super.key, required this.projectID});

  @override
  State<DeleteProjectPopup> createState() => _DeleteProjectPopupState();
}

class _DeleteProjectPopupState extends State<DeleteProjectPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Project'),
      content: const Text('Are you sure you want to delete this project?'),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('Projects')
                .doc(widget.projectID)
                .delete();
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
