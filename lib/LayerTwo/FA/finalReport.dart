// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/LayerTwo/FA/finalReportUpload.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Detect Status/statusManagament.dart';

class FinalReport extends StatefulWidget {
  const FinalReport({Key? key}) : super(key: key);

  @override
  State<FinalReport> createState() => _FinalReportState();
}

class _FinalReportState extends State<FinalReport> {
  int monthlyReportsCount = 0;
  late StatusManagement _statusManagement;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //IAP
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  //Final and Monthly Report
  late DatabaseReference _finalReport;
  late Future<List<FinalData>> _userFinalFuture;
  late DatabaseReference _monthlyReport;
  List<MonthlyReportS> monthlyReports = [];

  //SvEx
  //late DatabaseReference _exRef;
  late DatabaseReference _svRef;
  late DatabaseReference _exRef;
  late Future<List<UserData1>> _userDataFutureSvEx;

  int _currentIndex = 2;
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
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _userDataFuture = _fetchUserData();

      _finalReport =
          FirebaseDatabase.instance.ref('Student').child('Final Report');
      _monthlyReport = FirebaseDatabase.instance
          .ref()
          .child('Student')
          .child('Monthly Report');
      _userFinalFuture = _fetchFinalData();

      _exRef =
          FirebaseDatabase.instance.ref('Student').child('Assign Examiner');
      _svRef =
          FirebaseDatabase.instance.ref('Student').child('Supervisor Details');
      _userDataFutureSvEx = _fetchSvExData();
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
        monthlyReportsCount = monthlyReportData[userId]['Reports']?.length ?? 0;

