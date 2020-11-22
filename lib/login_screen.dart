import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:todo_flutter_test/authentication_service.dart';
import 'package:todo_flutter_test/todo_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 1500);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ToDo Flutter',
      //logo: 'assets/images/ecorp-lightblue.png',
      onLogin: context.watch<AuthenticationService>().signIn,
      onSignup: context.watch<AuthenticationService>().signUp,
      onRecoverPassword: context.watch<AuthenticationService>().recoverPassword,
      onSubmitAnimationCompleted: () {
        // Navigator.of(context).pushReplacement(MaterialPageRoute(
        //   builder: (context) => ToDoScreen(),
        // ));
      },
    );
  }
}
