// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/auth/auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../../constants/style.dart';
import '../../../main.dart';
import '../../edit_projects/edit_project.dart' as global;
import '../home_page.dart';

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
  final _stackNameController = TextEditingController();
  late String _selectedStackType = global.StackType.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Project'),
      content: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
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
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 5,
                  controller: _projectDescriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Project Description',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.blueAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a project description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _selectedStackType,
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                _selectedStackType = value!;
                              });
                            },
                            items: global.StackType.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                          child: TextFormField(
                        controller: _stackNameController,
                        decoration: const InputDecoration(
                          hintText: 'Primary stack item',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a stack item description';
                          }
                          return null;
                        },
                      ))
                    ],
                  ),
                )
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Random random = new Random();
              CollectionReference projects =
                  FirebaseFirestore.instance.collection('Projects');
              //add project to firestore
              projects
                  .add(
                    {
                      'project_title': _projectTitleController.text,
                      'project_description': _projectDescriptionController.text,
                      'userID': user_id,
                      'creation_date': today,
                      'last_updated': today,
                      'members': [user_obj?.email],
                      'color_id': random.nextInt(19),
                    },
                  )
                  .then(((value) =>
                      //todo fix up this form
                      projects.doc(value.id).collection("Stack").add({
                        'stack_type': _selectedStackType,
                        'stack_title': _stackNameController.text,
                      })))
                  .catchError(
                      (error) => print("Failed to add project: $error"));
              //todo should have a error popup here

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
  final Function notifyParent;
  String projectID;
  DeleteProjectPopup(
      {super.key, required this.projectID, required this.notifyParent});

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
                .delete()
                .then((value) => {
                      print("Project deleted"),
                      widget.notifyParent(),
                      projectName = "",
                      projectDescription = "",
                      projectMembers = "",
                      projectCreated = "",
                      projectTools = [],
                      projectBugs = 0,
                    })
                .catchError(
                    (error) => {print("Failed to delete project: $error")});
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

/// This widget lets the user show the selected project's information
class ShowProjectPopup extends StatefulWidget {
  String project_ID;
  final String title;
  String description;
  List<dynamic> members;
  String created;
  ShowProjectPopup(
      {super.key,
      required this.project_ID,
      required this.title,
      required this.description,
      required this.members,
      required this.created});

  @override
  State<ShowProjectPopup> createState() => _ShowProjectPopupState();
}

class _ShowProjectPopupState extends State<ShowProjectPopup> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Card(
          elevation: 10,
          color: AppStyle.cardColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: AppStyle.borderColor, width: 1)),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
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
                    const project_preview_name(text: 'Project Title'),
                    project_preview_desc(text: widget.title),
                    const SizedBox(
                      height: 20,
                    ),
                    const project_preview_name(text: 'Project Description'),
                    project_preview_desc(text: widget.description),
                    const SizedBox(
                      height: 20,
                    ),
                    const project_preview_name(text: 'Project Member(s)'),
                    project_preview_desc(text: widget.members.toString()),
                    const SizedBox(
                      height: 20,
                    ),
                    const project_preview_name(text: 'Created'),
                    project_preview_desc(text: widget.created),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class project_preview_name extends StatelessWidget {
  final String text;
  const project_preview_name({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(text,
                style: TextStyle(
                    color: AppStyle.fieldText,
                    fontFamily: 'Times',
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    wordSpacing: 3))));
  }
}

class project_preview_desc extends StatelessWidget {
  final String text;
  const project_preview_desc({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(this.text,
                style: TextStyle(
                    color: AppStyle.descriptionText,
                    fontFamily: 'Times',
                    fontSize: 13))));
  }
}
