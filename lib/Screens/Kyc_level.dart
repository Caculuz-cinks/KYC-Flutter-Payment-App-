import 'package:KYC/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

final _fireStore = Firestore.instance;

class KycLevel extends StatefulWidget {
  @override
  _KycLevelState createState() => _KycLevelState();
}

class _KycLevelState extends State<KycLevel>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser loggedinuser;
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

  Stream myStream;

  getAndListenCollection() {
    myStream = Firestore.instance
        .collection('users')
        .document(loggedinuser.uid)
        .snapshots();
  }

  Widget myStreamBuilder(context) {
    return StreamBuilder(
        stream: myStream,
        builder: (context, snapShot) {
          return snapShot.hasData
              ? Container(
                  child: Text(
                    '${snapShot.data.documents[0].data['status']}',
                    style: TextStyle(
                        color: snapShot.data.documents[0].data['status'] == true
                            ? Colors.green
                            : Colors.red),
                  ),
                )
              : Container(
                  child: Text('No Data'),
                );
        });
  }

  int kycLevel = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getAndListenCollection();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
      // upperBound: 100,
      // lowerBound: 0,
    );

    controller.addListener(() => setState(() {}));
    // controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = controller.value * 100;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            myStreamBuilder(context),
            SizedBox(
              height: 100,
            ),
            Container(
              height: 50,
              child: LiquidLinearProgressIndicator(
                value: controller.value, // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors
                    .blue), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blue,
                borderWidth: 5.0,

                borderRadius: 50.0,
                direction: Axis
                    .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text(
                  "${percentage.toStringAsFixed(0)}%",
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            RoundButton(
                title: 'UPGRADE',
                color: Colors.blue,
                onpressed: () {
                  Navigator.pushNamed(context, '/level1');
                })
          ],
        ),
      ),
    );
  }
}
