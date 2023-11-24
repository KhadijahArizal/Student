import 'package:flutter/material.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/LayerTwo/Tab/edit/supervisorForm.dart';

// ignore: must_be_immutable
class Supervisor extends StatelessWidget {
 late String supervisor, email, contact;

   Supervisor({Key? key,required this.supervisor,required this.email,required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text('Supervisor',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
                  Text(supervisor, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Email',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
                  Text(email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Contact No',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
                  Text(contact, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 70),
              Container(
                alignment: Alignment.bottomRight,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SupervisorForm(),
                      ),
                    );
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
