import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:todo_flutter_test/todo_screen.dart';

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 500);
  User user;

  Future<String> _signIn(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Firebase.initializeApp();
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: data.name,
              password: data.password
        );
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'Für diese E-Mail wurde kein Benutzer gefunden.';
        } else if (e.code == 'wrong-password') {
          return 'Falsches password für diesen Benutzer.';
        }
      }
      return null;
    });
  }

  Future<String> _createAccount(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Firebase.initializeApp();
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: data.name,
              password: data.password
        );
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      } catch (e) {
        return e.toString() ;
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ToDo Flutter',
      //logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _signIn,
      onSignup: _createAccount,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ToDoScreen(user),
        ));
      },
    );
  }
}