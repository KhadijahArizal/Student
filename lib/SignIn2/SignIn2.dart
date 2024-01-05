// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/Service/auth_service.dart';

class SignIn2 extends StatefulWidget {
  const SignIn2({Key? key}) : super(key: key);

  @override
  _SignIn2State createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {
  AuthService authService = AuthService();
  bool isSignedIn = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 25,
          color: Color.fromRGBO(0, 146, 143, 10),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      )),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  'Industrial Attachment Programme Dashboard',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontFamily: 'Futura',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                const Text(
                  'Login to Dashboard',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontFamily: 'Futura',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      // SignIn2 widget
                      onPressed: () async {
                        try {
                          setState(() {
                            _isLoading = true;
                          });

                          User? user = await authService.handleSignin();

                          if (user != null) {
                            // User successfully signed in
                            setState(() {
                              isSignedIn = true;
                              _isLoading = false;
                            });

                            if (await authService.isSignInResultValid(user)) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Summary(),
                                ),
                              );
                            } else {
                              // Handle the case where the sign-in result is not valid
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Google Sign-In failed. Please try again.'),
                                ),
                              );
                            }
                          } else {
                            // User canceled sign-in
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        } catch (e) {
                          // Handle other sign-in errors
                          print('Error signing in: $e');
                          setState(() {
                            _isLoading = false;
                          });

                          // Check if the error message contains information about the popup being closed
                          if (e.toString().contains('popup_closed')) {
                            // Handle the case where the Google Sign-In popup is closed by the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Google Sign-In popup closed. Please try again.'),
                              ),
                            );
                          } else if (e
                              .toString()
                              .contains('your_error_message_or_code')) {
                            // Handle other sign-in errors
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Sign-in failed. Please try again.'),
                              ),
                            );
                          }
                        }
                      },

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
                  if (_isLoading)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(0, 146, 143, 10),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
