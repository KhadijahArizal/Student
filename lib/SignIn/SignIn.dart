import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/Service/auth_service.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService authService = AuthService();
  bool isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Colors.white30.withOpacity(0.2), BlendMode.dstATop),
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
                            image: DecorationImage(
                                image: AssetImage('assets/iium.png')),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'I-KICT',
                          style: TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
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
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  // Use renderButton instead of signIn
                                  await authService.handleSignin();

                                  // Update the state to indicate that the user has signed in
                                  setState(() {
                                    isSignedIn = true;
                                  });

                                  // Print the message when signed in
                                  if (isSignedIn) {
                                    print('YEAYYY! Sign In!');
                                    
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Summary(
                                          dmatric: '',
                                          start: '',
                                          end: '',
                                          approvedCount: 0,
                                          pendingCount: 0,
                                          rejectedCount: 0,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  // Handle sign-in errors
                                  print('Error signing in: $e');
                                  // You can show a snackbar or any UI indication of the error here
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(148, 112, 18, 1),
                              ),
                              child: const Text(
                                'Sign In with Google',
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'Futura'),
                              ),
                            )
                          ],
                        )
                      ]),
                ],
              )),
        ));
  }
}
