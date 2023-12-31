// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

class StatusManagement {
  String _studentStatus = 'Active';
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();

  StatusManagement() {
    _fetchStudentStatus();
  }

  Future<void> _fetchStudentStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (_studentStatus == false) {
      _studentStatus = 'Active';
    }

    _statusController.add(_studentStatus);
  }

  String get studentStatus => _studentStatus;

  Stream<String> get statusStream => _statusController.stream;

  void dispose() {
    _statusController.close();
  }
}
