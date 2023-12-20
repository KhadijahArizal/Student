import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student/LayerTwo/LIDV/lidv.dart';
import 'package:student/LayerTwo/details.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/LayerTwo/FA/finalReport.dart';
import 'package:student/SignIn/SignIn.dart';
import 'package:student/layerOne/adminReview.dart';
import 'package:student/layerOne/iapForm.dart';
import 'package:student/layerOne/logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyBdoySdRPIPjSgZWmfgCto5LrRrhBWAwIU',
    appId: '1:138224128805:android:01dbc8e391aa2f45c6c0cc',
    messagingSenderId: '138224128805',
    projectId: 'ikict-student-f4e2e',
    databaseURL: 'https://ikict-student-f4e2e-default-rtdb.firebaseio.com/',
    storageBucket: "gs://ikict-student-f4e2e.appspot.com",
    authDomain: 'ikict-student-f4e2e.firebaseapp.com.',
  ));

  /*GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '138224128805-kgkkaeis97d6t1qhaqus4eb9lpqpvt5s.apps.googleusercontent.com',
  );
  // For silent sign-in (check if the user is already signed in)
  GoogleSignInAccount? account = googleSignIn.currentUser;
  account ??= await googleSignIn.signIn();*/

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKICT | Student',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(148, 112, 18, 1),
        fontFamily: 'Futura',
      ),
      initialRoute: '/splash',
      routes: {
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
              dname: '',
              demail: '',
              dmatric: '',
            ),
        '/monthly_report': (context) => MonthlyReport(
              reportType: ReportType.create,
              onCalculateStatus: (int approved, int pending, int rejected) {},
            ),
        '/final_report': (context) => const FinalReport(
              title: '',
              drive: '',
              date: '',
            ),
        '/lidv': (context) => const LIDV(
              title: 'LIDV',
            ),
        '/details': (context) => const Details(),
        '/placements': (context) => const Placements(
              title: 'Placements',
              companyName: '',
              companyAddress: '',
              companyPostcode: '',
              monthlyAllowance: '',
            ),
        '/iap': (context) => IapForm(),
      },
    );
  }
}
