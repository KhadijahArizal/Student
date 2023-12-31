import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
//import 'package:provider/provider.dart';

class AdminReviewPage extends StatefulWidget {
  const AdminReviewPage({
    super.key,
    required this.name,
    required this.email,
    required this.matric,
  });
  final String name;
  final String email;
  final String matric;

  @override
  _AdminReviewPageState createState() => _AdminReviewPageState();
}

class _AdminReviewPageState extends State<AdminReviewPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController matric = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    email.text = widget.email;
    matric.text = widget.matric;
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var studentData = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Review Page',
            style: TextStyle(
                color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.download_rounded,
                      size: 110,
                      color: Colors.green[800],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Text(
                      'Thank You!',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 146, 143, 10),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Futura',
                      ),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                      child: Text(
                        'your application has been SUBMITTED and PENDING for approval by IAP Coordinator. Check your EMAIL for any update and status of your IAP Application.',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: 
                    Consumer<Data>(builder: (context, Data, child) {
          return Column(children: [
                      Text(studentData.iapname.text,
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 146, 143, 10),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          )),
                      Text(
                          studentData.matric.text, //'Matric: ${userData['matric'] ?? '-'}',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 146, 143, 10),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          )),
                      Text('${user?.email}',
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 146, 143, 10),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          ))
                    ]);}),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/summary');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
              ),
              child: const Text(
                'Check your status here',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Futura',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
