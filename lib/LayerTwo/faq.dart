import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class FAQ extends StatefulWidget {
  const FAQ({Key? key, required String title}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
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
              'FAQ',
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
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Column(children: [
              ExpansionTile(
                  title: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Color.fromRGBO(148, 112, 18, 1))
                          ],
                          border: Border.all(
                              color: const Color.fromRGBO(148, 112, 18, 1),
                              width: 7)),
                      child: const Text(
                        'Industrial Attachment Programme Cover Letter',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura'),
                            textAlign: TextAlign.start,
                      )),
                  children: <Widget>[
                     Padding( 
                      padding: const EdgeInsets.all(10),
                      child:RichText(
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'must be within the '),
                          const TextSpan(
                              text: 'FIRST 3 WEEKS ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'duration.'),
                        ]))),
                  ]),

                  ExpansionTile(
                  title: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Color.fromRGBO(148, 112, 18, 1))
                          ],
                          border: Border.all(
                              color: const Color.fromRGBO(148, 112, 18, 1),
                              width: 7)),
                      child: const Text(
                        'Industrial Attachment Programme List of Company',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura'),
                            textAlign: TextAlign.start,
                      )),
                  children: <Widget>[
                     Padding( 
                      padding: const EdgeInsets.all(10),
                      child:RichText(
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'must be within the '),
                          const TextSpan(
                              text: 'FIRST 3 WEEKS ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'duration.'),
                        ]))),
                  ]),

                  ExpansionTile(
                  title: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Color.fromRGBO(148, 112, 18, 1))
                          ],
                          border: Border.all(
                              color: const Color.fromRGBO(148, 112, 18, 1),
                              width: 7)),
                      child: const Text(
                        'Placements Verifications',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura'),
                            textAlign: TextAlign.start,
                      )),
                  children: <Widget>[
                     Padding( 
                      padding: const EdgeInsets.all(10),
                      child:RichText(
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'must be within the '),
                          const TextSpan(
                              text: 'FIRST 3 WEEKS ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: 'duration.'),
                        ]))),
                  ]),
            
          ]),
        )));
  }
}
