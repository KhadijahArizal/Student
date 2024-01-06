import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/layerOne/start.dart';

class AuthPage2 extends StatelessWidget {
  const AuthPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(0, 146, 143, 10),
                              ),
                            ),
              );
            }
            if (snapshot.hasData) {
              return const Summary();
            } else {
              return const Start();
            }
          }),
    );
  }
}
