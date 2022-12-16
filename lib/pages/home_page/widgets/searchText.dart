import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home_page.dart';

String searchT = "";

/// this widget let's us search through projects
class SearchTextField extends StatefulWidget {
  final Function() notifyParent;
  const SearchTextField({super.key, required this.notifyParent});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _projectSearchBar = TextEditingController();

  @override
  void initState() {
    super.initState();
    _projectSearchBar.addListener(() {
      setState(() {
        searchT = _projectSearchBar.text;
        widget.notifyParent();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    searchT = _projectSearchBar.text;
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: TextField(
          onChanged: (String value) async {
            //print(value);
            ProjectsView(notifyParent: () {});
          },
          controller: _projectSearchBar,
          autofocus: true, //Display the keyboard when TextField is displayed
          cursorColor: Colors.white,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
          ),
          textInputAction: TextInputAction
              .search, //Specify the action button on the keyboard
          decoration: InputDecoration(
            //Style of TextField
            enabledBorder: const UnderlineInputBorder(
                //Default TextField border
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const UnderlineInputBorder(
                //Borders when a TextField is in focus
                borderSide: BorderSide(color: Colors.white)),
            hintText:
                'Search keywords', //Text that is displayed when nothing is entered.
            hintStyle: GoogleFonts.poppins(
              //Style of hintText
              color: Colors.white60,
              fontSize: 20,
            ),
          ),
        ));
  }
}
