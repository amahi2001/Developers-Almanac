import 'package:flutter/material.dart';


class Edit_project_page extends StatefulWidget {
  String project_id;
  String? user_id;
  String project_title;
  String project_description;

  Edit_project_page({super.key, required this.project_id, required this.project_description, required this.project_title, required this.user_id});

  @override
  State<Edit_project_page> createState() => _Edit_project_pageState();
}

class _Edit_project_pageState extends State<Edit_project_page> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //retain the appbar from the previous page
        title: const Text("Edit Project"),
        backgroundColor: const Color.fromARGB(255, 14, 41, 60),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text("Project ID: ${widget.project_id}",
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Times',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          
          Text("User ID: ${widget.user_id}",
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Times',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text(
            "Project Title: ${widget.project_title}",
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Times',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Project Description: ${widget.project_description}",
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Times',
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
