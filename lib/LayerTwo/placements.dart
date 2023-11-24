import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/LayerTwo/Tab/company.dart';
import 'package:student/LayerTwo/Tab/supervisor.dart';
import 'Detect Status/statusManagament.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    ));

class Placements extends StatefulWidget {
  final String companyName;
  final String companyAddress;
  final String companyPostcode;
  final String monthlyAllowance;

  const Placements({
    Key? key,
    required String title,
    required this.companyName,
    required this.companyAddress,
    required this.companyPostcode,
    required this.monthlyAllowance,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlacementsState createState() => _PlacementsState();
}

class _PlacementsState extends State<Placements>
    with SingleTickerProviderStateMixin {
  final StatusManagement statusManager = StatusManagement();
  late TabController tabController;

  Widget _cname({required String cname}) => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              cname,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: 'Futura'),
            )
          ],
        ),
      );

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

  final TextEditingController _supervisor = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();

  int _currentIndex = 4;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
          title: const Text(
            'Placements',
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
          ), leading: Builder(
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
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Company Name',
                                                    style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 13,
                                                        fontFamily: 'Futura',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  _cname(
                                                      cname: _email
                                                          .text), //COBA-COBA
                                                ]),
                                          ),
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
                                                    icon: Icon(Icons.domain),
                                                    text: ' Company'),
                                                Tab(
                                                  icon: Icon(Icons.person),
                                                  text: 'Supervisor',
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
                                            Company(),
                                            Supervisor(
                                                supervisor: _supervisor.text,
                                                email: _email.text,
                                                contact: _contact.text)
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
