import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/studentForm.dart';

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  _studentState createState() => _studentState();
}

class _studentState extends State<Student> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Student Details
  late DatabaseReference _iapFormRef;
  late DatabaseReference _studentRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _studentRef =
          FirebaseDatabase.instance.ref('Student').child('Student Details');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot studentSnapshot =
          await _studentRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? studentData =
          studentSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && studentData != null) {
        studentData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String matric = value['Matric No'] ?? '';
            String name = value['Student Name'] ?? '';
            String email = value['Email'] ?? '';
            String major = value['Major'] ?? '';
            String ic = value['IC or Passport'] ?? '';
            String contactno = value['Contact No'] ?? '';
            String citizenship = value['Citizenship'] ?? '';
            String address = value['Address'] ?? '';

            UserData user = UserData(
              userId: userId,
              matric: matric,
              name: name,
              major: major,
              ic: ic,
              email: email,
              contactno: contactno,
              citizenship: citizenship,
              address: address,
            );
            userDataList.add(user);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
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
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            salutation,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          )
        ]),
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
    return SingleChildScrollView(
      child: Container(
          color: Colors.white.withOpacity(0.1),
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<UserData>>(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    var user = snapshot.data?.isNotEmpty == true
                        ? snapshot.data![0]
                        : null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail('Name', user?.name ?? '-'),
                              _buildDetail2('Matric No', user?.matric ?? '-')
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail('Email', user?.email ?? '-'),
                              _buildDetail2('Major', user?.major ?? '-')
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail(
                                  'Contact No', user?.contactno ?? '-'),
                              _buildDetail2(
                                  'Current Address', user?.address ?? '-'),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail('IC/Passport No', user?.ic ?? '-'),
                              _buildDetail2(
                                  'Citizenship', user?.citizenship ?? '-')
                            ]),
                        const SizedBox(height: 70),
                      ],
                    );
                  }
                },
              ),
              Row(children: [
                Expanded(
                    child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            studentForm(initialName: '', initialEmail: ''),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  label:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ))
              ]),
            ],
          )),
    );
  }
}

class UserData {
  final String userId;
  final String matric;
  final String name;
  final String major;
  final String ic;
  final String email;
  final String contactno;
  final String citizenship;
  final String address;

  UserData({
    required this.userId,
    required this.matric,
    required this.name,
    required this.major,
    required this.ic,
    required this.email,
    required this.contactno,
    required this.citizenship,
    required this.address,
  });
}
