// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/examiner.dart';
import 'package:student/LayerTwo/Tab/company.dart';
import 'package:student/LayerTwo/Tab/supervisor.dart';
import 'Detect Status/statusManagament.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    ));

class Placements extends StatefulWidget {
  const Placements({
    Key? key,
    required String title,
    required this.companyName,
  }) : super(key: key);

  final String companyName;

  @override
  // ignore: library_private_types_in_public_api
  _PlacementsState createState() => _PlacementsState();

  void onOfferLetterSelected(String? offerLetter) {
    if (offerLetter != null) {
      openOfferLetter(offerLetter);
    }
  }

  void openOfferLetter(String offerLetter) async {
    try {
      await OpenFilex.open(offerLetter);
    } catch (e) {
      print('Error opening offer letter: $e');
      // Handle the error, e.g., show an error message to the user
    }
  }
}

class _PlacementsState extends State<Placements>
    with SingleTickerProviderStateMixin {
  final StatusManagement statusManager = StatusManagement();
  late TabController tabController;
  late StatusManagement _statusManagement;
  var examinerInstance;

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
    super.initState();
    _statusManagement = StatusManagement();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChangeWithoutArgument);
  }

  @override
  void dispose() {
    _statusManagement.dispose();
    tabController.removeListener(_handleTabChangeWithoutArgument);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    examinerInstance = Examiner(
      examiner: studentData.exname.text,
      email: studentData.exemail.text,
      contact: studentData.excontact.text,
      handleTabChange: _handleTabChangeWithoutArgument, studentData: studentData,
    );
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 25,
                color:
                    Color.fromRGBO(0, 146, 143, 10), // Use the specified color
              ),
          onPressed: () {
            Navigator.pushNamed(context, '/summary');
          },
        ),
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
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
      ),
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
                    child: Consumer<Data>(builder: (context, studentData, child) {
                      return Column(
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
                                                        cname: studentData
                                                            .company.text),
                                                  ]),
                                            ),
                                            const SizedBox(height: 5),
                                            DefaultTabController(
                                              length: 3,
                                              child: TabBar(
                                                unselectedLabelColor:
                                                    Colors.white,
                                                labelColor:
                                                    const Color.fromRGBO(
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
                                                      icon: Icon(Icons.domain),
                                                      text: ' Company'),
                                                  Tab(
                                                    icon: Icon(Icons.person),
                                                    text: 'Supervisor',
                                                  ),
                                                  Tab(
                                                    icon: Icon(Icons.person),
                                                    text: 'Examiner',
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
                                              Company(onOfferLetterSelected: widget.onOfferLetterSelected),
                                              const Supervisor(),
                                              Examiner(
                                                handleTabChange: () {}, studentData: studentData,
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ]);
                    })),
              ])))),
    );
  }

  void _handleTabChange(Data studentData) {
    if (tabController.index == 2) {
      examinerInstance.updateDatabase(studentData: studentData);
    }
  }

  void _handleTabChangeWithoutArgument() {
  _handleTabChange(Provider.of<Data>(context));
}

 
}
