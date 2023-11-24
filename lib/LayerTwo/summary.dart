import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/LayerTwo/Detect%20Status/statusManagament.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/SideNavBar/sideNav2.dart';

class Summary extends StatefulWidget {
  const Summary({
    super.key,
    required this.name,
    required this.email,
    required this.matric,
  });
  final String name;
  final String email;
  final String matric;

  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  final statusManager = StatusManagement();
  bool _isVisible = false;
  String _status = '';

  Widget _smallRect({required String profile}) {
    Color? statusColor =
        _status == 'Active' ? Colors.green[700] : Colors.red[700];

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(profile),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Text(
            'Status',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Text(
            _status, // Use the updated status here
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

  Widget _examiner({required String examiner}) => Container(
        alignment: Alignment.topLeft,
        child: Visibility(
          visible: _isVisible,
          child: Column(
            children: [
              Text(
                examiner,
                style: const TextStyle(color: Colors.black87, fontSize: 16),
              )
            ],
          ),
        ),
      );

  Widget _company({required String company}) => Container(
        alignment: Alignment.topRight,
        child: Visibility(
          visible: _isVisible,
          child: Column(
            children: [
              Text(
                company,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
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
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

  Widget _date({required String sdate, eDate}) {
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
              Text(sdate,
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
              Text(eDate,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1) {
        Navigator.pushNamed(context, '/monthly_report');
      } else if (index == 2) {
        Navigator.pushNamed(context, '/final_report');
      } else if (index == 3) {
        Navigator.pushNamed(context, '/details');
      } else if (index == 4) {
        Navigator.pushNamed(context, '/placements');
      }
    });
  }

  bool _customTileExpanded = false;

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Supervisor'),
                onTap: () {
                  // Add logic to email supervisor here
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Coordinator'),
                onTap: () {
                  // Add logic to email coordinator here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController matric = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    email.text = widget.email;
    matric.text = widget.matric;

    statusManager.statusStream.listen((String status) {
      setState(() {
        _status = status;
        _isVisible = (status == 'Active');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          color: Color.fromRGBO(148, 112, 18, 1),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(148, 112, 18, 1), size: 30),
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
                Column(
                  children: [
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome!',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: 'Futura'),
                                  ),
                                  _name(
                                      name: name.text), //${widget.userData['name']}}
                                ]),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _smallRect(
                                  profile: 'assets/profile.jpg',
                                ),
                              ],
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            boxShadow: const [
                              BoxShadow(color: Color.fromRGBO(148, 112, 18, 1))
                            ],
                            border: Border.all(
                                color: const Color.fromRGBO(148, 112, 18, 1),
                                width: 7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _studentContact(
                                email: email.text,
                                matricNo: matric.text),
                          ],
                        ),
                      ),
                      //INFO xxxx registration notes
                      Visibility(
                          visible: _isVisible,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
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
                                        _note(note: '/*SEMESTER CHOOSEN*/'),
                                      ]),
                                ]),
                          )),

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
                                  //GRAPHIC HERE
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _graphic(
                                              graphic: 'assets/profile.jpg'),
                                        ]),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    thickness: 0.1,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('Approved',
                                                  style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontSize: 15,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900)),
                                              Text('-',
                                                  style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontSize: 30,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('Pending',
                                                  style: TextStyle(
                                                      color: Colors.yellow[700],
                                                      fontSize: 15,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900)),
                                              Text('-',
                                                  style: TextStyle(
                                                      color: Colors.yellow[700],
                                                      fontSize: 30,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('Reject',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 15,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900)),
                                              Text('-',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 30,
                                                      fontFamily: 'Futura',
                                                      fontWeight:
                                                          FontWeight.w900))
                                            ],
                                          ),
                                        ],
                                      )),
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
                                              builder: (context) =>
                                                  const MonthlyReport(
                                                title: 'Monthly Report',
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              148, 112, 18, 1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                100), // Set the border radius to 100
                                          ),
                                        ),
                                        icon: const Icon(Icons
                                            .add_circle), // Icon data for elevated button
                                        label: const Text(
                                            "New Report"), // Label text
                                      )),
                                ]),
                          )),

                      const SizedBox(height: 20),
                      Container(
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
                            ExpansionTile(
                              title: const Text('INFO 4901 Registration Notes',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontFamily: 'Futura')),
                              subtitle: const Text(
                                'Dr.Ameera Binti Huseein',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontFamily: 'Futura'),
                              ),
                              trailing: Icon(
                                _customTileExpanded
                                    ? Icons.arrow_drop_down_circle
                                    : Icons.arrow_drop_down,
                              ),
                              children: const <Widget>[
                                ListTile(
                                    title: Text(
                                        'Dear Student, please do Pre-Reg INFO 4901 course by TODAY! Thank you',
                                        style: TextStyle(
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
                      Visibility(
                          visible: _isVisible,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(148, 112, 18, 1))
                                ],
                                border: Border.all(
                                    color:
                                        const Color.fromRGBO(148, 112, 18, 1),
                                    width: 7)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _date(sdate: '7/12/23', eDate: '7/6/24'),
                              ],
                            ),
                          )),
                      const SizedBox(height: 20),
                    ]),
                  ],
                ),
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
          'Details': '/details',
          'Placements': '/placements',
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        backgroundColor: const Color.fromRGBO(148, 112, 18, 0.8),
        child: const Icon(Icons.email),
      ),
    );
  }
}
