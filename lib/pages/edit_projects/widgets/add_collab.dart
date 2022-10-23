import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddMember extends StatefulWidget {
  final Function() notifyParent;
  DocumentReference<Object?> query_doc;
  AddMember({super.key, required this.query_doc, required this.notifyParent});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  dynamic _selected_email = null;

  Future<List> getUsersList() async {
    List result = [];
    await users.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String email = (doc.data() as dynamic)['email'];
        if (!result.contains(email)) {
          if (user_obj?.email != email) {
            result.add(email);
          }
        }
      });
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user_items = snapshot.data!;
            return AlertDialog(
              title: const Text('Add Member'),
              content: Form(
                child: Column(
                  children: [
                    //Text('Add Member'),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: _selected_email ?? user_items.first,
                        items:
                            user_items.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selected_email = value;
                            print(_selected_email);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    CollectionReference projects =
                        FirebaseFirestore.instance.collection('Projects');
                    // Add members to project
                    if (_selected_email != null) {
                      projects.doc(widget.query_doc.id).update({
                        'members': FieldValue.arrayUnion([_selected_email])
                      }).then((value) {
                        print('$_selected_email added to project');
                        widget.notifyParent();
                      }).catchError(
                          (error) => print('Failed to add member: $error'));
                    }
                    else{
                      print('No member selected or selected member is null');
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add member'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
