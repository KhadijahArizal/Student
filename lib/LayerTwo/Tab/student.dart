import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/studentForm.dart';

class Student extends StatefulWidget {
  const Student(
      {Key? key,
      this.name,
      this.email,
      this.contact,
      this.address,
      this.ic,
      this.citizenship,
      this.major,
      this.initialMatric})
      : super(key: key);

  final String? name,
      email,
      contact,
      address,
      ic,
      citizenship,
      major,
      initialMatric;

  @override
  _studentState createState() => _studentState();
}

class _studentState extends State<Student> {
  late TextEditingController name =
      TextEditingController(text: widget.name ?? '-');
  late TextEditingController email =
      TextEditingController(text: widget.email ?? '-');
  late TextEditingController matric =
      TextEditingController(text: widget.initialMatric ?? '-');
  late TextEditingController contact =
      TextEditingController(text: widget.contact ?? '-');
  late TextEditingController address =
      TextEditingController(text: widget.address ?? '-');
  late TextEditingController ic = TextEditingController(text: widget.ic ?? '-');
  late TextEditingController citizenship =
      TextEditingController(text: widget.citizenship ?? '-');

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.name ?? '-');
    email = TextEditingController(text: widget.email ?? '-');
    matric = TextEditingController(text: widget.initialMatric ?? '-');
    contact = TextEditingController(text: widget.contact ?? '-');
    address = TextEditingController(text: widget.address ?? '-');
    ic = TextEditingController(text: widget.ic ?? '-');
    citizenship = TextEditingController(text: widget.citizenship ?? '-');
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

  Widget _buildDetail2(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
    User? user = FirebaseAuth.instance.currentUser;
    return SingleChildScrollView(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Name', '${user?.displayName}'),
              _buildDetail2('Matric No', '${widget.initialMatric}')
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Email', '${user?.email}'),
              _buildDetail2('Major', dropdownValueMajor)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Contact No', contact.text),
              _buildDetail2('Current Address', address.text),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('IC/Passport No', ic.text),
              _buildDetail2('Citizenship', citizenship.text)
            ]),
            const SizedBox(height: 70),
            Container(
                child: Row(children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => studentForm(
                        initialBr: dropDownValueBr,
                        initialName: name.text,
                        initialEmail: email.text,
                        initialContact: contact.text,
                        initialAddress: address.text,
                        initialIc: ic.text,
                        initialCitizenship: citizenship.text,
                        initialMajor: dropdownValueMajor,
                        matric: '',
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      print('Result: $result');
                      dropDownValueBr = result['br'] ?? '-';
                      name.text = result['name'] ?? '-';
                      email.text = result['email'] ?? '-';
                      matric.text = result['matric'] ?? '-';
                      contact.text = result['contact'] ?? '-';
                      address.text = result['address'] ?? '-';
                      ic.text = result['ic'] ?? '-';
                      citizenship.text = result['citizenship'] ?? '-';
                      dropdownValueMajor = result['major'] ?? '-';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.edit_rounded,
                    color: Colors.white), // Icon data for elevated button
                label:
                    const Text("Edit", style: TextStyle(color: Colors.white)),
              ))
            ])),
          ],
        ),
      ),
    );
  }
}
