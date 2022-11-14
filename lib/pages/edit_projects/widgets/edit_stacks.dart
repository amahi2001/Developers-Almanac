// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../edit_project.dart';
/*
  for editing stacks in edit_projects page
*/

final _projectInfoController = TextEditingController();
late String _selectedStackType;

class ModifyStack extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;

  final stack_type;
  final technology;

  const ModifyStack(
      {super.key,
      required this.query_doc,
      required this.id,
      required this.stack_type,
      required this.technology});

  @override
  State<ModifyStack> createState() => _ModifyStackState();
}

class _ModifyStackState extends State<ModifyStack> {
  @override
  void initState() {
    super.initState();
    _selectedStackType = widget.stack_type;
    _projectInfoController.text = widget.technology;
  }

  final _addStackKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text("Modify Stack",
                  style: TextStyle(fontWeight: FontWeight.bold)))),
      content: Form(
          key: _addStackKey,
          child: Container(
            width: 300,
            height: 80,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: DropdownButton(
                          underline: const SizedBox(),
                          value: _selectedStackType,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStackType = value!;
                            });
                          },
                          items: StackType.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 100,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextFormField(
                            controller: _projectInfoController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Technology:',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Project Technology';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    builder: (BuildContext context) => ModifyStackPopup(
                        query_doc: widget.query_doc, stack_id: widget.id));
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
class ModifyStackPopup extends StatefulWidget {
  final String stack_id;
  final DocumentReference<Object?> query_doc;

  const ModifyStackPopup(
      {super.key, required this.query_doc, required this.stack_id});

  @override
  State<ModifyStackPopup> createState() => _ModifyStackPopupState();
}

class _ModifyStackPopupState extends State<ModifyStackPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modify Stack'),
      content: const Text('Are you sure you want to modify this stack?'),
      actions: [
        TextButton(
          onPressed: () {
            widget.query_doc.collection('Stack').doc(widget.stack_id).update({
              'stack_type': _selectedStackType,
              'stack_title': _projectInfoController.text
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
