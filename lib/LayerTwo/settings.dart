import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/SideNavBar/sideNav2.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required String title}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget _report({required String report}) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(report,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold))
          ],
        ),
      );

  Widget _status({required String status}) => Container(
        child: Column(
          children: [
            Text(
              status,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget _link({required String link}) => Container(
        child: Column(
          children: [
            Text(
              link,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
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
                const Text(
                  'Date',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(submitDate,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            const VerticalDivider(
              color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            size: 25,
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87.withOpacity(0.7),// Use the specified color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
          title: const Text(
            'Settings',
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
          )),
      drawer: sideNav2(studentStatus: '',),
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
                      child: Column(
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
                                            _report(report: '-'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text('Status',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54)),
                                            _status(status: '-'),
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
                                        _status(status: '-'),
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
                                        _status(status: '-'),
                                      ],
                                    ),
                                  ])
                            ]),
                            const Divider(
                              height: 60,
                              thickness: 0.5,
                            ),
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
                                            const Text('Examiner',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                )),
                                            _examiner(
                                                examiner:
                                                    'Salahuddin Bin Jamal'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text('Status',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54)),
                                            _status(status: '-'),
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
                                        const Text('Email',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54)),
                                        _email(
                                            email:
                                                'salahuddin@live.iium.edu.my'),
                                      ],
                                    ),
                                  ])
                            ]),
                            const Divider(
                              thickness: 0.5,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 300,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          color:
                                              Color.fromRGBO(148, 112, 18, 1),
                                        ),
                                        child: const Text(
                                          'Supervisor',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            fontFamily: 'Futura',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ]),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
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
                                                const Text(
                                                  'Supervisor',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                _supervisor(
                                                    supervisor: 'Fatni Mufit'),
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
                                            _email(email: 'fatni@gmail.com'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]))))),
    );
  }
}
