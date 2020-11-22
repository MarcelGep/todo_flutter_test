import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login/flutter_login.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  Duration get loginTime => Duration(milliseconds: 500);

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User> signIn2(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign in error: " + e.code);
      return null;
    }
    // return Future.delayed(loginTime).then((_) async {
    //
    // });
  }

  Future<String> signIn(LoginData loginData) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: loginData.name, password: loginData.password);
        return null;
      } on FirebaseAuthException catch (e) {
        return e.message;
      }
    });
  }

  Future<User> signUp2(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Sign up error: " + e.code);
      return null;
    }
  }

  Future<String> signUp(LoginData loginData) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: loginData.name, password: loginData.password);
        return null;
      } on FirebaseAuthException catch (e) {
        return e.message;
      }
    });
  }

  Future<String> recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }
}
