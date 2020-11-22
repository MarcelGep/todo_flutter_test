import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter_test/login_screen2.dart';
import 'todo_screen.dart';
import 'login_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      print("Firebase User Email: " + firebaseUser.email);
      return ToDoScreen(user: firebaseUser);
    }
    // return LoginScreen();
    return LoginPage();
  }
}
