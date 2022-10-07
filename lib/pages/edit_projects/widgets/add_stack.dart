import 'package:flutter/material.dart';

class AddStackPopUp extends StatefulWidget {
  const AddStackPopUp({super.key});

  @override
  State<AddStackPopUp> createState() => _AddStackPopUpState();
}

class _AddStackPopUpState extends State<AddStackPopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //drop down of type

      title: Text('Add Stack'),
      content: Form(
        child: Column(
          children: [
            Text('Add Stack'),
          ],
        ),
      ),
    );
  }
}