import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class EmergencyForm extends StatefulWidget {
  final String? initialEname;
  final String? initialRelationship;
  final String? initialEcontact;
  final String? initialEaddress;

  const EmergencyForm({
    Key? key,
    this.initialEname,
    this.initialRelationship,
    this.initialEcontact,
    this.initialEaddress,
  }) : super(key: key);

  @override
  _EmergencyFormState createState() => _EmergencyFormState();
}

class _EmergencyFormState extends State<EmergencyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ename = TextEditingController();
  TextEditingController relationship = TextEditingController();
  TextEditingController econtact = TextEditingController();
  TextEditingController eaddress = TextEditingController();
  late DatabaseReference emergencydb;

  @override
  void initState() {
    super.initState();
    emergencydb = FirebaseDatabase.instance.ref('Emergency Details');
    if (widget.initialEname != null) {
      ename.text = widget.initialEname!;
      relationship.text = widget.initialRelationship ?? '';
      econtact.text = widget.initialEcontact ?? '';
      eaddress.text = widget.initialEaddress ?? '';
    }
  }

  void GoEmergency() {
    Navigator.pop(context, {
      'ename': ename.text,
      'relationship': relationship.text,
      'econtact': econtact.text,
      'eaddress': eaddress.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            title: const Text(
              'Emergency Contact Details',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Futura'),
            ),
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData(
                color: Color.fromRGBO(148, 112, 18, 1), size: 30)),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: const AssetImage('assets/iiumlogo.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.white30.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
                child: SingleChildScrollView(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        ename.text = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.person_rounded),
                                      labelText: 'Name',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        relationship.text = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon: const Icon(
                                          Icons.connect_without_contact),
                                      labelText: 'Relationship',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        econtact.text = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.call_rounded),
                                      labelText: 'Emergency Contact Person',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        eaddress.text = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.location_on_rounded),
                                      labelText: 'Home Address',
                                    ),
                                  ),
                                ]))),
                        const SizedBox(height: 25),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {
                                      emergencydb.set({
                                'Emergency Contact Name': ename.text,
                                'Relationship': relationship.text,
                                'Contact No': econtact.text,
                                'Home Address': eaddress.text,
                              });
                                      GoEmergency();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            148, 112, 18, 1),
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text('Save',style: TextStyle(color: Colors.white)),
                                  ))
                                ]))
                      ]),
                )))));
  }
}
