import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/LayerTwo/FA/finalReportUpload.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import '../Detect Status/statusManagament.dart';

class FinalReport extends StatefulWidget {
  const FinalReport({
    super.key,
    this.title,
    this.drive,
    this.date,
    this.fileName,
    this.status,
    this.supervisor,
    this.supervisorEmail,
  });

  final String? title,
      drive,
      date,
      fileName,
      status,
      supervisor,
      supervisorEmail;

  @override
  _FinalReportState createState() => _FinalReportState();
}

class _FinalReportState extends State<FinalReport> {
  final StatusManagement statusManager = StatusManagement();
  late StatusManagement _statusManagement;

  Widget _report({required String report}) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(report,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontFamily: 'Futura',
                ))
          ],
        ),
      );

  Widget _status({required String status}) {
    return Column(
      children: [
        Text(
          status,
          style:
              TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _file({required String file}) => Container(
        child: Column(
          children: [
            Text(
              file,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontFamily: 'Futura',
              ),
            )
          ],
        ),
      );

  Widget _date({required String submitDate}) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(submitDate,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16)),
              ],
            ),
            const VerticalDivider(
              color: Colors.black,
              thickness: 2,
              width: 200,
            ),
          ],
        ),
      );

  Widget _supervisor({required String supervisor}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              supervisor,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

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
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context); 
    studentData.deadlineDate = DateTime(2023, 12, 31); //SET DEADLINE
    bool isEditAllowed =
        DateTime.now().isBefore(studentData.deadlineDate ?? DateTime(2100));

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
          title: const Text(
            'Final Report',
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
                      child: Consumer<Data>(
                          builder: (context, reportsProvider, child) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text('Report Title',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  )),
                                              _report(
                                                  report:
                                                      studentData.title.text),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text('Status',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54)),
                                              _status(
                                                  status: reportsProvider
                                                      .statusFinal.text),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                                const SizedBox(height: 20),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('File',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                          _file(
                                              file: reportsProvider
                                                  .finalReportName.text)
                                        ],
                                      ),
                                    ]),
                                const SizedBox(height: 20),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Date',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                          _date(
                                              submitDate: reportsProvider
                                                  .dateinput.text),
                                        ],
                                      ),
                                    ])
                              ]),
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                thickness: 0.5,
                              ),

                              //Examiner
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Examiner',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Futura',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey[50],
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius:
                                                  2, // Adjust the blur radius as needed
                                            )
                                          ],
                                          border: Border.all(
                                              color: Colors.white, width: 7)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Examiner',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      _examiner(examiner: '-'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                        'Status',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      _status(status: '-'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Email',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  _email(
                                                      email: 'fatni@gmail.com'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),

                              //Supervisor
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Supervisor',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Futura',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[50],
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius:
                                                2, // Adjust the blur radius as needed
                                          )
                                        ],
                                        border: Border.all(
                                            color: Colors.white, width: 7),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Supervisor',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      _supervisor(
                                                          supervisor:
                                                              studentData
                                                                  .svname.text),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      const Text(
                                                        'Status',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      _status(status: '-'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Email',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  _email(
                                                      email: studentData
                                                          .svemail.text),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height:100),
                                ],
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: isEditAllowed
                                          ? () async {
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FinalReportUpload(),
                                                ),
                                              );
                                            }
                                          : null, // Disable button if editing is not allowed
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color.fromRGBO(
                                                0, 146, 143, 10),
                                        minimumSize:
                                            const Size.fromHeight(50),
                                      ),
                                      child: const Text(
                                        'Add Final Report',
                                        style:
                                            TextStyle(color: Colors.white),
                                      ),
                                    ))
                                  ]),
                            ]);
                      }))))),
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
    );
  }
}
