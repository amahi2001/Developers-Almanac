import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../constants/langs.dart';
import '../../../main.dart';

final _bugSolution = TextEditingController();
final _bugSolutionName = TextEditingController();
String _bugLanguage = langs.first;

class AddSolution extends StatefulWidget {
  final DocumentReference<Object?> query_doc;
  //notify parent to update
  final Function() notifyParent;

  const AddSolution({
    super.key,
    required this.query_doc,
    required this.notifyParent,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text("Add Solution",
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      content: Form(
          key: _addSolutionKey,
          child: Container(
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
                    selectedItem: langs.first,
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _bugSolutionName,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.blueAccent),
                      ),
                      labelText: 'Solution Name:',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Solution Name';
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
                  "solution_name": _bugSolutionName.text,
                  "language": _bugLanguage,
                  "time": today.toString(),
                };

                var addArray;
                _bugSolution.text.isEmpty
                    ? addArray = []
                    : addArray = [solutionMap];

                if (_addSolutionKey.currentState!.validate()) {
                  widget.query_doc
                      .update({
                        "solution": FieldValue.arrayUnion(addArray),
                      })
                      .then((value) => {
                        widget.notifyParent(),
                        Navigator.pop(context),
                        print("Solution Added"),
                      })
                      .catchError(
                          (error) => print("Failed to add solution: $error"));
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
