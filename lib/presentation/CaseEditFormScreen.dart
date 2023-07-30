import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';

class CaseEditFormScreen extends StatefulWidget {
  final String id;
  final Map<String, dynamic> birdCase;
  final FirebaseFirestore firestore;

  const CaseEditFormScreen(
      {super.key,
      required this.firestore,
      required this.id,
      required this.birdCase});

  @override
  State<CaseEditFormScreen> createState() => _CaseEditFormScreenState();
}

class _CaseEditFormScreenState extends State<CaseEditFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _birdTypeController = TextEditingController();
  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _caseTypeController = TextEditingController();
  final TextEditingController _caseNotesController = TextEditingController();
  final TextEditingController _callerPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _birdTypeController.value =
        TextEditingValue(text: widget.birdCase["birdName"]);
    _pickupAddressController.value =
        TextEditingValue(text: widget.birdCase["pickupAddress"]);
    _caseTypeController.value =
        TextEditingValue(text: widget.birdCase["caseType"]);
    _caseNotesController.value =
        TextEditingValue(text: widget.birdCase["caseNotes"]);
    _callerPhoneController.value =
        TextEditingValue(text: widget.birdCase["callerPhone"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Case"),
        backgroundColor: const Color(0xEEF2F8FF),
      ),
      backgroundColor: Colors.lightBlue,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Bird Type: ",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    DropdownButtonFormField(
                      items: const [
                        DropdownMenuItem(
                          value: "Crow",
                          child: Text("Crow"),
                        ),
                        DropdownMenuItem(
                          value: "Peigon",
                          child: Text("Peigon"),
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
                          _birdTypeController.value =
                              TextEditingValue(text: value.toString());
                        });
                      },
                      value: widget.birdCase["birdName"],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      "Pickup Address: ",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _pickupAddressController,
                      decoration: const InputDecoration(
                        hintText: "Pickup Address",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a valid address";
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      "Case Type: ",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
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
                          _caseTypeController.value =
                              TextEditingValue(text: value.toString());
                        });
                      },
                      value: widget.birdCase["caseType"],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      "Case Notes: ",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _caseNotesController,
                      decoration: const InputDecoration(
                        hintText: "Case Notes",
                      ),
                      validator: (value) {
                        if (value!.isEmpty &&
                            _caseTypeController.text == "Rescue") {
                          return "Please enter a note for rescue case";
                        }
                        return null;
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      "Caller Number: ",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    TextFormField(
                      controller: _callerPhoneController,
                      decoration: const InputDecoration(
                        hintText: "Caller Number",
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
                    const Padding(padding: EdgeInsets.all(10)),
                    Center(
                      child: GFButton(
                        shape: GFButtonShape.pills,
                        color: Colors.green,
                        onPressed: () async {
                          var newData = Map<Object, dynamic>.from({
                            "birdName": _birdTypeController.text,
                            "pickupAddress": _pickupAddressController.text,
                            "caseType": _caseTypeController.text,
                            "caseNotes": _caseNotesController.text,
                            "callerPhone": _callerPhoneController.text,
                          });
                          if (_formKey.currentState!.validate()) {
                            debugPrint("Updating case");
                            await widget.firestore
                                .collection("Cases")
                                .doc(widget.id)
                                .update(
                                  newData,
                                );
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(msg: "Case Updated!");
                          }
                        },
                        child: const Text("Update"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
