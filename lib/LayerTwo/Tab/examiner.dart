import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  @override
  _ExaminerState createState() => _ExaminerState();
}

class _ExaminerState extends State<Examiner> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Company Details
  late DatabaseReference _examinerRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _examinerRef =
          FirebaseDatabase.instance.ref('Student').child('Assign Examiner');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot examinerSnapshot =
          await _examinerRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? examinerData =
          examinerSnapshot.value as Map<dynamic, dynamic>?;

      if (examinerData != null) {
        examinerData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String stUserId = value['userId'] ?? '';
            String exexaminer = value['ExaminerName'] ?? '';
            String exemail = value['ExaminerEmail'] ?? '';

            UserData user = UserData(
              userId: userId,
              stUserId: stUserId,
              exemail: exemail,
              exexaminer: exexaminer,
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
            child: Consumer<Data>(builder: (context, Data, child) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<List<UserData>>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              _buildDetail('Examiner',
                                  user?.exexaminer ?? 'Not Assigned Yet'),
                              _buildDetail(
                                  'Email', user?.exemail ?? 'Not Assigned Yet'),
                              const SizedBox(height: 70),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          showIns(context);
                                        },
                                        child: const Icon(
                                          Icons.info,
                                          size: 30,
                                          color:
                                              Color.fromRGBO(0, 146, 143, 10),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    Row(children: [
                      Expanded(
                          child: ElevatedButton.icon(
                        onPressed: () async {
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            String userId = user.uid;
                            DatabaseReference userRef = FirebaseDatabase
                                .instance
                                .ref('Student')
                                .child('Assign Examiner')
                                .child(userId);

                            userRef.set({
                              'Supervisor Name': 'Not Assigned Yet',
                              'Email': 'Not Assigned Yet'
                            });
                            request(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(0, 146, 143, 10),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.person_rounded,
                            color: Colors.white),
                        label: const Text("Request Examiner",
                            style: TextStyle(color: Colors.white)),
                      )),
                    ]),
                  ]);
            })));
  }

  void showIns(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Attention',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SingleChildScrollView(
            child: Container(
              height: 200, // Adjust the height as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontFamily: 'Futura',
                      ),
                      children: [
                        const TextSpan(
                          text: 'Don\'t click the request button ',
                        ),
                        TextSpan(
                          text: 'twice! ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800],
                          ),
                        ),
                        const TextSpan(
                          text: ' Only the latest data is saved. ',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
              ),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white, fontFamily: 'Futura'),
              ),
            ),
          ],
        );
      },
    );
  }

  void request(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.done_all_rounded,
                    size: 110,
                    color: Colors.green[800],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Text(
                    'Submitted',
                    textAlign: TextAlign.center, //<-- Center text here
                    style: TextStyle(
                      color: Color.fromRGBO(0, 146, 143, 10),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    'Your request has been sent to coordinator. Kindly check later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: user != null
                      ? () async {
                          Navigator.pushNamed(context, '/summary');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white, fontFamily: 'Futura'),
                  )),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class UserData {
  final String userId;
  final String exexaminer, exemail, stUserId;

  UserData({
    required this.userId,
    required this.exexaminer,
    required this.exemail,
    required this.stUserId,
  });
}
