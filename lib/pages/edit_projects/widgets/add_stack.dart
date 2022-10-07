import 'package:flutter/material.dart';

class AddStackPopUp extends StatefulWidget {
  const AddStackPopUp({super.key});

  @override
  State<AddStackPopUp> createState() => _AddStackPopUpState();
}

class _AddStackPopUpState extends State<AddStackPopUp> {
  List<String> StackType = ["Frontend", "Backend", "Database", "Other"];
  late String _selectedStackType = StackType.first;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //drop down of type

      title: Text('Add Stack'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedStackType,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _selectedStackType = value!;
                });
                //trigger otehr dropdown
              },
              items: StackType.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}