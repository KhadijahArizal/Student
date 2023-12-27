// ignore_for_file: constant_identifier_names,, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';

class Data extends ChangeNotifier {
  //Student Details
  TextEditingController name = TextEditingController(); //Google
  TextEditingController matric = TextEditingController(); //Iap form
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController(); //Iap Form
  TextEditingController address = TextEditingController();
  TextEditingController ic = TextEditingController();
  TextEditingController citizenship = TextEditingController();

  //Emergency Details
  TextEditingController ename = TextEditingController();
  TextEditingController relationship = TextEditingController();
  TextEditingController econtact = TextEditingController();
  TextEditingController eaddress = TextEditingController();

  //Supervisor Details
  TextEditingController svname = TextEditingController();
  TextEditingController svemail = TextEditingController();
  TextEditingController svcontact = TextEditingController();

  //Exminer Details
  TextEditingController exname = TextEditingController(text: 'Not Assign Yet');
  TextEditingController exemail = TextEditingController(text: 'Not Assign Yet');
  TextEditingController excontact = TextEditingController(text: 'Not Assign Yet');
  
  //Company Details
  String selectedFile = '';
  TextEditingController company = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController monthlyA = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController companyAdd = TextEditingController();
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  //Final Report
  void calculateDuration(BuildContext context) {
    if (startDate != null && endDate != null) {
      if (endDate!.isBefore(startDate!)) {
        showErrorDialog(context, 'Invalid date range');
      } else {
        Duration difference = endDate!.difference(startDate!);
        int months = (difference.inDays / 30).ceil(); // Use ceil to round up
        duration.text = months.toString();

        if (months < 6) {
          showErrorDialog(context, 'Duration must be at least 6 months.');
        }
      }
    }
  }
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          content: Text(message),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.white, fontFamily: 'Futura'),
                )),
          ],
        );
      },
    );
  }
  DateTime? deadlineDate;
  TextEditingController title = TextEditingController();
  TextEditingController drive = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  TextEditingController statusFinal = TextEditingController();
  TextEditingController finalReportName = TextEditingController();

  //Monthly Report
  List<MonthlyReport> _reports = [];
  List<MonthlyReport> get reports => _reports;
  void addReport(MonthlyReport newReport) {
    _reports.add(newReport);
    notifyListeners();
  }
  void removeReport(MonthlyReport report) async {
    reports.remove(report);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      // Find the reference to the report in Firebase
      DatabaseReference reportRef = FirebaseDatabase.instance
          .reference()
          .child('Student')
          .child('Monthly Report')
          .child(userId);

      // Remove the report from Firebase
      await reportRef.remove();

      notifyListeners();
    }
  }
  TextEditingController monthlyReport = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController submitController = TextEditingController();
  TextEditingController monthlyR = TextEditingController();
  String selectedFileMonthly = '';

  //Cover Letter
  TextEditingController clStart = TextEditingController();
  TextEditingController clEnd = TextEditingController();
  DateTime? clStartDate;
  DateTime? clEndDate;

  //IAP Form
  TextEditingController iapname = TextEditingController(); //Fill in
  TextEditingController univ = TextEditingController();
  TextEditingController rdepart = TextEditingController();
  TextEditingController kull = TextEditingController();
  TextEditingController edepart = TextEditingController();
  TextEditingController ch = TextEditingController();
  TextEditingController totalch = TextEditingController();
  TextEditingController note = TextEditingController();
}
