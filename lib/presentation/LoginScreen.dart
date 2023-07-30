import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'SplashScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signingWithGoogle() async {
    if (kDebugMode) {
      print("Called Sign in with Google");
    }
    FirebaseAuth auth = FirebaseAuth.instance;

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result = await auth.signInWithCredential(credential);
    User? user = result.user;
    try {
      await _firestore
          .collection("Users")
          .doc(_auth.currentUser?.uid)
          .get()
          .then((doc) async => {
        if (!(doc.exists))
          {
            await _firestore
                .collection("Users")
                .doc(_auth.currentUser?.uid)
                .set({
              "name": _auth.currentUser?.displayName,
              "email": _auth.currentUser?.email,
              "photoUrl": _auth.currentUser?.photoURL,
              "phoneNumber": _auth.currentUser?.phoneNumber,
              "accessStatus": "pending",
            }).then((value) {
              debugPrint("***** User details added to firebase *****"
                  .toUpperCase());
            })
          }
      });
    } catch (e) {
      debugPrint("FIRESTORE AUTH CREATE USER ERROR $e");
    }
    return user;
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
            MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () async {
                var user = await signingWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreen()));
                }
              },
              textColor: Colors.white,
              color: Colors.green,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Get Started',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
