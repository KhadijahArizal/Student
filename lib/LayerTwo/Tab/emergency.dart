import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/emergencyForm.dart';

class Emergency extends StatelessWidget {
  final String name, relationship, econtact, address;

  const Emergency(
      {super.key,
      required this.name,
      required this.relationship,
      required this.econtact,
      required this.address});

  @override
  Widget build(BuildContext context) {
    //saveEdit save = ModalRoute.of(context)!.settings.arguments as saveEdit;
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text('Name',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(name, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Relationship',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(relationship, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Phone No',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(econtact, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 50),
              const Text('Address',
                  style: TextStyle(fontSize: 13, color: Colors.black54)),
              Text(address, style: const TextStyle(fontSize: 16)),
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
                        builder: (context) => const EmergencyForm(),
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
