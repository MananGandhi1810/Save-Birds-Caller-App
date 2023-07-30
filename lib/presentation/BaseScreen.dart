import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_birds_caller/presentation/SplashScreen.dart';

import 'components/AllCasesData.dart';
import 'components/NewCaseForm.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
          title: const Text("Save Birds Caller"),
          backgroundColor: const Color(0xEEF2F8FF),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: "New Case",
              ),
              Tab(
                text: "All Cases",
              ),
            ],
          )),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(
            child: NewCaseForm(),
          ),
          Center(
            child: AllCasesData(),
          ),
        ],
      ),
    );
  }
}
