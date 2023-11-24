import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/SideNavBar/sideNav1.dart';

class Announcement extends StatefulWidget {
  const Announcement({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AnnouncementState createState() => _AnnouncementState();
}

final ExpansionTileController controller = ExpansionTileController();

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData(
                color: Color.fromRGBO(148, 112, 18, 1), size: 30),
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
        drawer: sideNav1(),
        body: SafeArea(
            child: Column(children: [
          Expanded(
            // Use Expanded to make the background full height
            child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
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
                    child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Container(
                                        width: double.infinity,
                                        height: 35,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromRGBO(148, 112, 18, 1),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                        ),
                                        child: const Text('Announcements',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontFamily: 'Futura'),
                                            textAlign: TextAlign.center))),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, left: 20, right: 20),
                                  child: RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 15,
                                              fontFamily: 'Futura'),
                                          children: [
                                        const TextSpan(
                                          text:
                                              'For BIT and BCS students, who are planning to go for Industrial Attachment Programme (IAP), you need to fill in ',
                                        ),
                                        const TextSpan(
                                            text: 'IAP Application ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: 'a semester or 1 semester ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[800])),
                                        const TextSpan(
                                          text:
                                              'before the start of your IAP. Failing to submit the IAP Application, may restrict your access to IAP dashboard. Click ',
                                        ),
                                        const TextSpan(
                                            text: '"IAP Application" ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const TextSpan(
                                          text:
                                              'tab to fill in your application.',
                                        ),
                                      ])),
                                ),
                              ])),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: <Widget>[
                        const Text('Quick Reminders',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Futura'),
                            textAlign: TextAlign.center),
                        const SizedBox(
                          height: 10,
                        ),
                        ExpansionTile(
                            title: const Text(
                              '1. Start Date',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text: 'IAP ',
                                      ),
                                      const TextSpan(
                                          text: 'Start Date ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: 'must be within the '),
                                      const TextSpan(
                                          text: 'FIRST 3 WEEKS ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text:
                                              'of every semester. Any IAP starts before that will '),
                                      TextSpan(
                                          text: 'NOT ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[800])),
                                      const TextSpan(text: 'count as '),
                                      const TextSpan(
                                          text: '6 MONTHS ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(text: 'duration.'),
                                    ])),
                              ),
                            ]),
                        ExpansionTile(
                            title: const Text(
                              '2. IAP Dashboard Instructions',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      TextSpan(
                                        text:
                                            'Any questions pertaining to IAP contact your respective coordinator. Read the given ',
                                      ),
                                      TextSpan(
                                          text: 'FAQ ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              'on your IAP Dashboard for the detailed instructions of the workflow.'),
                                    ])),
                              ),
                            ]),
                        const ExpansionTile(
                            title: Text(
                              '3. IAP Rules & Regulations',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 10, right: 10),
                                  child: Text(
                                      'Take note of the policies and guidelines before proceeding with internship placement',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontFamily: 'Futura'),
                                      textAlign: TextAlign.start)),
                            ]),
                        ExpansionTile(
                            title: const Text(
                              '4. Insurance & Letter of Indemnity',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text:
                                            'For issuance of Insurance Coverage Letter, email to ',
                                      ),
                                      TextSpan(
                                          text: 'etiqaagency.iium@gmail.com. ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800])),
                                      const TextSpan(
                                          text:
                                              'The department will only issue letter of indemnity (if requested by the company).'),
                                    ])),
                              ),
                            ]),
                        ExpansionTile(
                            title: const Text(
                              '5. IAP Placement',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text:
                                            'Plenty Internship positions available on ',
                                      ),
                                      TextSpan(
                                          text: 'JobStreet Campus Web Page. ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800])),
                                      const TextSpan(
                                          text:
                                              'Choose a company based on location, which is convenient and accessible by public transport.'),
                                    ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text:
                                            'You can also refer to the collection of companies included on your IAP Dashboard. Take note of the status and ',
                                      ),
                                      TextSpan(
                                          text: 'DO NOT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800])),
                                      const TextSpan(
                                          text:
                                              'DO NOT apply any company with a '),
                                      TextSpan(
                                          text: 'Blacklisted ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[800])),
                                      const TextSpan(text: 'status.'),
                                    ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontFamily: 'Futura'),
                                        children: [
                                      const TextSpan(
                                        text:
                                            'Before accepting any offer from the company, read the company reviews on ',
                                      ),
                                      TextSpan(
                                          text: 'JobStreet Campus Web Page. ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo[800])),
                                      const TextSpan(
                                          text: 'or Google Reviews.'),
                                    ])),
                              ),
                            ]),
                        const ExpansionTile(
                            title: Text(
                              '6. IAP Dashboard Instructions',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Futura'),
                            ),
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 20, left: 10, right: 10),
                                  child: Text(
                                      'Any questions pertaining to IAP contact your respective coordinator. Read the given FAQ on your IAP Dashboard for the detailed instructions of the workflow',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontFamily: 'Futura'),
                                      textAlign: TextAlign.start)),
                            ])
                      ],
                    ),
                  ],
                ))),
          ),
        ])));
  }
}
