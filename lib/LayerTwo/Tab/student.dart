import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/studentForm.dart';

// ignore: must_be_immutable
class Student extends StatefulWidget {
  late String name = '';
  late String phone = '';
  late String major = '';
  late String ic = '';
  late String address = '';

  Student(
      {Key? key,
      required String name,
      required String address,
      required String ic,
      required String phone,
      required String major})
      : super(key: key);

  @override
  _studentState createState() => _studentState();
}

class _studentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    final Map<String, String>? data =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    if (data != null) {
      setState(() {
        widget.name = data['name'] ?? '';
        widget.address = data['address'] ?? '';
        widget.ic = data['ic'] ?? '';
        widget.phone = data['phone'] ?? '';
        widget.major = data['major'] ?? '';
      });
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white.withOpacity(0.1),
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildDetail('Name', widget.name),
                _buildDetail('Phone No', widget.phone)
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,children: [
                  const Text('Email',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                      textAlign: TextAlign.start,),
                  _email(email: 'admin@live.iium.edu.my')
                ]),
                _buildDetail('Major', widget.major)
              ]),
              const SizedBox(height: 50),
              _buildDetail('IC/Passport No', widget.ic),
              _buildDetail('Current Address', widget.address),
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
                        builder: (context) => const studentForm(),
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
            ],
          ),
        ),
      ),
    );
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

  Widget _email({required String email}) => Container(
        child: Column(
          children: [
            Text(
              email,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            )
          ],
        ),
      );
}
