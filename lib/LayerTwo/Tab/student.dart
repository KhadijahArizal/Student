import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/edit/studentForm.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class Student extends StatefulWidget {
  const Student(
      {Key? key,
      this.name,
      this.email,
      this.contact,
      this.address,
      this.ic,
      this.citizenship,
      this.initialMatric})
      : super(key: key);

  final String? name,
      email,
      contact,
      address,
      ic,
      citizenship,
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

  Widget _buildDetailS(String label, String salutation, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Text(
          salutation,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(width: 5),
          Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        )]),
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
    var studentData = Provider.of<Data>(context);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(40),
        child: Consumer<Data>(
          builder: (context, Data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetailS('Name', dropdownValueSalutation, '${user?.displayName}'),
                      _buildDetail2('Matric No', studentData.matric.text)
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetail('Email', '${user?.email}'),
                      _buildDetail2('Major', dropdownValueMajor)
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetail('Contact No', studentData.contact.text),
                      _buildDetail2(
                          'Current Address', studentData.address.text),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDetail('IC/Passport No', studentData.ic.text),
                      _buildDetail2('Citizenship', studentData.citizenship.text)
                    ]),
                const SizedBox(height: 70),
                Row(children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => studentForm(
                            initialSalutation: dropdownValueSalutation,
                            initialName: name.text,
                            initialEmail: email.text,
                            initialMatric: matric.text,
                            initialContact: contact.text,
                            initialAddress: address.text,
                            initialIc: ic.text,
                            initialCitizenship: citizenship.text,
                            initialMajor: dropdownValueMajor,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.edit_rounded, color: Colors.white),
                    label: const Text("Edit",
                        style: TextStyle(color: Colors.white)),
                  ))
                ]),
              ],
            );
          },
        ),
      ),
    );
  }
}
