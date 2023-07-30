import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../CaseEditFormScreen.dart';

class BirdCaseCard extends StatefulWidget {
  final Map<String, dynamic> birdCase;
  final FirebaseFirestore firestore;
  final String id;

  const BirdCaseCard({
    super.key,
    required this.birdCase,
    required this.firestore,
    required this.id,
  });

  @override
  State<BirdCaseCard> createState() => _BirdCaseCardState();
}

class _BirdCaseCardState extends State<BirdCaseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Bird: ${widget.birdCase['birdName']}",
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            widget.birdCase["callerName"] != ""
                ? Text("Caller Name: ${widget.birdCase['callerName']}")
                : Container(),
            Text("Caller Number: ${widget.birdCase['callerPhone']}"),
            Text("Case Type: ${widget.birdCase['caseType']}"),
            widget.birdCase["volunteersGoing"] != 0
                ? Text(
                    "Volunteer Name: ${widget.birdCase['volunteer1']["name"]}${widget.birdCase['volunteer2'] != null ? ", ${widget.birdCase['volunteer2']["name"]}" : ""}",
                    overflow: TextOverflow.ellipsis,
                  )
                : Container(),
            Text(
              "Notes: ${widget.birdCase['caseNotes']}",
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Address: ${widget.birdCase['pickupAddress']}",
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GFButton(
                  shape: GFButtonShape.pills,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CaseEditFormScreen(
                          firestore: widget.firestore,
                          id: widget.id,
                          birdCase: widget.birdCase,
                        ),
                      ),
                    );
                  },
                  text: "Edit",
                  color: Colors.green,
                ),
                GFButton(
                  shape: GFButtonShape.pills,
                  onPressed: () {
                    debugPrint("Delete");
                    widget.firestore
                        .collection("Cases")
                        .doc(widget.id)
                        .delete();
                  },
                  text: "Delete",
                  color: Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
