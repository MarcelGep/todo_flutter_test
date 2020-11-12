import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter_test/authentication_service.dart';
import 'package:todo_flutter_test/todo_screen.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: ToDo()));
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return ToDoScreen(firebaseUser);
    }
    return LoginScreen();
  }
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
  /*Widget build(BuildContext context) {
    initApp();
    if (currentUser == null) {
      return LoginScreen();
    } else {
      return ToDoScreen(currentUser);
    }
  }*/

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}
