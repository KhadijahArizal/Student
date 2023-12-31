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
  late StatusManagement _statusManagement;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //IAP
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  //Final Report
  late DatabaseReference _finalReport;
  late Future<List<FinalData>> _userFinalFuture;

  //SvEx
  //late DatabaseReference _exRef;
  late DatabaseReference _svRef;
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
      _userFinalFuture = _fetchFinalData();

      //_exRef = FirebaseDatabase.instance.ref('Student').child('Examiner Details');
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

  Future<List<FinalData>> _fetchFinalData() async {
    List<FinalData> userDataList = [];
    try {
      DataSnapshot finalReportSnapshot =
          await _finalReport.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? finalReportData =
          finalReportSnapshot.value as Map<dynamic, dynamic>?;

      if (finalReportData != null) {
        finalReportData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String date = value['Date'] ?? '';
            String file = value['File'] ?? '';
            String fileName = value['File Name'] ?? '';
            String title = value['Report Title'] ?? '';
            String status = value['Status'] ?? '';

            FinalData userF = FinalData(
              userId: userId,
              date: date,
              file: file,
              fileName: fileName,
              title: title,
              status: status,
            );
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

      Map<dynamic, dynamic>? svData =
          svSnapshot.value as Map<dynamic, dynamic>?;

      if (svData != null) {
        svData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String svName = value['Supervisor Name'] ?? '';
            String svContact = value['Contact No'] ?? '';
            String svEmail = value['Email'] ?? '';
            String studentName = value['Student Name'] ?? '';

            UserData1 user1 = UserData1(
              userId: userId,
              svName: svName,
              svContact: svContact,
              svEmail: svEmail,
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
      drawer: sideNav2(studentStatus: _statusManagement.studentStatus),
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
                  //Monthly report
                  FutureBuilder<List<FinalData>>(
                    future: _userFinalFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
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
                                  _buildDetailStatus(
                                      'Status:', userF?.status ?? "-"),
                                ]),
                            const SizedBox(height: 40),
                            _buildDetail('File Name:', userF?.fileName ?? '-'),
                            const SizedBox(height: 40),
                            _buildDetailFile(
                                'Final Report File', userF?.file ?? '-'),
                            const SizedBox(height: 40),
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
                    padding: const EdgeInsets.all(15),
                      child: Column(children: [
                    const Text('Assesment',
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
                                child: CircularProgressIndicator(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetail('Supervisor Name',
                                          user1?.svName ?? '-'),
                                      _buildDetail2('Status', '-'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDetail('Email', user1?.svEmail ?? '-'),
                                  const SizedBox(height: 10),
                                  _buildDetail(
                                      'Contact No', user1?.svContact ?? '-'),
                                  const SizedBox(height: 10),
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
                                child: CircularProgressIndicator(),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildDetail('Examiner Name',
                                          user1?.svName ?? '-'),
                                      _buildDetail2('Status', '-'),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _buildDetail('Email', user1?.svEmail ?? '-'),
                                  const SizedBox(height: 10),
                                  _buildDetail(
                                      'Contact No', user1?.svContact ?? '-'),
                                  const SizedBox(height: 10),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FinalReportUpload(),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(0, 146, 143, 0.8),
        tooltip: 'Add final report',
        child: const Icon(Icons.add_rounded, color: Colors.white),
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

  Widget _buildDetailFile(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 5),
          ],
        ),
        const SizedBox(
            width: 10), // Adjust the spacing between the text and button
        ElevatedButton(
          onPressed: () {
            _openPdfFile(value);
          },
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(0, 146, 143, 10),
          ),
          child: const Text(
            'View',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
      ],
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
            const SizedBox(height: 20)
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow[800]!;
      case 'Submitted':
        return Colors.green[700]!;
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

  UserData({
    required this.userId,
    required this.matric,
    required this.name,
  });
}

class FinalData {
  final String userId;
  final String date;
  final String file;
  final String fileName;
  final String title;
  final String status;

  FinalData({
    required this.userId,
    required this.date,
    required this.file,
    required this.fileName,
    required this.title,
    required this.status,
  });
}

class UserData1 {
  final String userId;
  final String svName;
  final String svEmail;
  final String svContact;
  final String studentName;

  UserData1({
    required this.userId,
    required this.svName,
    required this.svEmail,
    required this.svContact,
    required this.studentName,
  });
}
