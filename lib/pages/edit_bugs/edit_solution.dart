
// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../constants/langs.dart';

final _bugSolution = TextEditingController();
late String _bugLanguage;

class ModifySolution extends StatefulWidget {
  final DocumentReference<Object?> query_doc;

  final bug_index;
  final bug_info;
  final solution_list;

  const ModifySolution({
      super.key,
      required this.query_doc,
      required this.bug_index,
      required this.bug_info,
      required this.solution_list
    });

  @override
  State<ModifySolution> createState() => _ModifySolutionState();
}

class _ModifySolutionState extends State<ModifySolution> {
  @override
  void initState() {
    super.initState();
    _bugLanguage = widget.bug_info['language'];
    _bugSolution.text = widget.bug_info['solution'];
  }

  final _modifySolutionKey = GlobalKey<FormState>();


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
              child: Text(
                "Modify Solution",
                style: TextStyle(fontWeight: FontWeight.bold)
              )
            )
      ),
      content: Form(
          key: _modifySolutionKey,
          child: Container(
            width: 300,
            height: 200,
            child: Column(
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    controller: _bugSolution,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Solution:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Solution';
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
                        query_doc: widget.query_doc, 
                        bug_index: widget.bug_index,
                        solution_list: widget.solution_list,
                    )
                );
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

  const ModifySolutionPopup({
    super.key, 
    required this.query_doc, 
    required this.bug_index,
    required this.solution_list,
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
              'time': today.toString(),
            };

            widget.query_doc.update({
              'solution': widget.solution_list,
            });
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

  const DeleteSolutionPopup({
    super.key, 
    required this.query_doc,
    required this.solution_list,
    required this.bug_index,
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
            widget.query_doc.update({
              'solution': FieldValue.arrayRemove([widget.solution_list[widget.bug_index]]),
            });
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


class AddSolution extends StatefulWidget {
  final DocumentReference<Object?> query_doc;

  const AddSolution({
      super.key,
      required this.query_doc,
    });

  @override
  State<AddSolution> createState() => _AddSolutionState();
}

class _AddSolutionState extends State<AddSolution> {
  @override
  void initState() {
    super.initState();
  }

  final _addSolutionKey = GlobalKey<FormState>();


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
              child: Text(
                "Add Solution",
                style: TextStyle(fontWeight: FontWeight.bold)
              )
            )
      ),
      content: Form(
          key: _addSolutionKey,
          child: Container(
            width: 300,
            height: 200,
            child: Column(
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
                    selectedItem: langs.first,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    controller: _bugSolution,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter Solution:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Solution';
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
                final Map<String, String> solutionMap = {
                  "solution": _bugSolution.text,
                  "language": _bugLanguage,
                  "time": today.toString(),
                };

                var addArray;
                _bugSolution.text.isEmpty ? addArray = [] : addArray = [solutionMap];
                
                  
                if (_addSolutionKey.currentState!.validate()) {
                  widget.query_doc.update({
                    "solution" : FieldValue.arrayUnion(addArray),
                  });
                }
              },
              child: const Text('Add Solution'),
            ),
          ],
        ),
      ],
    );
  }
}
