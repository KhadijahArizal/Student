import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/edit/emergencyForm.dart';

class Emergency extends StatefulWidget {
  const Emergency({
    Key? key,
    this.ename,
    this.relationship,
    this.econtact,
    this.eaddress,
  }) : super(key: key);

  final String? ename, relationship, econtact, eaddress;

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

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    return SingleChildScrollView(
        child: Container(
      color: Colors.white.withOpacity(0.1),
      padding: const EdgeInsets.all(40),
      child: Consumer<Data>(builder: (context, Data, child) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildDetail('Name', studentData.ename.text),
          _buildDetail('Relationship', studentData.relationship.text),
          _buildDetail('Emergency Contact Person', studentData.econtact.text),
          _buildDetail('Home Address', studentData.eaddress.text),
          const SizedBox(height: 70),
          Row(children: [
            Expanded(
                child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.edit_rounded,
                  color: Colors.white), // Icon data for elevated button
              label: const Text("Edit", style: TextStyle(color: Colors.white)),
            ))
          ]),
        ]);
      }),
    ));
  }
}
