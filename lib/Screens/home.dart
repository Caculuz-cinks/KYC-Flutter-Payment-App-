import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:KYC/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();
    controller.addListener(() {
      setState(() {});
      // print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('Assets/KYC.png'),
              height: 100,
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: TypewriterAnimatedTextKit(
                speed: Duration(seconds: 1),
                text: [
                  'KYC',
                ],
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(
              height: 150,
            ),
            RoundButton(
              title: 'LOGIN',
              color: Colors.blue,
              onpressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            RoundButton(
                title: 'SIGNUP',
                color: Colors.green,
                onpressed: () {
                  Navigator.pushNamed(context, '/signup');
                }),
          ],
        ),
      ),
    );
  }
}
