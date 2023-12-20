import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/emergencyForm.dart';

class Emergency extends StatefulWidget {
  const Emergency({
    Key? key,
    this.ename,
    this.relationship,
    this.econtact,
    this.eaddress,
  }) : super(key: key);

  final String? ename;
  final String? relationship;
  final String? econtact;
  final String? eaddress;

  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  late TextEditingController ename =
      TextEditingController(text: widget.ename ?? '-');
  late TextEditingController relationship =
      TextEditingController(text: widget.relationship ?? '-');
  late TextEditingController econtact =
      TextEditingController(text: widget.econtact ?? '-');
  late TextEditingController eaddress =
      TextEditingController(text: widget.eaddress ?? '-');

  @override
  void initState() {
    super.initState();
    ename = TextEditingController(text: widget.ename ?? '-');
    relationship = TextEditingController(text: widget.relationship ?? '-');
    econtact = TextEditingController(text: widget.econtact ?? '-');
    eaddress = TextEditingController(text: widget.eaddress ?? '-');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text('Name',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(ename.text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Relationship',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(relationship.text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Phone No',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(econtact.text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Address',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(eaddress.text, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 70),
              Container(
                  child:
                      Row(children: [
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmergencyForm(
                              initialEname: ename.text,
                              initialRelationship: relationship.text,
                              initialEcontact: econtact.text,
                              initialEaddress: eaddress.text,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            print('Result from FinalReportUpload: $result');
                            ename.text = result['ename'] ?? '-';
                            relationship.text = result['relationship'] ?? '-';
                            econtact.text = result['econtact'] ?? '-';
                            eaddress.text = result['eaddress'] ?? '-';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(
                          Icons.edit_rounded,color: Colors.white), // Icon data for elevated button
                      label: const Text("Edit",style: TextStyle(color: Colors.white)),
                    ))
                  ])),
            ])));
  }
}
