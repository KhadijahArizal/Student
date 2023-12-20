import 'dart:async';

class StatusManagement {
  String _studentStatus = 'Active'; // Initialize to 'Inactive'
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();

  StatusManagement() {
    _fetchStudentStatus();
  }

  Future<void> _fetchStudentStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate fetching the actual status from your data source.
    // Replace this with your logic to determine the real status.
    // ignore: unrelated_type_equality_checks
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
