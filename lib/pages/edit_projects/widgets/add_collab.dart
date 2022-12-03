import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devs_almanac/auth/auth.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
    return result..sort();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userItems = snapshot.data!;
            return AlertDialog(
              title: const Text('Add Member'),
              content: Form(
                child: DropdownSearch(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    // showSelectedItems: true,
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Add user",
                      hintText: "select an existing user",
                    ),
                  ),
                  selectedItem: _selected_email ?? userItems.first,
                  items: userItems,
                  onChanged: (value) {
                    setState(() => _selected_email = value);
                  },
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
                    } else {
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

class RemoveMember extends StatefulWidget {
  final Function() notifyParent;
  DocumentReference<Object?> query_doc;
  RemoveMember({super.key, required this.query_doc, required this.notifyParent});

  @override
  State<RemoveMember> createState() => _RemoveMemberState();
}

class _RemoveMemberState extends State<RemoveMember> {
  dynamic _selected_email = null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('Projects').doc(widget.query_doc.id).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            List members = snapshot.data!['members'];
            members.removeAt(0);
            members = members..sort();
            
            return AlertDialog(
              title: const Text('Remove Member'),
              content: Form(
                child: DropdownSearch(
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                    // showSelectedItems: true,
                  ),
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Remove user",
                      hintText: "select an existing user",
                    ),
                  ),
                  selectedItem: _selected_email ?? 'Select Member',
                  items: members,
                  onChanged: (value) {
                    setState(() => _selected_email = value);
                  },
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
                        'members': FieldValue.arrayRemove([_selected_email])
                      }).then((value) {
                        print('$_selected_email removed to project');
                        widget.notifyParent();
                      }).catchError(
                          (error) => print('Failed to remove member: $error'));
                    } else {
                      print('No member selected or selected member is null');
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Remove member'),
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
