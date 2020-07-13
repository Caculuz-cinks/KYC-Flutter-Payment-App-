import 'package:KYC/Model/Kyc_level_model.dart';
import 'package:KYC/components/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

final _fireStore = Firestore.instance;

class KycLevel extends StatefulWidget {
  @override
  _KycLevelState createState() => _KycLevelState();
}

class _KycLevelState extends State<KycLevel>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  FirebaseAuth _auth = FirebaseAuth.instance;

  KYCModel kycModel = KYCModel();

  FirebaseUser loggedinuser;
  bool status;
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

  getAndListenCollection() async {
    Firestore.instance
        .collection('users')
        .document(loggedinuser.uid)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data;

      setState(() {
        status = firestoreInfo['status'];
      });
      if (status == true) {
        kycModel.updateKycLevel();
        return Text(
          'KYC Level: ${kycModel.kycLevel}',
          style: TextStyle(fontSize: 50),
        );
      } else {
        Text('KYC Level: 0');
      }
    });
  }

  Widget builder() {
    return getAndListenCollection();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();

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
    var model = Provider.of<KYCModel>(context, listen: true);

    final percentage = controller.value * 100;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'KYC Level: 0',
              style: TextStyle(fontSize: 35),
            ),
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
