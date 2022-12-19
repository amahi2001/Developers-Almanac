import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final TextEditingController _bugNameController = TextEditingController();
final TextEditingController _bugDescriptionController = TextEditingController();
final TextEditingController _bugErrorOutputController = TextEditingController();

class EditBugDetail extends StatefulWidget {
    final Function() notifyParent;
    final DocumentReference<Object?> bug_query_doc;
    final String bug_name;
    final String bug_description;
    final String bug_error;

    const EditBugDetail({
        super.key,
        required this.notifyParent,
        required this.bug_query_doc,
        required this.bug_name,
        required this.bug_description,
        required this.bug_error
    });

    @override
    State<EditBugDetail> createState() => _EditBugDetailState();
}

class _EditBugDetailState extends State<EditBugDetail> {

    // var doc = widget.bug_query_doc.get();

    @override
    void initState() {
        super.initState();
        _bugNameController.text = widget.bug_name;
        _bugDescriptionController.text = widget.bug_description;
        _bugErrorOutputController.text = widget.bug_error;
    }

    final _editBugKey = GlobalKey<FormState>();
    double formHeight = 350;

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
                    child: Text("Edit Bug",
                        style: TextStyle(fontWeight: FontWeight.bold)))),
            content: Form(
                key: _editBugKey,
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
                    child: const Text('Edit Bug'),
                    onPressed: () {
                        if (_editBugKey.currentState!.validate()) {
                            widget.bug_query_doc.update({
                                'bug_name': _bugNameController.text,
                                'bug_description': _bugDescriptionController.text,
                                'error_output': _bugErrorOutputController.text,
                            })
                            .then((value) {
                            print("Bug Edited");
                            widget.notifyParent();
                            Navigator.pop(context);
                            }).catchError((error) => print("Failed to edit bug: $error"));
                        }
                    }
                ),
            ],
        );
    }
}
