import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_birds_caller/presentation/components/BirdCaseCard.dart';

class AllCasesData extends StatefulWidget {
  const AllCasesData({super.key});

  @override
  State<AllCasesData> createState() => _AllCasesDataState();
}

class _AllCasesDataState extends State<AllCasesData> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  allCasesStream() {
    return _firestore
        .collection('Cases')
        .where(
          'addedBy',
          isEqualTo: _auth.currentUser?.uid,
        )
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: allCasesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var caseData = snapshot.data!.docs;
        return caseData.isEmpty
            ? const Center(
                child: Text(
                  "No cases added by you",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: caseData.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      index == 0
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Only cases added by you will appear here",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(),
                      BirdCaseCard(
                        birdCase:
                            caseData[index].data() as Map<String, dynamic>,
                        firestore: _firestore,
                        id: caseData[index].id,
                      ),
                    ],
                  );
                },
              );
      },
    );
  }
}
