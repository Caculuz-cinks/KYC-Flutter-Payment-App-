import 'dart:async';

import 'package:KYC/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:KYC/Services/auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Auth auth = Auth();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('Assets/KYC.png'),
              height: 120,
            ),
            SizedBox(
              height: 50,
            ),
            TextField(
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
              height: 40,
            ),
            RoundButton(
              title: 'LOGIN',
              color: Colors.blue,
              onpressed: () async {
                try {
                  final user = await auth.signIn(email, password);

                  if (user != null) {
                    Navigator.pushNamed(context, '/kyc');
                  } else {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.RIGHSLIDE,
                        headerAnimationLoop: false,
                        title: 'Error',
                        desc: 'Password not verified or wrong password',
                        btnOkOnPress: () {
                          Navigator.pushNamed(context, '/login');
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
