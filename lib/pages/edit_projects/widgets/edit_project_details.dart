import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants/style.dart';
import 'add_collab.dart';

final TextEditingController _projectNameController = TextEditingController();
final TextEditingController _projectDescriptionController = TextEditingController();

class EditProjectDetail extends StatefulWidget {
    final Function() notifyParent;
    final DocumentReference<Object?> project_query_doc;
    final String project_title;
    final String project_description;

    const EditProjectDetail({
        super.key,
        required this.notifyParent,
        required this.project_query_doc,
        required this.project_title,
        required this.project_description,
    });

    @override
    State<EditProjectDetail> createState() => _EditProjectDetailState();
}

class _EditProjectDetailState extends State<EditProjectDetail> {
    @override
    void initState() {
        super.initState();
        _projectNameController.text = widget.project_title;
        _projectDescriptionController.text = widget.project_description;    
    }

    final _editProjectKey = GlobalKey<FormState>();
    double formHeight = 200;

    callback() {
        setState(() {});
    }

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: const Padding(
                padding: EdgeInsets.all(3.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("Edit Project",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            content: Form(
                key: _editProjectKey,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: formHeight,
                    child: ListView(
                    children: [
                        Padding(
                        padding: const EdgeInsets.all(.0),
                        child: TextFormField(
                            controller: _projectNameController,
                            decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter Project Name:',
                            ),
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                                return 'Please enter Project Name';
                            }
                            return null;
                            },
                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                              controller: _projectDescriptionController,
                              decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Project Description:',
                              ),
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                  return 'Please enter Project Description';
                              }
                              return null;
                              },
                          ),
                        ),
                        Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AddMember(
                                              notifyParent: widget.notifyParent,
                                              query_doc:
                                                  widget.project_query_doc,
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppStyle.fieldText),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.person_add,
                                              size: 20,
                                              color: AppStyle.backgroundColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text("Add Member",
                                                  style: TextStyle(
                                                      color: AppStyle
                                                          .backgroundColor)),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                RemoveMember(
                                              notifyParent: widget.notifyParent,
                                              query_doc:
                                                  widget.project_query_doc,
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppStyle.fieldText),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(
                                              Icons.person_remove,
                                              size: 20,
                                              color: AppStyle.backgroundColor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text("Remove Member",
                                                  style: TextStyle(
                                                      color: AppStyle
                                                          .backgroundColor)),
                                            ),
                                          ],
                                        )
                                      ),
                                  ],
                                )
                              ],
                            ),
                    ],
                    ),
                )
            ),
            actions: [
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                ),
                TextButton(
                    child: const Text('Edit Project'),
                    onPressed: () {
                        if (_editProjectKey.currentState!.validate()) {
                            widget.project_query_doc.update({
                                'project_title': _projectNameController.text,
                                'project_description': _projectDescriptionController.text,
                            })
                            .then((value) {
                            print("Project Edited");
                            widget.notifyParent();
                            Navigator.pop(context);
                            }).catchError((error) => print("Failed to edit Project: $error"));
                        }
                    }
                ),
            ],
        );
    }
}
