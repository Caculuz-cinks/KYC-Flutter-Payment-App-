import 'package:KYC/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:KYC/Services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:KYC/Services/uploads.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  CloudStorageService service = CloudStorageService();
  Auth auth = Auth();

  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();
  String email;
  String password;

  Future chooseFile() async {
    final image = await picker.getImage(source: ImageSource.gallery);
    try {
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if (chooseFile() != null) {
                  AwesomeDialog(
                    context: context,
                    headerAnimationLoop: false,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'ALERT',
                    desc: 'Image Uploaded',
                  )..show();
                }
              },
              child: _image == null
                  ? Icon(
                      Icons.add_a_photo,
                      color: Colors.blueAccent,
                      size: 40,
                    )
                  : Container(
                      height: 50,
                    ),
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
              obscureText: false,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              onChanged: (value) {
                email = value;
              },
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              keyboardType: TextInputType.number,
              obscureText: false,
              style: TextStyle(
                fontSize: 20,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Phone Number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))), 
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
              title: 'SIGNUP',
              color: Colors.blue,
              onpressed: () async {
                try {
                  final user = await auth.signUp(email, password);
                  // final fileUpload = await uploadFile();
                  if (user != null) {
                    Navigator.pushNamed(context, '/kyc');
                  } else {
                    return AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: false,
                        title: 'Error',
                        desc: 'Some Fields Missing',
                        btnOkOnPress: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        btnOkIcon: Icons.cancel,
                        btnOkColor: Colors.red)
                      ..show();
                  }
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
