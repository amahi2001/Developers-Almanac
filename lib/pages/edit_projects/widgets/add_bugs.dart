// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/pages/home_page/home_page.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import "../../../auth/auth.dart";
import '../../../constants/langs.dart';

class AddBugButton extends StatefulWidget {
  final Function() callback;
  final Function() notifyParent;
  final bool isSelected;
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;

  const AddBugButton({
        super.key,
      required this.isSelected,
      required this.project_query_doc,
      required this.stack_id,
      required this.notifyParent,
      required this.callback,
    });

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
          : const Color.fromARGB(255, 193, 125, 47),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AddBugPopUp(
                project_query_doc: widget.project_query_doc,
                stack_id: widget.stack_id,
                notifyParent: widget.notifyParent,
                callback: widget.callback,
              ));
      },
    );
  }
}

class AddBugPopUp extends StatefulWidget {
  final Function() callback;
  final Function() notifyParent;
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;
  const AddBugPopUp(
      {super.key,
      required this.project_query_doc,
      required this.stack_id,
      required this.notifyParent,
      required this.callback,
      });

  @override
  State<AddBugPopUp> createState() => _AddBugPopUpState();
}

class _AddBugPopUpState extends State<AddBugPopUp> {
  final _addBugKey = GlobalKey<FormState>();
  final TextEditingController _bugNameController = TextEditingController();
  final TextEditingController _bugDescriptionController =
      TextEditingController();
  final TextEditingController _bugErrorOutputController =
      TextEditingController();
  final TextEditingController _bugSolutionsController = TextEditingController();
  final _solutionNameController = TextEditingController();

  String _bugLanguageController = langs.first;

  bool _bugSolved = false;
  double formHeight = 500;

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
              child: Text("Add Bug",
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      content: Form(
          key: _addBugKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: formHeight,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(.0),
                  child: TextFormField(
                    controller: _bugNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Bug Name:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Bug Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: _bugDescriptionController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Bug Description:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Bug Description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    minLines: 10,
                    maxLines: 15,
                    controller: _bugErrorOutputController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.blueAccent),
                      ),
                      labelText: 'Enter Error Output:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Error Output';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CheckboxListTile(
                    title: const Text("Bug Solved"),
                    value: _bugSolved,
                    onChanged: (val) {
                      setState(() {
                        _bugSolved = val!;
                        formHeight = formHeight == 500 ? 850 : 500;
                        callback();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: _bugSolved,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: DropdownSearch<String>(
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                        showSelectedItems: true,
                      ),
                      items: langs,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Programming Language",
                          hintText: "country in menu mode",
                        ),
                      ),
                      onChanged: (val) {
                        setState(() => _bugLanguageController = val!);
                      },
                      selectedItem: langs.first,
                    ),
                  ),
                ),
                Visibility(
                  visible: _bugSolved,
                  child: Padding(
                    padding: const EdgeInsets.all(.0),
                    child: TextFormField(
                      controller: _solutionNameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Solution Name:',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Solution Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _bugSolved,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      minLines: 5,
                      maxLines: 10,
                      controller: _bugSolutionsController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent),
                        ),
                        labelText: 'Solution:',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Solution';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
            child: const Text('Add Bug'),
            onPressed: () {
              if (_addBugKey.currentState!.validate()) {
                final Map<String, String> solutionMap = {
                  "solution": _bugSolutionsController.text,
                  "solution_name": _solutionNameController.text,
                  "language": _bugLanguageController,
                  "time": today.toString(),
                };

                List addArray;
                _bugSolutionsController.text.isEmpty
                    ? addArray = []
                    : addArray = [solutionMap];
                // print(solutionMap);

                widget.project_query_doc
                    .collection("Stack")
                    .doc(widget.stack_id)
                    .collection("Bug")
                    .add({
                  'bug_name': _bugNameController.text,
                  'bug_description': _bugDescriptionController.text,
                  'error_output': _bugErrorOutputController.text,
                  'solution': FieldValue.arrayUnion(addArray),
                  'is_solved': _bugSolved,
                  'created_at': today,
                  'created_by': user_obj!.email,
                }).then((value) {
                  print("Bug Added");
                  setState(() {
                    projectBugs += 1;
                  });
                  widget.notifyParent();
                  widget.callback();
                  Navigator.pop(context);
                }).catchError((error) => print("Failed to add bug: $error"));
              }
            }),
      ],
    );
  }
}
