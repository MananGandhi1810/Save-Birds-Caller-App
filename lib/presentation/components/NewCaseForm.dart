import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';

class NewCaseForm extends StatefulWidget {
  const NewCaseForm({super.key});

  @override
  State<NewCaseForm> createState() => _NewCaseFormState();
}

class _NewCaseFormState extends State<NewCaseForm> {
  final _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _birdNameController =
      TextEditingController(text: "Peigon");
  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _caseTypeController =
      TextEditingController(text: "Collect");
  final TextEditingController _caseNotesController = TextEditingController();
  final TextEditingController _callerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Report a new case",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      const Text(
                        "Bird Name: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: "Peigon",
                            child: Text("Peigon"),
                          ),
                          DropdownMenuItem(
                            value: "Crow",
                            child: Text("Crow"),
                          ),
                          DropdownMenuItem(
                            value: "Parrot",
                            child: Text("Parrot"),
                          ),
                          DropdownMenuItem(
                            value: "Sparrow",
                            child: Text("Sparrow"),
                          ),
                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _birdNameController.value =
                                TextEditingValue(text: value.toString());
                            debugPrint(
                                "Bird name: ${_birdNameController.value.toString()}");
                          });
                        },
                        value: "Peigon",
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      const Text(
                        "Pickup Address: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: _pickupAddressController,
                        decoration: const InputDecoration(
                          hintText: "Enter pickup address",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter pickup address";
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      const Text(
                        "Case Type: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem(
                            value: "Collect",
                            child: Text("Collect"),
                          ),
                          DropdownMenuItem(
                            value: "Rescue",
                            child: Text("Rescue"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _caseTypeController.text = value.toString();
                            debugPrint(
                                "Case type: ${_caseTypeController.text}");
                          });
                        },
                        value: "Collect",
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      const Text(
                        "Case Notes: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: _caseNotesController,
                        decoration: const InputDecoration(
                          hintText: "Enter case notes",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value!.isEmpty &&
                              _caseTypeController.text == "Rescue") {
                            return "Please enter case notes for rescue case";
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      const Text(
                        "Caller Phone: ",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextFormField(
                        controller: _callerPhoneController,
                        decoration: const InputDecoration(
                          hintText: "Enter caller phone",
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          value = value!
                              .trim()
                              .replaceAll(" ", "")
                              .replaceAll("+91", "");
                          if (value.isEmpty ||
                              !RegExp(r"^(?:\+91\s?)?[6789]\d{9}$")
                                  .hasMatch(value)) {
                            return "Please enter a valid phone number";
                          }
                          return null;
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      GFButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            debugPrint("Form validated");
                            _firestore.collection("Cases").add({
                              "birdName": _birdNameController.text,
                              "caseStatus": "Unknown",
                              "pickupAddress": _pickupAddressController.text,
                              "pickupStatus": "Pending",
                              "caseType": _caseTypeController.text,
                              "caseNotes": _caseNotesController.text,
                              "callerPhone": _callerPhoneController.text,
                              "addedBy": FirebaseAuth.instance.currentUser!.uid,
                              "timestamp": Timestamp.now(),
                              "volunteersGoing": 0,
                            }).then((value) {
                              debugPrint("Case added");
                              Fluttertoast.showToast(msg: "Case added");
                              _caseTypeController.text = "Collect";
                              _birdNameController.text = "Peigon";
                              _pickupAddressController.clear();
                              _caseNotesController.clear();
                              _callerPhoneController.clear();
                            });
                          }
                        },
                        color: Colors.green,
                        shape: GFButtonShape.pills,
                        child: const Text("Submit"),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
