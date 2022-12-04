// ignore_for_file: invalid_return_type_for_catch_error, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> getLangs(DocumentReference stackDoc) async {
  //gets unique programming languages from stack document
  List<String> result = [];
  await stackDoc.collection("Bug").get().then((value) => {

      for (var bugDoc in value.docs) {
        for (var solution in bugDoc["solution"]) {
            if (!result.contains(solution["language"]) &&
                solution["language"] != "Other") {
              result.add(solution["language"])
            }
          }
      }
      });
  return result;
}

Future<List<String>> getStacksAndLangs(DocumentReference projectDoc) async {
  //gets unique stacks and languages from project document
  List<String> result = [];
  List<String> stackIds = [];

  await projectDoc
      .collection("Stack")
      .get()
      .then((value) => {
            //adding stacks
            for (var stackDoc in value.docs)
              {
                if (!result.contains(stackDoc["stack_title"]))
                  {result.add(stackDoc["stack_title"])},
                if (!stackIds.contains(stackDoc.id)) {stackIds.add(stackDoc.id)}
              }
          })
      .catchError((error) => print("Failed to get stacks and langs: $error"));

  for (var id in stackIds) {
    DocumentReference stackDoc = projectDoc.collection("Stack").doc(id);
    List<String> langs = await getLangs(stackDoc);
    for (var lang in langs) {
      if (!result.contains(lang) && lang != "Other") {
        result.add(lang);
      }
    }
  }

  return result;
}

int getBugsInStack(DocumentReference stackDoc){
  //gets number of bugs given a stack document
  int stackBugs = 0;
  stackDoc
      .collection("Bug")
      .get()
      .then((value) => stackBugs = value.size);
  return stackBugs;
}

Future<int> getBugCount(DocumentReference projectDoc) async {
  //gets number of bugs given a project document
  int result = 0;
  List<String> stackIDs = [];
  await projectDoc
      .collection("Stack")
      .get()
      .then((value) => {
            //adding stacks
            for (var stackDoc in value.docs)
              {
                if (!stackIDs.contains(stackDoc.id))
                  {
                    stackIDs.add(stackDoc.id),
                  }
              }
          })
      .catchError((error) => print("Failed to get stacks and langs: $error"));
  for (var id in stackIDs) {
    DocumentReference stackDoc = projectDoc.collection("Stack").doc(id);
    int stackBugs = await getBugsInStack(stackDoc);
    result += stackBugs;
  }
  return result;
}
