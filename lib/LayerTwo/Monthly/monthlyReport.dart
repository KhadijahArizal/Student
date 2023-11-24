import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/Monthly/thisCreate.dart';
import 'package:student/LayerTwo/Monthly/weeklyTask.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import '../Detect Status/statusManagament.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key, required this.title});
  final String title;

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  final StatusManagement statusManager = StatusManagement();

  Widget _examiner({required String examiner}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              examiner,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

  Widget _email({required String email}) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              email,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      );

  Widget _zone({required String zone}) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              zone,
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  int _currentIndex = 1;

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

  List<ThisCreate> monthlyR = [];

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
          )),
      drawer: sideNav2(studentStatus: statusManager.studentStatus),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Column(children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Examiner Name',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54)),
                                          _examiner(
                                              examiner:
                                                  'Dr. Salahuddin Bin Jamal'),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Email',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54)),
                                          _email(
                                              email:
                                                  'salahuddin@live.iium.edu.my'),
                                        ],
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Evaluation Zone',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54)),
                                          _zone(zone: 'A'),
                                        ],
                                      ),
                                    ],
                                  )),
                            ]),
                        const Divider(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: DataTable(
                              dataRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.white12),
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      const Color.fromRGBO(148, 112, 18, 2)),
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Created Date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Month',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Submission Date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Approval Date',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              rows: const [
                                DataRow(
                                  cells: [
                                    //'${monthlyR[index].info}'
                                    DataCell(Text('1')),
                                    DataCell(Text('2023-11-01')),
                                    DataCell(Text('November')),
                                    DataCell(Text('2023-11-05')),
                                    DataCell(Text('Approved')),
                                    DataCell(Text('2023-11-10')),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(Text('2')),
                                    DataCell(Text('2023-10-01')),
                                    DataCell(Text('October')),
                                    DataCell(Text('2023-10-05')),
                                    DataCell(Text('Pending')),
                                    DataCell(Text('N/A')),
                                  ],
                                ),
                                // Add more rows as needed
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WeeklyTask(
                                      title: 'Weekly Task',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(148, 112, 18, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      100), // Set the border radius to 100
                                ),
                              ),
                              icon: const Icon(Icons
                                  .add_circle), // Icon data for elevated button
                              label: const Text("New Report"), // Label text
                            )),
                        const SizedBox(height: 30),
                      ]))))),
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
    );
  }

  void send() {
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
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.download_done_rounded,
                      size: 110,
                      color: Colors.green[800], //<-- SEE HERE
                    )),
                const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Text(
                      'Thank You',
                      style: TextStyle(
                          color: Color.fromRGBO(148, 112, 18, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Futura'),
                    )),
                const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Text(
                      'your request has been send successfully!',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontFamily: 'Futura'),
                    )),
              ],
            ),
          ),
          actions: [
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                    ),
                    child: const Text(
                      'Ok',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Futura'),
                    ))),
            const SizedBox(height: 10)
          ],
        );
      },
    );
  }
}
