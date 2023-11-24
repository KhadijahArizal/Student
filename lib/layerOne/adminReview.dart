import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    //Map<String, dynamic> userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
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
          color: Color.fromRGBO(148, 112, 18, 1),
          size: 30,
        ),
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
                        color: Color.fromRGBO(148, 112, 18, 1),
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
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: Column(children: [
                      Text(name.text,
                          style: const TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          )),
                      Text(
                          matric.text, //'Matric: ${userData['matric'] ?? '-'}',
                          style: const TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          )),
                      Text(email.text,
                          style: const TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Futura',
                          ))
                    ]),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signIn');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
              ),
              child: const Text(
                'Sign In',
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
