import 'dart:async';
import 'package:KYC/Screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<String> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    try {
      await user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print('An error occured trying to send Email');
      print(e.message);
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    if (user.isEmailVerified) return user.uid;
    return null;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
