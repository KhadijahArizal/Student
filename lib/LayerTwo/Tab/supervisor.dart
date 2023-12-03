import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/supervisorForm.dart';

class Supervisor extends StatefulWidget {
  const Supervisor({
    Key? key,
    this.supervisor,
    this.email,
    this.contact,
  }) : super(key: key);

  final String? supervisor, email, contact;
  @override
  _SupervisorState createState() => _SupervisorState();
}

class _SupervisorState extends State<Supervisor> {
  late TextEditingController supervisor =
      TextEditingController(text: widget.supervisor ?? '-');
  late TextEditingController email =
      TextEditingController(text: widget.email ?? '-');
  late TextEditingController contact =
      TextEditingController(text: widget.contact ?? '-');

  @override
  void initState() {
    super.initState();
    supervisor = TextEditingController(text: widget.supervisor ?? '-');
    email = TextEditingController(text: widget.email ?? '-');
    contact = TextEditingController(text: widget.contact ?? '-');
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
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              _buildDetail('Supervisor', supervisor.text),
              _buildDetail('Email', email.text),
              _buildDetail('Contact No', contact.text),
              const SizedBox(height: 50),
              Container(
                  child: Row(children: [
                Expanded(
                    child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupervisorForm(
                          initialSupervisor: supervisor.text,
                          initialEmail: email.text,
                          initialContact: contact.text,
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        print('Result: $result');
                        supervisor.text = result['supervisor'] ?? '-';
                        email.text = result['email'] ?? '-';
                        contact.text = result['contact'] ?? '-';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(
                      Icons.edit_rounded), // Icon data for elevated button
                  label: const Text("Edit"),
                ))
              ])),
            ])));
  }
}
