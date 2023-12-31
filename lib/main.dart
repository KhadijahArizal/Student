// ignore_for_file: must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/details.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/help.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/LayerTwo/FA/finalReport.dart';
import 'package:student/SignIn/SignIn.dart';
import 'package:student/SignIn/auth.dart';
import 'package:student/layerOne/adminReview.dart';
import 'package:student/layerOne/iapForm.dart';
import 'package:student/layerOne/logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDW17txVZK6rztMZDkUbxdKm2dPg1RysCI",
          authDomain: "ikict-f49f6.firebaseapp.com",
          databaseURL: "https://ikict-f49f6-default-rtdb.firebaseio.com",
          projectId: "ikict-f49f6",
          storageBucket: "ikict-f49f6.appspot.com",
          messagingSenderId: "753383357173",
          appId: "1:753383357173:web:cb41d4980a59f94e9fe3bc",
          measurementId: "G-VZHRYCDNRT"));
//await getApplicationDocumentsDirectory();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Data()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  int submissionCount = 0;

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKICT | Student',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 146, 143, 10),
        fontFamily: 'Futura',
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/splash': (context) => SplashScreen(),
        '/signIn': (context) => const SignIn(),
        '/adminreview': (context) => const AdminReviewPage(
              name: '',
              email: '',
              matric: '',
            ),
        '/summary': (context) => const Summary(
              start: '',
              end: '',
              approvedCount: 0,
              pendingCount: 0,
              rejectedCount: 0,
            ),
        '/monthly_report': (context) => MonthlyReport(
              onCalculateStatus: (int approved, int pending, int rejected) {},
              weekNumber: submissionCount,
            ),
        '/final_report': (context) => const FinalReport(),
        '/details': (context) => const Details(),
        '/placements': (context) => const Placements(
              title: 'Placements',
              companyName: '',
            ),
        '/iap': (context) => IapForm(),
        '/help': (context) => const Help(title: 'Help')
      },
    );
  }
}
