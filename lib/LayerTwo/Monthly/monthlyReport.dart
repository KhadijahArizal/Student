// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use, unrelated_type_equality_checks

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/Monthly/attachFileDetails.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import '../Detect Status/statusManagament.dart';
import 'package:url_launcher/url_launcher.dart';

enum ReportType {
  file,
  create,
}

class MonthlyReport extends StatefulWidget {
  MonthlyReport({
    Key? key,
    this.fileName,
    this.createdDate,
    this.month,
    this.submissionDate,
    this.status,
    this.fileUrl,
    required this.onCalculateStatus,
    required this.weekNumber,
  })  : statusColor = _getStatusColor(status),
        super(key: key);

  final String? fileUrl;

  final int weekNumber;
  final String? fileName, createdDate, month, submissionDate, status;
  final Color statusColor;
  final void Function(int approved, int pending, int rejected)
      onCalculateStatus;

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  int submissionCount = 0;
  late StatusManagement _statusManagement;
  final StatusManagement statusManager = StatusManagement();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  User? user = FirebaseAuth.instance.currentUser;

  //Monthly Report
  late DatabaseReference _iapFormRef;
  late DatabaseReference _monthlyReport;
  late Future<List<UserData>> _userDataFuture;

  //Zone - Company
  late DatabaseReference _zoneRef;
  late Future<List<ZoneData>> _userZoneFuture;

  //Ex
  late DatabaseReference _exRef;
  late Future<List<UserData1>> _userDataFutureSvEx;

  int _currentIndex = 1;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1 && _statusManagement.studentStatus == 'Active') {
        Navigator.pushNamed(context, '/monthly_report');
      } else if (index == 2 && _statusManagement.studentStatus == 'Active') {
        Navigator.pushNamed(context, '/final_report');
      }
    });
  }

  @override
  void dispose() {
    _statusManagement.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _statusManagement = StatusManagement();
    if (user != null) {
      //Monthly Report
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _monthlyReport =
          FirebaseDatabase.instance.ref('Student').child('Monthly Report');
      _userDataFuture = _fetchUserData();

      //Zone - company
      _zoneRef =
          FirebaseDatabase.instance.ref('Student').child('Company Details');
      _userZoneFuture = _fetchZoneData();

      //Ex
      _exRef =
          FirebaseDatabase.instance.ref('Student').child('Assign Examiner');
      _userDataFutureSvEx = _fetchSvExData();

      //Calculate Report length to summary
      _fetchUserData().then((userDataList) {
        calculateReportStatus(userDataList);
      });
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && monthlyReportData != null) {
        iapData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              monthlyReportData.containsKey(key) &&
              key == userId) {
            String matric = value['Matric'] ?? '';
            String name = value['Name'] ?? '';
            List<MonthlyReportData> monthlyReports = [];

            if (monthlyReportData[key]['Reports'] is Map) {
              monthlyReportData[key]['Reports']
                  .forEach((reportId, reportValue) {
                MonthlyReportData monthlyReport = MonthlyReportData(
                    reportId: reportId,
                    titleM: reportValue['Title'] ?? '',
                    month: reportValue['Month'] ?? '',
                    status: reportValue['Status'] ?? 'Pending',
                    date: reportValue['Submission Date'] ?? '',
                    monthlyReportLink: reportValue['Link'] ?? '',
                    reportsKey: reportValue['Report Key'] ?? '',
                    feedback: reportValue['Feedback'] ?? '');
                monthlyReports.add(monthlyReport);
              });
            }

            UserData user = UserData(
              userId: userId,
              matric: matric,
              name: name,
              monthlyReports: monthlyReports,
            );
            userDataList.add(user);
          }
        });
        calculateReportStatus(userDataList);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  Future<List<ZoneData>> _fetchZoneData() async {
    List<ZoneData> userDataList = [];
    try {
      DataSnapshot companySnapshot =
          await _zoneRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? companyData =
          companySnapshot.value as Map<dynamic, dynamic>?;

      if (companyData != null) {
        companyData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            //Zone - company
            String zone = value['Zone'] ?? '';

            ZoneData userZ = ZoneData(
              userId: userId,
              zone: zone,
            );
            userDataList.add(userZ);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  void calculateReportStatus(List<UserData> userDataList) async {
    int approvedCount = 0;
    int pendingCount = 0;
    int rejectedCount = 0;

    for (var user in userDataList) {
      for (var report in user.monthlyReports) {
        switch (report.status) {
          case 'Approved':
            approvedCount++;
            break;
          case 'Pending':
            pendingCount++;
            break;
          case 'Rejected':
            rejectedCount++;
            break;
          default:
            break;
        }
      }
    }

    widget.onCalculateStatus(approvedCount, pendingCount, rejectedCount);

    // Update counts in the database
    await updateSummaryCounts(approvedCount, pendingCount, rejectedCount);
  }

  Future<void> updateSummaryCounts(
      int approvedCount, int pendingCount, int rejectedCount) async {
    DatabaseReference summaryRef = FirebaseDatabase.instance
        .ref('Student')
        .child('Monthly Report')
        .child(userId)
        .child('SummaryCounts');
    await summaryRef.set({
      'approved': approvedCount,
      'pending': pendingCount,
      'rejected': rejectedCount,
    });
  }

  Future<List<UserData1>> _fetchSvExData() async {
    List<UserData1> userDataList1 = [];
    try {
      DataSnapshot exSnapshot =
          await _exRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? exData =
          exSnapshot.value as Map<dynamic, dynamic>?;

      if (exData != null) {
        exData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              exData!.containsKey(key) &&
              key == userId) {
            String exName = exData[key]['ExaminerName'] ?? '';
            String exEmail = exData[key]['ExaminerEmail'] ?? '';

            UserData1 user1 = UserData1(
              userId: userId,
              exName: exName,
              exEmail: exEmail,
            );
            userDataList1.add(user1);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Monthly Report',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(0, 146, 143, 10), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: sideNav2(statusManagement: _statusManagement),
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
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder<List<UserData1>>(
                              future: _userDataFutureSvEx,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var userE = snapshot.data![index];
                                      return Container(
                                        margin: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildDetail(
                                                'Examiner', userE.exName),
                                                const SizedBox(height: 10),
                                                _buildDetail(
                                                'Email', userE.exEmail),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Evaluation Zone',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black54,
                                )),
                            //ZONE
                            FutureBuilder<List<ZoneData>>(
                              future: _userZoneFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      var userZ = snapshot.data![index];
                                      return Container(
                                        margin: const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _zone(zone: userZ.zone),
                                            const SizedBox(height: 8),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text('Monthly Report Submission',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromRGBO(0, 146, 143, 10))),
                    FutureBuilder<List<UserData>>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(0, 146, 143, 10),
                            ),
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No data available.'));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var user = snapshot.data![index];
                              return Container(
                                margin: const EdgeInsets.all(8),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var report in user.monthlyReports)
                                      ExpansionTile(
                                        title: Text(
                                          report.month,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  flex: 4,
                                                  child: _buildDetail(
                                                      'Title:', report.titleM)),
                                              Flexible(
                                                  flex: 1,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                        Icons.delete_rounded),
                                                    onPressed: () {
                                                      _deleteReport(user.userId,
                                                          report.reportId);
                                                    },
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          const Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                'Monthly Report',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 13),
                                              )),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  onPressed: () {
                                                    _openPdfFile(report
                                                        .monthlyReportLink);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            0, 146, 143, 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100), // Set the border radius to 100
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'View Report',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )),
                                                const SizedBox(width: 7),
                                                Expanded(
                                                    child: ElevatedButton(
                                                  onPressed: () {
                                                    showFeedback();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.yellow[800],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100), // Set the border radius to 100
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'View Feedback',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ))
                                              ]),
                                          const SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildDetail(
                                                    'Date:', report.date),
                                              ),
                                              Expanded(
                                                child: _buildDetail2(
                                                    'Status:', report.status),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                )),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        routeNames: const {
          'Summary': '/summary',
          'Monthly Report': '/monthly_report',
          'Final Report': '/final_report',
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AttachFileDetailsPage(
                reportType: ReportType.file,
              ),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(0, 146, 143, 0.8),
        tooltip: 'Add final report',
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _deleteReport(String userId, String reportKey) async {
    try {
      await _monthlyReport
          .child(userId)
          .child('Reports')
          .child(reportKey)
          .remove();
      // Reload data after deletion
      setState(() {
        _userDataFuture = _fetchUserData();
      });
    } catch (e) {
      print('Error deleting report: $e');
    }
  }

  void _openPdfFile(String? fileUrl) async {
    if (fileUrl != null && fileUrl.isNotEmpty) {
      try {
        await launch(fileUrl);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the PDF file.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid PDF file URL.'),
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

  void showFeedback() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<UserData>>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(0, 146, 143, 10),
                ),
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var user =
                  snapshot.data?.isNotEmpty == true ? snapshot.data![0] : null;
              return AlertDialog(
                title: const Text('Feedback'),
                content: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (user != null)
                        for (var report in user.monthlyReports)
                          if (report.reportId == report.reportsKey)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  report.feedback,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                // Debugging print statements
                                Text('Report ID: ${report.reportId}'),
                                Text('Feedback: ${report.feedback}'),
                              ],
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(0, 146, 143, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                100), // Set the border radius to 100
                          ),
                        ),
                        child: const Text(
                          'Ok',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

Widget _buildDetailE(String label, String value) {
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
    ],
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
      const SizedBox(height: 10)
    ],
  );
}

