import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/emergencyForm.dart';

class Emergency extends StatefulWidget {
  const Emergency({
    Key? key,
  }) : super(key: key);

  @override
  _EmergencyState createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Company Details
  late DatabaseReference _emergencyRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _emergencyRef =
          FirebaseDatabase.instance.ref('Student').child('Emergency Details');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot emergencySnapshot =
          await _emergencyRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? emergencyData =
          emergencySnapshot.value as Map<dynamic, dynamic>?;

      if (emergencyData != null) {
        emergencyData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String emergname = value['Name'] ?? '';
            String contact = value['Emergency Contact Person'] ?? '';
            String relay = value['Relationship'] ?? '';
            String homeadd = value['Home Address'] ?? '';

            UserData user = UserData(
              userId: userId,
              emergname: emergname,
              contact: contact,
              relay: relay,
              homeadd: homeadd,
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
                        _buildDetail('Name', user?.emergname?? '-'),
                        _buildDetail('Relationship', user?.relay?? '-'),
                        _buildDetail('Emergency Contact Person', user?.contact?? '-'),
                        _buildDetail('Home Address', user?.homeadd?? '-'),
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
                        builder: (context) => const EmergencyForm(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.edit_rounded,
                      color: Colors.white), // Icon data for elevated button
                  label:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ))
              ]),
            ])));
  }
}

class UserData {
  final String userId;
  final String emergname, contact, relay, homeadd;

  UserData({
    required this.userId,
    required this.emergname,
    required this.contact,
    required this.relay,
    required this.homeadd,
  });
}
