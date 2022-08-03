import 'package:flutter/material.dart';

String ubuntuFont = "Ubuntu";
var textColor = Colors.black;

void showToast(BuildContext context, String massage) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      duration: (const Duration(seconds: 1)),
      content: Text(massage),
    ),
  );
}

// firebase firestore rules
// rules_version = '2';
// service firebase.storage {
//   match /b/{bucket}/o {
//     match /{allPaths=**} {
//       allow read, write: if false;
//     }
//   }
// }
