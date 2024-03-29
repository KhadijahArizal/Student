// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/SignIn/SignIn.dart';
import 'package:student/SignIn2/SignIn2.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  bool isLoginLoading = false;
  bool isRegistrationLoading = false;
  TextEditingController matricNoController = TextEditingController();
  late DatabaseReference _iapFormRef;

  @override
  void initState() {
    super.initState();
    _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.all(80),
                    decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('assets/iium.png')),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'I-KICT',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 146, 143, 10),
                      fontSize: 60,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Industrial Attachment Programme Student Dashboard',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Futura',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: TextButton(
                      onPressed: isRegistrationLoading
                          ? null
                          : () async {
                              setState(() {
                                isRegistrationLoading = true;
                              });

                              // Simulate a time-consuming task (e.g., network call)
                              await Future.delayed(const Duration(seconds: 2));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignIn(),
                                ),
                              );
                              setState(() {
                                isRegistrationLoading = false;
                              });
                            },
                      child: isRegistrationLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(0, 146, 143, 10),
                              ),
                            )
                          : const Text(
                              'IAP Application Registration',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 146, 143, 10),
                                fontSize: 20,
                                fontFamily: 'Futura',
                              ),
                            ),
                    ),
                  ),
                  const Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                      fontFamily: 'Futura',
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoginLoading
                          ? null
                          : () async {
                              setState(() {
                                isLoginLoading = true;
                              });

                              await Future.delayed(const Duration(seconds: 2));

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignIn2(),
                                ),
                              );

                              setState(() {
                                isLoginLoading = false;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: isLoginLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              'Login to Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Futura',
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
