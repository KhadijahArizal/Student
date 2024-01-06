import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/layerOne/start.dart';

class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({
    super.key,
    required this.name,
    required this.email,
    required this.matric,
  });
  final String name;
  final String email;
  final String matric;

  @override
  _AdminReviewPageState createState() => _AdminReviewPageState();
}

class _AdminReviewPageState extends State<AdminReviewPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController matric = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Iap
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    email.text = widget.email;
    matric.text = widget.matric;
    if (user != null) {
      //Iap
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null) {
        iapData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String email = iapData[key]['Email'] ?? '';
            String iapStatus = value['Status'] ?? '';
            String comment = value['Comment'] ?? '';

            UserData user = UserData(
                userId: userId,
                email: email,
                matric: matric,
                name: name,
                iapStatus: iapStatus,
                comment: comment);
            userDataList.add(user);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(
              'Review Page',
              style: TextStyle(
                  color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
              textAlign: TextAlign.right,
            )
          ]),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(0, 146, 143, 10),
            size: 30,
          ),
          automaticallyImplyLeading: false),
      body: Container(
        padding: const EdgeInsets.only(bottom: 100),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: const AssetImage('assets/iiumlogo.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white30.withOpacity(0.2),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        var userIAP = snapshot.data?.isNotEmpty == true
                            ? snapshot.data![0]
                            : null;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 20, right: 20),
                              child: Text(
                                'Thank You!',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 146, 143, 10),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                    fontFamily: 'Futura',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'your application has been ',
                                    ),
                                    TextSpan(
                                      text: 'SUBMITTED',
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          ' for approval by IAP Coordinator. kindly click the ',
                                    ),
                                    const TextSpan(
                                      text: 'button',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' below for any ',
                                    ),
                                    const TextSpan(
                                      text: 'update and status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' of your IAP Application.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                width: double
                                    .infinity, // Make the container full width
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Text(
                                      userIAP?.name ?? '',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Futura',
                                      ),
                                    ),
                                    Text(
                                      userIAP?.matric ?? '',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                        fontSize: 15,
                                        fontFamily: 'Futura',
                                      ),
                                    ),
                                    Text(
                                      userIAP?.email ?? '',
                                      style: const TextStyle(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                        fontSize: 15,
                                        fontFamily: 'Futura',
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Start()));
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: const Center(
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                        fontFamily: 'Futura',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (user != null) {
                                    String userId = user!.uid;

                                    DatabaseReference userRef = FirebaseDatabase
                                        .instance
                                        .ref('Student')
                                        .child('Company Details')
                                        .child(userId);

                                    userRef.set({
                                      'Student ID': userId,
                                      'Status': 'Inactive'
                                    });

                                    if (userIAP?.iapStatus == 'Approved') {
                                      Navigator.pushNamed(context, '/summary');
                                    } else if (userIAP?.iapStatus ==
                                        'Pending') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Application Pending'),
                                            content:
                                                Text(userIAP?.comment ?? ''),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (userIAP?.iapStatus ==
                                        'Rejected') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Application Rejected'),
                                            content:
                                                Text(userIAP?.comment ?? ''),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _getButtonColor(userIAP?.iapStatus),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Current Status: ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Futura',
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: userIAP?.iapStatus != null
                                                ? userIAP?.iapStatus ?? ''
                                                : '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor(String? status) {
    switch (status) {
      case 'Approved':
        return const Color.fromRGBO(0, 146, 143, 10);
      case 'Pending':
        return Colors.yellow[800]!;
      case 'Rejected':
        return Colors.red[700]!;
      default:
        return Colors.grey; // Default color for unknown status
    }
  }
}

class UserData {
  final String userId;
  final String email;
  final String matric;
  final String name;
  final String iapStatus;
  final String comment;

  UserData({
    required this.userId,
    required this.email,
    required this.matric,
    required this.name,
    required this.iapStatus,
    required this.comment,
  });
}
