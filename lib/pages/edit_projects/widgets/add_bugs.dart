import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBugButton extends StatefulWidget {
  final bool isSelected;
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;

  const AddBugButton(
      {super.key,
      required this.isSelected,
      required this.project_query_doc,
      required this.stack_id});

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
                stack_id: widget.stack_id));
      },
    );
  }
}

class AddBugPopUp extends StatefulWidget {
  final DocumentReference<Object?> project_query_doc;
  final String stack_id;
  const AddBugPopUp({
    super.key, 
    required this.project_query_doc, 
    required this.stack_id
  });

  @override
  State<AddBugPopUp> createState() => _AddBugPopUpState();
}

class _AddBugPopUpState extends State<AddBugPopUp> {
  final _addBugKey = GlobalKey<FormState>();
  final TextEditingController _bugNameController = TextEditingController();
  final TextEditingController _bugDescriptionController = TextEditingController();
  final TextEditingController _bugErrorOutputController = TextEditingController();
  bool _bugSolved = false;

  callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.stack_id);
    return AlertDialog(
      // title: Text('Add Bug ${widget.stack_id}'),
      title: const Padding(
        padding: EdgeInsets.all(3.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text("Add Bug",
            style: TextStyle(fontWeight: FontWeight.bold)
          )
        )
      ),
      content: Form(
        key: _addBugKey,
        child: Container(
          width: 300,
          height: 300,
          child: Column(
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
                padding: const EdgeInsets.all(.0),
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
                padding: const EdgeInsets.all(.0),
                child: TextFormField(
                  controller: _bugErrorOutputController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
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
                padding: const EdgeInsets.all(.0),
                child: CheckboxListTile(
                  title: const Text("Bug Solved"),
                  value: _bugSolved,
                  onChanged: (val) {
                    setState(() {
                      _bugSolved = val!;
                      print(val);
                      print(_bugSolved);
                      callback();
                    });
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
          child: const Text('Add Bug'),
          onPressed: () {
            if (_addBugKey.currentState!.validate()) {
              widget.project_query_doc.collection("Stack")
                .doc(widget.stack_id)
                .collection("Bug")
                .add({
                  'bug_name': _bugNameController.text,
                  'bug_description': _bugDescriptionController.text,
                  'error_output' : _bugErrorOutputController.text,
                  'is_solved': _bugSolved,
                });
              print("Added to Bug Database");
            }
          },
        ),
      ],
    );
  }
}
