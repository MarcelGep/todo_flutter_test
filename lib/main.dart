import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(home: ToDo()));
}

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  // @override
  // void dispose() async {
  //   await FirebaseAuth.instance.signOut();
  //   print('User logged out!');
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return LoginScreen();
  }
}