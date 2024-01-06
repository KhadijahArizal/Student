// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/Service/auth_service.dart';
import 'package:student/layerOne/start.dart';

//DASH LOGIN
class SignIn2 extends StatefulWidget {
  const SignIn2({Key? key}) : super(key: key);

  @override
  _SignIn2State createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  AuthService authService = AuthService();
  bool _isLoadingDataCheck = false;
  bool isSignedIn = false;
  bool _isLoading = false;
  late DatabaseReference _iapFormRef;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text(
            'Supervisor Dashboard',
            style: TextStyle(
                color: Colors.black38, fontSize: 15, fontFamily: 'Futura'),
            textAlign: TextAlign.right,
          )
        ]),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 25,
            color: Color.fromRGBO(0, 146, 143, 10),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/auth');
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(40),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    padding: const EdgeInsets.all(70),
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
                    'Industrial Attachment Programme Supervisor Dashboard',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'Futura',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(10),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Sign In with Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Futura',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isLoading) const CircularProgressIndicator()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignIn() async {
  try {
    setState(() {
      _isLoading = true;
    });

    User? user = await authService.handleSignIn();
    print('User ID: ${user?.uid}');

    if (user != null) {
      setState(() {
        isSignedIn = true;
        _isLoading = false;
      });
      await Future.delayed(const Duration(seconds: 2));

      if (await authService.isSignInResultValid(user)) {
        _checkUserId();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Sign-In failed. Please try again.'),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  } catch (e) {
    print('Error signing in: $e');
    setState(() {
      _isLoading = false;
    });

    if (e.toString().contains('popup_closed')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google Sign-In popup closed. Please try again.'),
        ),
      );
    } else if (e.toString().contains('your_error_message_or_code')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign-in failed. Please try again.'),
        ),
      );
    }
  }
}

Future<void> _checkUserId() async {
  try {
    setState(() {
      _isLoadingDataCheck = true;
    });
    print('Checking data');
    DataSnapshot iapSnapshot =
        await _iapFormRef.once().then((event) => event.snapshot);
    print('After fetching data');

    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('User ID for data check: $userId');

    Map<dynamic, dynamic>? iapData =
        iapSnapshot.value as Map<dynamic, dynamic>?;

    if (iapData != null && iapData.containsKey(userId)) {
      // If the user ID exists in the IAP data
      print('User ID exists in IAP data. Navigating to Summary.');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Summary()),
      );
    } else {
      // If the user ID does not exist in the IAP data
      print('User ID does not exist in IAP data. Showing registration alert.');
      _showRegistrationAlert(context);
    }
  } catch (e) {
    print('Error fetching data: $e');
    _showRegistrationAlert(context);
  }finally {
    setState(() {
      _isLoadingDataCheck = false;
    });
  }
}

  void _showRegistrationAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User not found'),
          content: const Text('Please register for the IAP.'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Sign out the user
                await authService.handleSignOut();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Start()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class User1 {
  final String userId;

  User1({
    required this.userId,
  });
}
