// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class AttachFileDetailsPage extends StatefulWidget {
  final MonthlyReport? editReport;

  const AttachFileDetailsPage({
    super.key,
    this.editReport,
    required ReportType reportType,
  });

  @override
  _AttachFileDetailsPageState createState() => _AttachFileDetailsPageState();
}

extension DateTimeExtension on DateTime {}

class _AttachFileDetailsPageState extends State<AttachFileDetailsPage> {
  int submissionCount = 0;
  DateTime selectedDate = DateTime.now();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //IAP
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    Data reportsProvider = Provider.of<Data>(context, listen: false);
    reportsProvider.monthlyReportLink.text = '';
    reportsProvider.titleM.text = '';
    reportsProvider.submitController.text =
        DateFormat('dd MMMM yyyy').format(DateTime.now());
    reportsProvider.monthController.text =
        DateFormat('MMMM').format(DateTime.now());
    if (user != null) {
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

            UserData user = UserData(
              userId: userId,
              matric: matric,
              name: name,
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

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: Text(
          widget.editReport == null ? 'Add Report' : 'Edit Report',
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
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
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<Data>(builder: (context, reportsProvider, child) {
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetail('Name:', user?.name ?? '-'),
                                    _buildDetail2(
                                        'Matric:', user?.matric ?? '-')
                                  ]),
                            ],
                          );
                        }
                      },
                    ),
                    const Divider(thickness: 1),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 3,
                            child: TextFormField(
                              key: UniqueKey(),
                              controller: studentData.monthlyReportLink,
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon: const Icon(Icons.link_rounded),
                                labelText: 'Monthly Report',
                                hintText: "https://",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the file links';
                                }
                                return null;
                              },
                            )),
                        const SizedBox(width: 5),
                        Flexible(
                            flex: 0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Tooltip(
                                message: 'Please make sure link is Accessible',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showLinkformat(context);
                                      },
                                      child: const Icon(
                                        Icons.info,
                                        size: 30,
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reportsProvider.titleM,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.none),
                          ),
                          fillColor: Colors.grey[100],
                          filled: true,
                          prefixIcon: const Icon(Icons.title_rounded),
                          labelText: 'Title',
                          hintText: 'Matric No_Week 1/2/3...?'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reportsProvider.submitController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'Submission Date',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: reportsProvider.monthController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'Month',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            message:
                                'Declaration\nBy clicking the submit button you are agreeing to the below statements: \n1. I have provided the correct and accurate information when completing this monthly report. \n2. I have consulted with my supervisor regarding the description of the assigned tasks for the month.\n3. I understand the department may collect my information and disclose to the kulliyyah for progress monitoring purposes.\n4. I am responsible for any legal implication imposed by the company for any misleading information found in the submitted report.',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDeclaration(context);
                                  },
                                  child: const Icon(
                                    Icons.info,
                                    size: 30,
                                    color: Color.fromRGBO(0, 146, 143, 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromRGBO(0, 146, 143, 10)),
                              elevation: 0.0,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 146, 143, 10),
                              ),
                            ),
                          )),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () async {
                            User? user = FirebaseAuth.instance.currentUser;
                            int submissionCount =
                                (reportsProvider.reports.length + 1) + 1;

                            // Check if both link and title are filled
                            if (reportsProvider
                                    .monthlyReportLink.text.isEmpty ||
                                reportsProvider.titleM.text.isEmpty) {
                              _showErrorDialog(context,
                                  'Please fill in both the link and title before submitting the report.');
                              return; // Stop execution if not filled
                            }

                            if (user != null) {
                              String userId = user.uid;

                              if (widget.editReport != null) {
                                Provider.of<Data>(context, listen: false)
                                    .removeReport(widget.editReport!);
                              }

                              DatabaseReference userRef = FirebaseDatabase
                                  .instance
                                  .ref('Student')
                                  .child('Monthly Report')
                                  .child(userId)
                                  .child('Reports')
                                  .push();

                              userRef.set({
                                'Report Key':userRef.key,
                                'Student ID': userId,
                                'Week': submissionCount,
                                'Link': reportsProvider.monthlyReportLink.text,
                                'Title': reportsProvider.titleM.text,
                                'Month': reportsProvider.monthController.text,
                                'Submission Date':
                                    reportsProvider.submitController.text,
                                'Status': 'Pending',
                                'Feedback': 'No feedback sent yet, please check later. Fighting Internship!'
                              });
                              // Navigate back to the monthly report page
                              Navigator.pushNamed(context, '/monthly_report');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor:
                                const Color.fromRGBO(0, 146, 143, 10),
                          ),
                          child: Text(
                              widget.editReport == null
                                  ? 'Submit Report'
                                  : 'Update Report',
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ]),
                  ],
                );
              })),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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

  void showDeclaration(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Declaration',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          content: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      'By clicking the submit button you are agreeing to the below statements: \n',
                ),
                TextSpan(
                  text:
                      '\n1. I have provided the correct and accurate information when completing this monthly report. ',
                ),
                TextSpan(
                  text:
                      '\n2. I have consulted with my supervisor regarding the description of the assigned tasks for the month. ',
                ),
                TextSpan(
                  text:
                      '\n3. I understand the department may collect my information and disclose to the kulliyyah for progress monitoring purposes. ',
                ),
                TextSpan(
                    text:
                        '\n4. I am responsible for any legal implication imposed by the company for any misleading information found in the submitted report.'),
              ],
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
                )),
          ],
        );
      },
    );
  }

  void showLinkformat(BuildContext context) {
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
          content: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Make sure the link is ',
                ),
                TextSpan(
                  text: 'Accessible!',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Futura',
                  ),
                ),
              ],
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
                )),
          ],
        );
      },
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
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDetail2(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ],
    );
  }
}

class UserData {
  final String userId;
  final String matric;
  final String name;

  UserData({
    required this.userId,
    required this.matric,
    required this.name,
  });
}
