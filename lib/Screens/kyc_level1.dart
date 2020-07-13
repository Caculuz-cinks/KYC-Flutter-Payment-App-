import 'dart:math';

import 'package:KYC/Model/Kyc_level_model.dart';
import 'package:KYC/Services/email_service.dart';
import 'package:KYC/components/rounded_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:KYC/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:KYC/Services/user_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

final _fireStore = Firestore.instance;

class Level1 extends StatefulWidget {
  @override
  _Level1State createState() => _Level1State();
}

class _Level1State extends State<Level1> {
  EmailService emailService = EmailService();
  Auth auth = Auth();
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserManagement userManagement = UserManagement();

  File _passport;
  String _uploadedPassport;
  File _utility;
  String _uploadedUtility;
  FirebaseUser loggedinuser;
  bool documentStatus = false;
  File fileName;
  bool status;

  Future choosePassport() async {
    final file = await FilePicker.getFile();
    try {
      setState(() {
        _passport = File(file.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future chooseUtility() async {
    final file = await FilePicker.getFile();
    try {
      setState(() {
        _utility = File(file.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploadPassport() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('passport/${Path.basename(_passport.path)}}');

    StorageUploadTask uploadTask = storageReference.putFile(_passport);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedPassport = fileURL;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future uploadUtility() async {
    // String fileName = '$_utility.pdf';
    final String fileName = Random().nextInt(10000).toString() + '.$_utility';
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(_utility);

    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedUtility = fileURL;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'KYC Level 1',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Text(
            'Upload Your Passport',
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _passport == null
                  ? RaisedButton(
                      child: Text('Choose Passport'),
                      onPressed: choosePassport,
                      color: Colors.blue,
                    )
                  : Container(
                      child: Text('Passport Uploaded'),
                    ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Upload Utility Bill',
            style: TextStyle(fontSize: 15),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _utility == null
                  ? RaisedButton(
                      child: Text('Choose Utility Bill'),
                      onPressed: chooseUtility,
                      color: Colors.blue,
                    )
                  : Container(
                      child: Text('Utility Bill Uploaded'),
                    ),
              SizedBox(
                width: 40,
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          RoundButton(
            title: 'Upload',
            color: Colors.blue,
            onpressed: () async {
              try {
                await uploadPassport();
                await uploadUtility();
                await userManagement.storeNewUser(loggedinuser,
                    _uploadedPassport, _uploadedUtility, documentStatus);
                await emailService.mail(loggedinuser.email);
              } catch (e) {
                print(e);
              }
              Navigator.pushNamed(context, '/kyc');
            },
          )
        ],
      ),
    );
  }
}
