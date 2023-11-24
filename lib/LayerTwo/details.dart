import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/LayerTwo/Tab/emergency.dart';
import 'package:student/LayerTwo/Tab/student.dart';
import 'package:country_flags/country_flags.dart';
import 'Detect Status/statusManagament.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    ));

class Details extends StatefulWidget {
  const Details({Key? key, required String title}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> with SingleTickerProviderStateMixin {
  final StatusManagement statusManager = StatusManagement();

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

  String name = '';
  String relationship = '';
  String econtact = '';
  String address = '';
  late TabController tabController;

  int _currentIndex = 3;

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

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
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
        ),),
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
                                                    148, 112, 18, 1)),
                                            color: const Color.fromRGBO(
                                                148, 112, 18, 1)),
                                        child: Column(children: [
                                          Stack(children: [
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
                                                  image: const DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                          'assets/profile.jpg'))),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 4,
                                                          color: Colors.white),
                                                      color:
                                                          const Color.fromRGBO(
                                                              148,
                                                              112,
                                                              18,
                                                              10)),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                ))
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
                                                CountryFlags.flag(
                                                  'id',
                                                  height: 30,
                                                  width: 50,
                                                  borderRadius: 8,
                                                ),
                                                const VerticalDivider(
                                                  color: Colors.black87,
                                                ),
                                                _name(name: 'Zahra Fathanah'),
                                              ]),
                                          const SizedBox(height: 10),
                                          const Divider(
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 5),
                                          DefaultTabController(
                                            length: 2,
                                            child: TabBar(
                                              unselectedLabelColor:
                                                  Colors.white,
                                              labelColor: const Color.fromRGBO(
                                                  148, 112, 18, 1),
                                              indicatorColor: Colors.white,
                                              indicatorWeight: 2,
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
                                          children: [
                                            //PERSONAL
                                            Student(
                                              address: '',
                                              ic: '',
                                              name: '',
                                              phone: '',
                                              major: '',
                                            ),
                                            /*SingleChildScrollView(
                                                  child: Container(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              40),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: const [
                                                                    Text(
                                                                        'Major'),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: const [
                                                                    Text(
                                                                        'IC/Passport No'),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 50),
                                                            const Text(
                                                                'Phone No'),
                                                            const SizedBox(
                                                                height: 50),
                                                            const Text('Email'),
                                                            const SizedBox(
                                                                height: 50),
                                                            const Text(
                                                                'Current Address'),
                                                            const SizedBox(
                                                                height: 70),
                                                            Container(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const studentForm()));
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color.fromRGBO(
                                                                            148,
                                                                            112,
                                                                            18,
                                                                            1),
                                                                  ),
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .edit), //icon data for elevated button
                                                                  label: const Text(
                                                                      "Edit"), //label text
                                                                ))
                                                          ]))),*/
                                            //EMERGENCY
                                            Emergency(
                                              name:
                                                  name, // Pass the 'name' collected in EmergencyForm
                                              relationship:
                                                  relationship, // Pass the 'relationship' collected in EmergencyForm
                                              address:
                                                  address, // Pass the 'address' collected in EmergencyForm
                                              econtact:
                                                  econtact, // Pass the 'econtact' collected in EmergencyForm
                                            )
                                          ],
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        ])),
              ])))),
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
}
