import 'package:flutter/material.dart';
import 'package:student/LayerTwo/details.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/LayerTwo/summary.dart';
import 'package:student/LayerTwo/FA/finalReport.dart';
import 'package:student/SignIn/SignIn.dart';
import 'package:student/layerOne/adminReview.dart';
import 'package:student/layerOne/iapForm.dart';
import 'package:student/layerOne/logo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKICT | Student',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(148, 112, 18, 1),
        fontFamily: 'Futura',
      ),
      initialRoute: '/summary',
      routes: {
        /*'/a': (context) => AttachFileDetailsPage(
              fileName: 'YourFileName',
              initialCreationDate: DateTime.now(), // Replace with the actual creation date
            ),*/
        '/signIn': (context) => const SignIn(),
        '/adminreview': (context) => const AdminReviewPage(name: '', email: '', matric: '',),
        '/summary': (context) => const Summary(dname: '', dmatric: '', demail: ''),
        '/monthly_report': (context) =>
             MonthlyReport(reportType: ReportType.create),
        '/final_report': (context) => const FinalReport(title: '', drive: '', date: '',),
        '/details': (context) => const Details(),
        '/placements': (context) => const Placements(
              title: 'Placements',
              companyName: '',
              companyAddress: '',
              companyPostcode: '',
              monthlyAllowance: '',
            ),
         '/iap': (context) =>
            const IapForm(),
      },
    );
  }
}