        iapData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              monthlyReportData.containsKey(key) &&
              key == userId) {
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';

            List<MonthlyReportS> monthlyReports = [];
            if (monthlyReportData[key]['Reports'] is Map) {
              monthlyReportData[key]['Reports']
                  .forEach((reportKey, reportValue) {
                MonthlyReportS monthlyReport = MonthlyReportS(
                  month: reportValue['Month'] ?? '',
                  monthlyRname: reportValue['Name'] ?? '',
                  status: reportValue['Status'] ?? '',
                  date: reportValue['Submission Date'] ?? '',
                  monthlyFile: reportValue['File'] ?? '',
                );
                monthlyReports.add(monthlyReport);
              });
            }
            if (monthlyReports.length == 6) {
              UserData user = UserData(
                userId: userId,
                matric: matric,
                name: name,
                monthlyReports: monthlyReports,
              );
              userDataList.add(user);
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  Future<List<FinalData>> _fetchFinalData() async {
    List<FinalData> userDataList = [];
    try {
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);
      DataSnapshot monthlyReportSnapshot =
          await _monthlyReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? monthlyReportData =
          monthlyReportSnapshot.value as Map<dynamic, dynamic>?;

      if (finalReportData != null && monthlyReportData != null) {
        finalReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              monthlyReportData.containsKey(key) &&
              key == userId) {
            String date = value['Date'] ?? '';
            String file = value['File'] ?? '';
            String fileName = value['File Name'] ?? '';
            String title = value['Report Title'] ?? '';
            String status = value['Status'] ?? '';
            String statusSV = value['StatusSV'] ?? '';
            String feedbackSV = value['FeedbackSV'] ?? '';
            String statusEX = value['StatusEX'] ?? '';
            String feedbackEX = value['FeedbackEX'] ?? '';

            FinalData userF = FinalData(
                userId: userId,
                date: date,
                file: file,
                fileName: fileName,
                title: title,
                status: status,
                statusSV: statusSV,
                feedbackSV: feedbackSV,
                statusEX: statusEX,
                feedbackEX: feedbackEX);
            userDataList.add(userF);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
  }

  Future<List<UserData1>> _fetchSvExData() async {
    List<UserData1> userDataList1 = [];
    try {
      DataSnapshot svSnapshot =
          await _svRef.once().then((event) => event.snapshot);
      DataSnapshot exSnapshot =
          await _exRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? svData =
          svSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? exData =
          exSnapshot.value as Map<dynamic, dynamic>?;

      if (svData != null) {
        svData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> &&
              exData!.containsKey(key) &&
              key == userId) {
            String svName = value['Supervisor Name'] ?? '';
            String svContact = value['Contact No'] ?? '';
            String svEmail = value['Email'] ?? '';

            String studentName = value['Student Name'] ?? '';

            String exName = exData[key]['ExaminerName'] ?? '';
            String exEmail = exData[key]['ExaminerEmail'] ?? '';

            UserData1 user1 = UserData1(
              userId: userId,
              svName: svName,
              svContact: svContact,
              svEmail: svEmail,
              exName: exName,
              exEmail: exEmail,
              studentName: studentName,
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
          'Final Report',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            fontFamily: 'Futura',
          ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  //Name and Matric
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetail('Name:', user?.name ?? '-'),
                                  _buildDetail2('Matric:', user?.matric ?? '-')
                                ]),
                            const Divider(thickness: 1),
                            const SizedBox(height: 5),
                          ],
                        );
                      }
                    },
                  ),
                  //Final report
                  FutureBuilder<List<FinalData>>(
                    future: _userFinalFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(0, 146, 143, 10),
                          ),
                        ));
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        var userF = snapshot.data?.isNotEmpty == true
                            ? snapshot.data![0]
                            : null;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildDetail(
                                      'Report Title:', userF?.title ?? '-'),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'Status:',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            userF?.status ?? "-",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green[700]),
                                          ),
                                          const SizedBox(height: 10)
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                            const SizedBox(height: 20),
                            _buildDetail('File Name:', userF?.fileName ?? '-'),
                            const SizedBox(height: 20),
                            const Text(
                              'Final Report',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                            const SizedBox(height: 5),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {
                                      _openPdfFile(userF?.file ?? '-');
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
                                      'View Report',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                  const SizedBox(width: 7),
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {
                                      showFeedback();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            100), // Set the border radius to 100
                                      ),
                                    ),
                                    child: const Text(
                                      'View Feedback',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                                ]),
                            const SizedBox(height: 20),
                            _buildDetail('Date:', userF?.date ?? '-'),
                          ],
                        );
                      }
                    },
                  ),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 20),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // Set the background color to off-white
                        borderRadius: BorderRadius.circular(
                            10.0), // Set border radius for rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                                0.5), // Set shadow color with opacity
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // Set the offset of the shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        const Text('Assessment',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 146, 143, 0.8),
                                fontSize: 18)),
                        const SizedBox(height: 10),
                        //SV
                        ExpansionTile(
                          title: const Text(
                            'Supervisor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Adjust the font size as needed
                            ),
                          ),
                          children: [
                            FutureBuilder<List<UserData1>>(
                              future: _userDataFutureSvEx,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(0, 146, 143, 10),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  var user1 = snapshot.data?.isNotEmpty == true
                                      ? snapshot.data![0]
                                      : null;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                         Expanded (child: _buildDetail('Supervisor Name',
                                              user1?.svName ?? '-')),
                                          //StatusSV
                                         Expanded (child:FutureBuilder<List<FinalData>>(
                                            future: _userFinalFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Color.fromRGBO(
                                                          0, 146, 143, 10),
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'),
                                                );
                                              } else {
                                                var userF =
                                                    snapshot.data?.isNotEmpty ==
                                                            true
                                                        ? snapshot.data![0]
                                                        : null;

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _buildDetailStatus('Status',
                                                        userF?.statusSV ?? '-'),
                                                  ],
                                                );
                                              }
                                            },
                                          ),
                                        )],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetail(
                                          'Email', user1?.svEmail ?? '-'),
                                      const SizedBox(height: 20),
                                      _buildDetail('Contact No',
                                          user1?.svContact ?? '-'),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        //Ex
                        ExpansionTile(
                          title: const Text(
                            'Examiner',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16, // Adjust the font size as needed
                            ),
                          ),
                          children: [
                            FutureBuilder<List<UserData1>>(
                              future: _userDataFutureSvEx,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(0, 146, 143, 10),
                                      ),
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  var user1 = snapshot.data?.isNotEmpty == true
                                      ? snapshot.data![0]
                                      : null;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: _buildDetail(
                                                  'Examiner Name',
                                                  user1?.exName ?? '-')),
                                          //StatusSV
                                          Expanded(
                                            child:
                                                FutureBuilder<List<FinalData>>(
                                              future: _userFinalFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        Color.fromRGBO(
                                                            0, 146, 143, 10),
                                                      ),
                                                    ),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Center(
                                                    child: Text(
                                                        'Error: ${snapshot.error}'),
                                                  );
                                                } else {
                                                  var userF = snapshot.data
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? snapshot.data![0]
                                                      : null;

                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      _buildDetailStatus(
                                                          'Status',
                                                          userF?.statusEX ??
                                                              '-'),
                                                    ],
                                                  );
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      _buildDetail(
                                          'Email', user1?.exEmail ?? '-'),
                                     const SizedBox(height: 20),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
            ),
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
      floatingActionButton: FutureBuilder<List<UserData>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return Container();
          } else if (snapshot.hasError) {
            // Error state
            return Container();
          } else {
            var userS =
                snapshot.data?.isNotEmpty == true ? snapshot.data![0] : null;

            // Check monthly report count
            int monthlyReportsCount = userS?.monthlyReports.length ?? 0;

            return FloatingActionButton(
              onPressed: monthlyReportsCount >= 6
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FinalReportUpload(),
                        ),
                      );
                    }
                  : null,
              backgroundColor: monthlyReportsCount >= 6
                  ? const Color.fromRGBO(0, 146, 143, 0.8)
                  : Colors.grey, // Grey when count is less than 6
              tooltip: 'Add final report',
              child: const Icon(Icons.add_rounded, color: Colors.white),
            );
          }
        },
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

  void showFeedback() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Feedback'),
          content: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<List<FinalData>>(
                  future: _userFinalFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      var userF = snapshot.data?.isNotEmpty == true
                          ? snapshot.data![0]
                          : null;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From Supervisor:\n${userF?.feedbackSV ?? 'No feedback sent yet, please check later. Fighting Internship!'}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'From Examiner:\n${userF?.feedbackEX ?? 'No feedback sent yet, please check later. Fighting Internship!'}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 10)
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
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
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
      },
    );
  }

  Widget _buildDetailStatus(String label, String value) {
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
                  fontSize: 15,
                  color: statusColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow[700]!;
      case 'Approved':
        return Colors.green[700]!;
      case 'Rejected':
        return Colors.red[700]!;
      default:
        return Colors.black87; // Default color
    }
  }

  void _openPdfFile(String fileUrl) async {
    if (fileUrl.isNotEmpty) {
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
}

class UserData {
  final String userId;
  final String matric;
  final String name;
  final List<MonthlyReportS> monthlyReports;

  UserData({
    required this.userId,
    required this.matric,
    required this.name,
    required this.monthlyReports,
  });
}

class FinalData {
  final String userId;
  final String date;
  final String file;
  final String fileName;
  final String title;
  final String status;
  final String statusSV;
  final String feedbackSV;
  final String statusEX;
  final String feedbackEX;

  FinalData({
    required this.userId,
    required this.date,
    required this.file,
    required this.fileName,
    required this.title,
    required this.status,
    required this.statusSV,
    required this.feedbackSV,
    required this.statusEX,
    required this.feedbackEX,
  });
}

class MonthlyReportS {
  final String month;
  final String monthlyRname;
  final String status;
  final String date;
  final String monthlyFile;

  MonthlyReportS({
    required this.month,
    required this.monthlyRname,
    required this.status,
    required this.date,
    required this.monthlyFile,
  });
}

class UserData1 {
  final String userId;
  final String svName;
  final String svEmail;
  final String svContact;
  final String exName;
  final String exEmail;
  final String studentName;

  UserData1({
    required this.userId,
    required this.svName,
    required this.svEmail,
    required this.svContact,
    required this.exName,
    required this.exEmail,
    required this.studentName,
  });
}
