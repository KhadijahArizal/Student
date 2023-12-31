import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class Examiner extends StatefulWidget {
  Examiner({
    Key? key,
    this.examiner,
    this.email,
    this.contact,
    //required this.studentData
  }) : super(key: key);

  final String? email, contact, examiner;
  //final Data studentData;

  /*void updateDatabase() {
    User? user = FirebaseAuth.instance.currentUser;
    // Access studentData directly, no need for Provider.of<Data>(context)
    var data = studentData;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref('Student')
          .child('Examiner Details')
          .child(userId);

      userRef.set({
        'Supervisor Name': data.exname.text,
        'Contact No': data.excontact.text,
        'Email': data.exemail.text,
      });
    }
  }*/

  @override
  _ExaminerState createState() => _ExaminerState();
}

class _ExaminerState extends State<Examiner> {
  @override
  void initState() {
    super.initState();
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
                    _buildDetail('Examiner', studentData.exname.text),
                    _buildDetail('Email', studentData.exemail.text),
                    _buildDetail('Contact No', studentData.excontact.text),
                  ]);
            })));
  }
}
