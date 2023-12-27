import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/edit/supervisorForm.dart';

class Supervisor extends StatefulWidget {
  const Supervisor({
    Key? key,
    this.supervisor,
    this.email,
    this.contact,
  }) : super(key: key);

  final String? email, contact, supervisor;

  @override
  _SupervisorState createState() => _SupervisorState();
}

class _SupervisorState extends State<Supervisor> {
  late TextEditingController supervisor;
  late TextEditingController email;
  late TextEditingController contact;

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
    var studentData = Provider.of<Data>(context);
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child: Consumer<Data>(builder: (context, Data, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetail('Supervisor', studentData.svname.text),
                    _buildDetail('Email', studentData.svemail.text),
                    _buildDetail('Contact No', studentData.svcontact.text),
                    const SizedBox(height: 70),
                    Row(children: [
                      Expanded(
                          child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SupervisorForm(
                                        initialSupervisor: supervisor.text,
                                        initialEmail: email.text,
                                        initialContact: contact.text,
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(0, 146, 143, 10),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon:
                            const Icon(Icons.edit_rounded, color: Colors.white),
                        label: const Text("Edit",
                            style: TextStyle(color: Colors.white)),
                      )),
                    ]),
                  ]);
            })));
  }
}
