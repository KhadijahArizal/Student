import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Company Details
  late DatabaseReference _supervisorRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _supervisorRef =
          FirebaseDatabase.instance.ref('Student').child('Supervisor Details');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot supervisorSnapshot =
          await _supervisorRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? supervisorData =
          supervisorSnapshot.value as Map<dynamic, dynamic>?;

      if (supervisorData != null) {
        supervisorData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String stUserId = value['userId'] ?? '';
            String svname = value['Supervisor Name'] ?? '';
            String svemail = value['Email'] ?? '';
            String svcontact = value['Contact No'] ?? '';

            UserData user = UserData(
              userId: userId,
              stUserId: stUserId,
              svemail: svemail,
              svname: svname,
              svcontact: svcontact,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            color: Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(40),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        _buildDetail('Supervisor', user?.svname ?? '-'),
                        _buildDetail('Email', user?.svemail ?? '-'),
                        _buildDetail('Contact No', user?.svcontact ?? '-'),
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
                            builder: (context) => const SupervisorForm()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  label:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                )),
              ]),
            ])));
  }
}

class UserData {
  final String userId;
  final String svname, svemail, svcontact, stUserId;

  UserData({
    required this.userId,
    required this.svname,
    required this.svemail,
    required this.svcontact,
    required this.stUserId,
  });
}
