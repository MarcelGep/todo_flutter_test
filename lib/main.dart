import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter_test/todo_screen.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(home: ToDo()));
}

class ToDo extends StatelessWidget {

  // Widget createWidget() {
  //   if (FirebaseAuth.instance.currentUser != null) {
  //
  //   }
  // }
  User currentUser;

  void initApp() async {
    print('Init APP!');
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      currentUser = FirebaseAuth.instance.currentUser;
      print('Current User: ' + FirebaseAuth.instance.currentUser.uid);
    } else {
      currentUser = null;
      print('Current User is NULL!');
    }
  }

  @override
  Widget build(BuildContext context) {
    initApp();
    if (currentUser == null) {
      return LoginScreen();
    } else {
      return ToDoScreen(currentUser);
    }
  }
}
