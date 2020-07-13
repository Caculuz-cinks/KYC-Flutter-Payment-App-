import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _fireStore = Firestore.instance;

class UserManagement {
  storeNewUser(user, passportUrl, utilityUrl, bool status) async {
    await _fireStore.collection('users').document(user.uid).setData({
      'email': user.email,
      'passportUrl': passportUrl,
      'uid': user.uid,
      'utilityUrl': utilityUrl,
      'status': status,
    });
  }
}