Widget _buildDetail2(String label, String value) {
  Color statusColor = _getStatusColor(value);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
                fontSize: 15, color: statusColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10)
        ],
      ),
    ],
  );
}

Color _getStatusColor(String? status) {
  switch (status) {
    case 'Pending':
      return Colors.yellow[800]!;
    case 'Approved':
      return Colors.green[700]!;
    case 'Rejected':
      return Colors.red[700]!;
    default:
      return Colors.black87; // Default color
  }
}

Widget _zone({required String zone}) => Container(
      alignment: Alignment.topLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            zone,
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

class MonthlyReportData {
  final String reportId;
  final String month;
  final String titleM;
  final String status;
  final String feedback;
  final String date;
  final String monthlyReportLink;
  final String reportsKey;

  MonthlyReportData({
    required this.reportId,
    required this.feedback,
    required this.titleM,
    required this.month,
    required this.status,
    required this.date,
    required this.monthlyReportLink,
    required this.reportsKey,
  });
}

class UserData {
  final String userId;
  final String matric, name;
  final List<MonthlyReportData> monthlyReports;

  UserData({
    required this.userId,
    required this.matric,
    required this.name,
    required this.monthlyReports,
  });
}

class ZoneData {
  final String userId;
  final String zone;

  ZoneData({
    required this.userId,
    required this.zone,
  });
}

class UserData1 {
  final String userId;
  final String exName;
  final String exEmail;

  UserData1({
    required this.userId,
    required this.exName,
    required this.exEmail,
  });
}
