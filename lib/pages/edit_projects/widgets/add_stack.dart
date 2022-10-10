import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStackPopUp extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;
  const AddStackPopUp(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id});

  @override
  State<AddStackPopUp> createState() => _AddStackPopUpState();
}

class _AddStackPopUpState extends State<AddStackPopUp> {
  List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
  late String _selectedStackType = StackType.first;
  final _projectInfoController = TextEditingController();
  final _addStackKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Container(
        width: 100,
        height: 100,
      ),
      AlertDialog(
        title: Text('Add Stack'),
        content: Form(
            key: _addStackKey,
            child: Container(
              width: 500,
              child: Column(
                children: [
                  // ViewStacks(
                  //     query_doc: widget.query_doc,
                  //     snap_shot: widget.snap_shot,
                  //     id: widget.id),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton(
                          underline: SizedBox(),
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
                      Expanded(
                        child: SizedBox(
                          width: 900,
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
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        actions: [
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                    child: const Text('Add Stack'),
                    onPressed: () {
                      if (_addStackKey.currentState!.validate()) {
                        widget.query_doc
                            .collection('Stack')
                            .get()
                            .then((querySnapshot) {
                          querySnapshot.docs.forEach((result) {
                            if (_selectedStackType != result['stack_type'] &&
                                _projectInfoController.text !=
                                    result['stack_title']) {
                              // widget.query_doc.collection("Stack").add({
                              //   'stack_type': _selectedStackType,
                              //   'stack_title': _projectInfoController.text,
                              // });
                            }
                            print(result['stack_title']);
                          });
                        });
                      }
                    }),
              ]),
            ),
          ),
        ],
      ),
    ]));
  }
}

class ViewStacks extends StatefulWidget {
  final id;
  final DocumentReference<Object?> query_doc;
  final snap_shot;
  const ViewStacks(
      {super.key,
      required this.query_doc,
      required this.snap_shot,
      required this.id});

  @override
  State<ViewStacks> createState() => _ViewStacksState();
}

class _ViewStacksState extends State<ViewStacks> {
  late Stream<QuerySnapshot> project_stream;
  @override
  void initState() {
    super.initState();
    project_stream = widget.query_doc.collection("Stacks").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.query_doc.collection("Stacks").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          String error = snapshot.error.toString();
          print(error);
          return Text(error, style: const TextStyle(color: Colors.white));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading", style: TextStyle(color: Colors.white));
        }

        print("WENT TO VIEWSTACK");
        print(snapshot.data!.docs.first);

        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Object?> project =
                  snapshot.data!.docs[index];

              print("TEST");

              return Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: Row(children: [
                    Text(project['stack_title']),
                    Text(project['stack_type']),
                  ]));
            });
      },
    );
  }
}
