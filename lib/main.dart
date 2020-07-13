import 'package:KYC/Providers/providers.dart';
import 'package:KYC/Screens/Kyc_level.dart';
import 'package:KYC/Screens/Login.dart';
import 'package:KYC/Screens/Splash.dart';
import 'package:KYC/Screens/home.dart';
import 'package:KYC/Screens/kyc_level1.dart';
import 'package:KYC/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: providers, child: KYC());
  }
}

class KYC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => WelcomeScreen(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/kyc': (context) => KycLevel(),
        '/level1': (context) => Level1(),
      },
    );
  }
}
