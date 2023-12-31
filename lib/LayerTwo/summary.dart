// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/LayerTwo/Detect%20Status/statusManagament.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/details.dart';
import 'package:student/Service/auth_service.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:url_launcher/url_launcher.dart';

class Summary extends StatefulWidget {
  const Summary({
    Key? key,
    this.start,
    this.end,
    this.approvedCount,
    this.pendingCount,
    this.rejectedCount,
  }) : super(key: key);

  final String? start, end;
  final int? approvedCount, pendingCount, rejectedCount;

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final statusManager = StatusManagement();
  late StatusManagement _statusManagement;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;
  bool _isVisible = false;
  String _status = '';

  //Iap
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  //Comp
  late DatabaseReference _companyRef;
  late Future<List<CompData>> _userCompFuture;

  //Announc
  late DatabaseReference _announcRef;
  late Future<List<AnnouncData>> _userAnnouncFuture;

  int _currentIndex = 0;
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

  bool _customTileExpanded = false;

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Coordinator'),
                  onTap: () {
                    _sendEmail('coordinator@example.com');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Supervisor'),
                  onTap: () {
                    _sendEmail(
                        'supervisorEmail'); // Use the passed supervisorEmail
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Examiner'),
                  onTap: () {
                    _sendEmail('examiner@example.com');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendEmail(String recipientEmail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': 'Your Subject Here',
        'body': 'Your email body goes here',
      },
    );

    // ignore: deprecated_member_use
    if (await canLaunch(emailLaunchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(emailLaunchUri.toString());
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Unable to launch email app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
    statusManager.statusStream.listen((String status) {
      setState(() {
        _status = status;
        _isVisible = (status == 'Active');
      });
    });
    if (user != null) {
      //Iap
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _userDataFuture = _fetchUserData();

      //Company
      _companyRef =
          FirebaseDatabase.instance.ref('Student').child('Company Details');
      _userCompFuture = _fetchCompData();

      //Announc
      _announcRef =
          FirebaseDatabase.instance.ref('Supervisor').child('Announcements');
      _userAnnouncFuture = _fetchAnnouncData();
    }
  }

  Future<List<AnnouncData>> _fetchAnnouncData() async {
    List<AnnouncData> userDataList = [];
    try {
      DataSnapshot announcSnapshot =
          await _announcRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? announcData =
          announcSnapshot.value as Map<dynamic, dynamic>?;

      if (announcData != null) {
        announcData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            String sender = announcData[key]['Sender'] ?? '';
            String title = announcData[key]['Announcement Title'] ?? '';
            String file = value['File'] ?? '';
            String date = value['Date'] ?? '';
            String info = value['Information'] ?? '';

            AnnouncData userA = AnnouncData(
                sender: sender,
                title: title,
                file: file,
                date: date,
                info: info);
            userDataList.add(userA);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
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
            String sem = value['Semester'] ?? '';

            UserData user = UserData(
              userId: userId,
              email: email,
              matric: matric,
              name: name,
              sem: sem,
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

  Future<List<CompData>> _fetchCompData() async {
    List<CompData> userDataList = [];
    try {
      DataSnapshot companySnapshot =
          await _companyRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? companyData =
          companySnapshot.value as Map<dynamic, dynamic>?;

      if (companyData != null) {
        companyData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String sDate = value['Start Date'] ?? '';
            String eDate = value['End Date'] ?? '';
            String compName = value['Company Name'] ?? '';

            CompData userC = CompData(
              userId: userId,
              sDate: sDate,
              eDate: eDate,
              compName: compName,
            );
            userDataList.add(userC);
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
    //final Future<FirebaseApp> fApp = Firebase.initializeApp();
    int submissionCount = 0;
    AuthService authService = AuthService();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Student Dashboard',
            style: TextStyle(
                color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
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
      drawer: sideNav2(studentStatus: _status),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
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
          child: SingleChildScrollView(
            child: Stack(
              children: [
                /*FutureBuilder(
                    future: fApp,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('ERRORR');
                      } else if (snapshot.hasData) {
                        return const Text('YEAYY');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),*/
                Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Name from IAP
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
                                    const Text(
                                      'Welcome!',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Futura',
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _name(name: user?.name ?? '-'),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),

                          //Photo form google
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _smallRect(
                                profile:
                                    authService.currentUser?.photoURL ?? '',
                                profileTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Details()));
                                },
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    //name, email, sem
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
                              //Name and Matric
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(90),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                      )
                                    ],
                                    border: Border.all(
                                        color: const Color.fromRGBO(
                                            0, 146, 143, 10),
                                        width: 7)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _studentContact(
                                        email: user?.email ?? '-',
                                        matricNo: user?.matric ?? '-')
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),
                              //INFO xxxx registration notes
                              Visibility(
                                  visible: _isVisible,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'INFO 4901 Registration Notes',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 15,
                                                      fontFamily: 'Futura'),
                                                ),
                                                _note(note: user?.sem ?? '-'),
                                              ]),
                                        ]),
                                  )),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    //Company Name
                    FutureBuilder<List<CompData>>(
                      future: _userCompFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          var userC = snapshot.data?.isNotEmpty == true
                              ? snapshot.data![0]
                              : null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                  visible: _isVisible,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Company Name',
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 15,
                                                      fontFamily: 'Futura'),
                                                ),
                                                _cname(
                                                    cname:
                                                        userC?.compName ?? '-'),
                                              ]),
                                        ]),
                                  )),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                      },
                    ),

                    //Monthly Report
                    Visibility(
                        visible: _isVisible,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.grey, blurRadius: 1.0)
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //headline
                                const Text(
                                  'Monthly Report Submission',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Futura',
                                      fontWeight: FontWeight.w900),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                ),
                                StreamBuilder(
                                  stream: FirebaseDatabase.instance
                                      .ref('Student')
                                      .child('Monthly Report')
                                      .child(userId)
                                      .child('SummaryCounts')
                                      .onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // Explicitly cast data to Map<String, dynamic>
                                      final Map<String, dynamic>? data =
                                          (snapshot.data?.snapshot.value
                                              as Map<String, dynamic>?);

                                      // Access counts from snapshot
                                      final int approvedCount =
                                          data?['approved'] ?? 0;
                                      final int pendingCount =
                                          data?['pending'] ?? 0;
                                      final int rejectedCount =
                                          data?['rejected'] ?? 0;

                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Approved',
                                                  style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontSize: 15,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                  approvedCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontSize: 30,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                    color: Colors.yellow[700],
                                                    fontSize: 15,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                  pendingCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.yellow[700],
                                                    fontSize: 30,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Reject',
                                                  style: TextStyle(
                                                    color: Colors.red[700],
                                                    fontSize: 15,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                                Text(
                                                  rejectedCount.toString(),
                                                  style: TextStyle(
                                                    color: Colors.red[700],
                                                    fontSize: 30,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 0.1,
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MonthlyReport(
                                              onCalculateStatus: (int approved,
                                                  int pending, int rejected) {},
                                              weekNumber: submissionCount,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            0, 146, 143, 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                      ),
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.white),
                                      label: const Text(
                                        "New Report",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ]),
                        )),
                    const SizedBox(height: 20),

                    //Announcements
                    FutureBuilder<List<AnnouncData>>(
                      future: _userAnnouncFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          print('Announcement data: ${snapshot.data}');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey, blurRadius: 1.0)
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //headline
                                    const Text(
                                      'Important Annoucements',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Futura',
                                          fontWeight: FontWeight.w900),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 0.1,
                                    ),
                                    for (var announcement in snapshot.data!)
                                      ExpansionTile(
                                        title: Text(announcement.title,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontFamily: 'Futura')),
                                        subtitle: Text(
                                          announcement.sender,
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontFamily: 'Futura'),
                                        ),
                                        trailing: Icon(
                                          _customTileExpanded
                                              ? Icons.arrow_drop_down_circle
                                              : Icons.arrow_drop_down,
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                              title: Text(announcement.info,
                                                  style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 12,
                                                      fontFamily: 'Futura')))
                                        ],
                                        onExpansionChanged: (bool expanded) {
                                          setState(() {
                                            _customTileExpanded = expanded;
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                      },
                    ),

                    //sDate and eDate
                    FutureBuilder<List<CompData>>(
                      future: _userCompFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          var userC = snapshot.data?.isNotEmpty == true
                              ? snapshot.data![0]
                              : null;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                  visible: _isVisible,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(90),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  0, 146, 143, 10))
                                        ],
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                0, 146, 143, 10),
                                            width: 7)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _date(
                                          startDate: userC?.sDate ?? '-',
                                          endDate: userC?.eDate ?? '-',
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 20),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
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
        //studentStatus: _statusManagement.studentStatus,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        backgroundColor: const Color.fromRGBO(0, 146, 143, 0.8),
        child: const Icon(Icons.email, color: Colors.white),
      ),
    );
  }

  Widget _smallRect({
    required String profile,
    required VoidCallback profileTap,
  }) {
    Color? statusColor =
        _status == 'Active' ? Colors.green[700] : Colors.red[700];

    return InkWell(
      onTap: profileTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(profile), // Use NetworkImage for URLs
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Text(
            'Status',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            _status,
            style: TextStyle(
              color: statusColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _name({required String name}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black54, fontSize: 20),
            )
          ],
        ),
      );

  Widget _studentContact({required String matricNo, required String email}) =>
      Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              matricNo,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const VerticalDivider(
              color: Colors.white,
              width: 20,
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      );

  Widget _graphic({required String graphic}) => Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage(graphic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _note({required String note}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              'Registered for $note',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _cname({required String cname}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              cname,
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _date({required String startDate, required String endDate}) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text(
                'Start Date',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(startDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          const VerticalDivider(
            color: Colors.white,
            width: 20,
          ),
          Column(
            children: [
              const Text(
                'End Date',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(endDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

class UserData {
  final String userId;
  final String email;
  final String matric;
  final String name;
  final String sem;

  UserData({
    required this.userId,
    required this.email,
    required this.matric,
    required this.name,
    required this.sem,
  });
}

class CompData {
  final String userId;
  final String sDate;
  final String eDate;
  final String compName;

  CompData({
    required this.userId,
    required this.sDate,
    required this.eDate,
    required this.compName,
  });
}

class AnnouncData {
  final String sender, title, file, date, info;

  AnnouncData(
      {required this.sender,
      required this.title,
      required this.file,
      required this.date,
      required this.info});
}
