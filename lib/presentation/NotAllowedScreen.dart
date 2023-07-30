import 'package:flutter/material.dart';

class NotAllowedScreen extends StatelessWidget {
  const NotAllowedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Not Allowed"),
          backgroundColor: const Color(0xEEF2F8FF)
      ),
      body: const Center(
        child: Text(
          "You are not allowed to access this page. Please contact the admin.",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
