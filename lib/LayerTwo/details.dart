import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/Service/auth_service.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/LayerTwo/Tab/emergency.dart';
import 'package:student/LayerTwo/Tab/student.dart';
import 'Detect Status/statusManagament.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    ));

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  final StatusManagement statusManager = StatusManagement();
  late TabController tabController;
  late StatusManagement _statusManagement;

  Widget _name({required String name}) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  @override
  void initState() {
    _statusManagement = StatusManagement();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    _statusManagement.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Color.fromRGBO(0, 146, 143, 10), // Use the specified color
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/summary');
          },
        ),
        title: const Text(
          'Details',
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
      ),
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
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            border: Border.all(
                                                width: 10,
                                                color: const Color.fromRGBO(
                                                    0, 146, 143, 10)),
                                            color: const Color.fromRGBO(
                                                0, 146, 143, 10)),
                                        child: Column(children: [
                                          Stack(children: [
                                            const SizedBox(height: 10),
                                            Container(
                                              alignment: Alignment.topCenter,
                                              width: 130,
                                              height: 130,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Colors.white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        color: Colors.black
                                                            .withOpacity(0.1))
                                                  ],
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          authService
                                                                  .currentUser
                                                                  ?.photoURL ??
                                                              ''))),
                                            ),
                                          ]),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _name(
                                                          name:
                                                              '${user?.displayName}'),
                                                    ]),
                                              ]),
                                          const SizedBox(height: 10),
                                          DefaultTabController(
                                            length: 2,
                                            child: TabBar(
                                              unselectedLabelColor:
                                                  Colors.white,
                                              labelColor: const Color.fromRGBO(
                                                  0, 146, 143, 10),
                                              indicatorColor: Colors.white,
                                              indicatorWeight: 0.0,
                                              indicatorSize:
                                                  TabBarIndicatorSize.tab,
                                              indicator: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                              ),
                                              controller: tabController,
                                              tabs: const [
                                                Tab(
                                                    icon: Icon(
                                                        Icons.perm_contact_cal),
                                                    text: ' Personal'),
                                                Tab(
                                                  icon: Icon(Icons.emergency),
                                                  text: 'Emergency',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: tabController,
                                          children: const [
                                            Student(),
                                            Emergency(),
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ])),
              ])))),
    );
  }
}
