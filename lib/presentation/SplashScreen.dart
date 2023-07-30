import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'BaseScreen.dart';
import 'LoginScreen.dart';
import 'NotAllowedScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  redirect() async {
    if (_auth.currentUser == null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      if (_auth.currentUser != null) {
        _auth.currentUser?.getIdTokenResult(true).then(
              (userIdToken) {
            debugPrint(userIdToken.toString());
            debugPrint(userIdToken.claims.toString());
            if (userIdToken.claims?['caller'] != null &&
                userIdToken.claims?['caller']) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BaseScreen()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotAllowedScreen()));
            }
          },
        );
      }
    }
  }

  @override
  void initState() {
    Timer(const Duration(seconds: 0), () {
      redirect();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // We take the image from the assets
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/images/save-birds.png',
              height: 250,
            ),
            const SizedBox(
              height: 20,
            ),
            //Texts and Styling of them
            const Text(
              'Welcome to Save Birds Caller App !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
