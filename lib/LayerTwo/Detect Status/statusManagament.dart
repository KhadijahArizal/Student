// statusManagement.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StatusManagement {
  String _studentStatus = 'Active';
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  StatusManagement() {
    fetchStudentStatus();
  }

  Future<void> fetchStudentStatus() async {
  try {
    DataSnapshot companySnapshot = await FirebaseDatabase.instance
        .ref('Student')
        .child('Company Details')
        .once()
        .then((event) => event.snapshot);

    Map<dynamic, dynamic>? companyData =
        companySnapshot.value as Map<dynamic, dynamic>?;

    if (companyData != null) {
      var userStatus = companyData[userId]; // Get status associated with userId

      if (userStatus is Map<dynamic, dynamic>) {
        String status = userStatus['Status'] ?? 'Inactive';
        _studentStatus = status;
      }
    }
  } catch (e) {
    print('Error fetching data: $e');
  }

  _statusController.add(_studentStatus);
}


  String get studentStatus => _studentStatus;

  Stream<String> get statusStream => _statusController.stream;

  void dispose() {
    _statusController.close();
  }
}
