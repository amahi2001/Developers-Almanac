import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../edit_projects/edit_project.dart' as global;

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
            Card(
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selectedStackType,
                        // icon: const Icon(Icons.arrow_downward),
                        // elevation: 16,
                        // style: const TextStyle(color: Colors.deepPurple),
                        // underline: Container(
                        //   height: 2,
                        //   color: Colors.deepPurpleAccent,
                        // ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            _selectedStackType = value!;
                          });
                        },
                        items: global.StackType.map(
                            (String value) {
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
      ),
      actions: [
        TextButton(
          onPressed: () {
            String creation_date = DateTime.now().toString();

            if (_formKey.currentState!.validate()) {
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
                      'members': [user_obj?.email]
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
          color: const Color.fromARGB(255, 22, 66, 97),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(
                  color: Color.fromARGB(255, 146, 153, 192), width: 1)),
          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text('Project Name',
                            style: TextStyle(
                                color: Color.fromARGB(255, 241, 240, 244),
                                fontSize: 30,
                                wordSpacing: 3))),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text(widget.title,
                            style: TextStyle(
                                color: Color.fromARGB(255, 230, 229, 232),
                                fontSize: 25,
                                wordSpacing: 3))),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text('Project Description',
                            style: TextStyle(
                                color: Color.fromARGB(255, 241, 240, 244),
                                fontSize: 25,
                                wordSpacing: 3))),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text(widget.description,
                            style: TextStyle(
                                color: Color.fromARGB(255, 230, 229, 232),
                                fontSize: 20,
                                wordSpacing: 3))),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text('Project Member(s)',
                            style: TextStyle(
                                color: Color.fromARGB(255, 241, 240, 244),
                                fontSize: 25,
                                wordSpacing: 3))),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text(widget.members.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 230, 229, 232),
                                fontSize: 20,
                                wordSpacing: 3))),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text('Created',
                            style: TextStyle(
                                color: Color.fromARGB(255, 241, 240, 244),
                                fontSize: 25,
                                wordSpacing: 3))),
                    Padding(
                        padding: EdgeInsets.only(left: 15, top: 6, right: 15),
                        child: Text(widget.created,
                            style: TextStyle(
                                color: Color.fromARGB(255, 230, 229, 232),
                                fontSize: 20,
                                wordSpacing: 3))),
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
