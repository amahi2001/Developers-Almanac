// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../constants/langs.dart';

final _bugSolution = TextEditingController();
String _bugLanguage = langs.first;
final _bugSolutionName = TextEditingController();

class ModifySolution extends StatefulWidget {
  final DocumentReference<Object?> query_doc;

  final bug_index;
  final bug_info;
  final solution_list;
  final Function() notifyParent;

  const ModifySolution(
      {super.key,
      required this.query_doc,
      required this.bug_index,
      required this.bug_info,
      required this.solution_list,
      required this.notifyParent});

  @override
  State<ModifySolution> createState() => _ModifySolutionState();
}

class _ModifySolutionState extends State<ModifySolution> {
  @override
  void initState() {
    super.initState();
    _bugLanguage = widget.bug_info['language'];
    _bugSolution.text = widget.bug_info['solution'];
    _bugSolutionName.text = widget.bug_info['solution_name'];
  }

  void notifyParent() {
    widget.notifyParent();
  }

  final _modifySolutionKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text("Modify Solution",
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      content: Form(
          key: _modifySolutionKey,
          child: SizedBox(
            width: 300,
            height: 225,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
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
                      setState(() => _bugLanguage = val!);
                    },
                    selectedItem: _bugLanguage,
                  ),
                ),
                //solution name
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _bugSolutionName,
                    decoration: const InputDecoration(
                      labelText: "Solution Name",
                      hintText: "Enter Solution Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    minLines: 5,
                    maxLines: 10,
                    controller: _bugSolution,
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
              ],
            ),
          )),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => ModifySolutionPopup(
                          notifyParent: notifyParent,
                          query_doc: widget.query_doc,
                          bug_index: widget.bug_index,
                          solution_list: widget.solution_list,
                        ));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}

/// This widget lets the user modify a project given a project ID
class ModifySolutionPopup extends StatefulWidget {
  final bug_index;
  final solution_list;
  final DocumentReference<Object?> query_doc;
  final Function() notifyParent;

  const ModifySolutionPopup({
    super.key,
    required this.query_doc,
    required this.bug_index,
    required this.solution_list,
    required this.notifyParent,
  });

  @override
  State<ModifySolutionPopup> createState() => _ModifySolutionPopupState();
}

class _ModifySolutionPopupState extends State<ModifySolutionPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modify Solution'),
      content: const Text('Are you sure you want to modify this solution?'),
      actions: [
        TextButton(
          onPressed: () {
            widget.solution_list[widget.bug_index] = {
              'language': _bugLanguage,
              'solution': _bugSolution.text,
              'solution_name': _bugSolutionName.text,
              'time': today.toString(),
            };

            widget.query_doc
                .update({
                  'solution': widget.solution_list,
                })
                .then((value) => {
                      widget.notifyParent(),
                      Navigator.pop(context),
                      print("Solution Updated"),
                    })
                .catchError(
                    (error) => print("Failed to update solution: $error"));
            Navigator.pop(context);
          },
          child: const Text('Modify'),
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

class DeleteSolutionPopup extends StatefulWidget {
  final DocumentReference<Object?> query_doc;
  final solution_list;
  final bug_index;
  final Function() notifyParent;

  const DeleteSolutionPopup({
    super.key,
    required this.query_doc,
    required this.solution_list,
    required this.bug_index,
    required this.notifyParent,
  });

  @override
  State<DeleteSolutionPopup> createState() => _DeleteSolutionPopupState();
}

class _DeleteSolutionPopupState extends State<DeleteSolutionPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Solution'),
      content: const Text('Are you sure you want to delete this solution?'),
      actions: [
        TextButton(
          onPressed: () {
            print(widget.solution_list[widget.bug_index]);
            widget.query_doc
                .update({
                  'solution': FieldValue.arrayRemove(
                      [widget.solution_list[widget.bug_index]]),
                })
                .then((value) => {
                      widget.notifyParent(),
                      Navigator.pop(context),
                      print("Solution Deleted")
                    })
                .catchError(
                    (error) => print("Failed to delete solution: $error"));
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
