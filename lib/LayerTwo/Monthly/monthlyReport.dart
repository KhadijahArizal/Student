// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Monthly/attachFileDetails.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/edit/companyForm.dart';
import 'package:student/SideNavBar/sideNav2.dart';
import 'package:student/BottomNavBar/bottomMenu.dart';
import 'package:student/main.dart';
import '../Detect Status/statusManagament.dart';
import 'package:url_launcher/url_launcher.dart';

enum ReportType {
  file,
  create,
}

class MonthlyReport extends StatefulWidget {
  MonthlyReport({
    Key? key,
    this.fileName,
    this.createdDate,
    this.month,
    this.submissionDate,
    this.status,
    this.fileUrl,
    required this.reportType,
    required this.onCalculateStatus,
    required this.weekNumber,
  })  : statusColor = _getStatusColor(status),
        super(key: key);

  static Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow[800]!;
      case 'Approved':
        return Colors.green[700]!;
      case 'Rejected':
        return Colors.red[700]!;
      default:
        return Colors.black87; // Default color
    }
  }

  final String? fileUrl;
  final int weekNumber;
  final String? fileName, createdDate, month, submissionDate, status;
  final ReportType reportType;
  final Color statusColor;
  final void Function(int approved, int pending, int rejected)
      onCalculateStatus;

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  int submissionCount = 0;
  late StatusManagement _statusManagement;
  PlatformFile? file;

  final StatusManagement statusManager = StatusManagement();
  late TextEditingController fileName =
      TextEditingController(text: widget.fileName ?? '-');
  late TextEditingController createdDate =
      TextEditingController(text: widget.createdDate ?? '-');
  late TextEditingController month =
      TextEditingController(text: widget.month ?? '-');
  late TextEditingController submissionDate =
      TextEditingController(text: widget.submissionDate ?? '-');
  late TextEditingController status =
      TextEditingController(text: widget.status ?? '-');

  Widget _examiner({required String examiner}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              examiner,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            )
          ],
        ),
      );

  Widget _email({required String email}) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              email,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      );

  Widget _zone({required String zone}) => Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              zone,
              style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  int _currentIndex = 1;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        Navigator.pushNamed(context, '/summary');
      } else if (index == 1 && _statusManagement.studentStatus == 'Active') {
        Navigator.pushNamed(context, '/monthly_report');
      } else if (index == 2 && _statusManagement.studentStatus == 'Active') {
        Navigator.pushNamed(context, '/final_report');
      }
    });
  }

  @override
  void dispose() {
    _statusManagement.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _statusManagement = StatusManagement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Monthly Report',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.sort,
                  color: Color.fromRGBO(0, 146, 143, 10), size: 30),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: sideNav2(studentStatus: statusManager.studentStatus),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: const AssetImage('assets/iiumlogo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white30.withOpacity(0.2), BlendMode.dstATop),
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Consumer<Data>(builder: (context, dataProvider, child) {
                  List<MonthlyReport> reports = [];
                  reports = dataProvider.reports;
                  int submissionCount = reportsProvider.reports.length + 1;

                  return Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Examiner Name',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                    _examiner(
                                        examiner: 'Dr. Salahuddin Bin Jamal'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Email',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                    _email(
                                        email: 'salahuddin@live.iium.edu.my'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Evaluation Zone',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54)),
                                    _zone(zone: dropDownValueZone),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          child: DataTable(
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white12),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) =>
                                    const Color.fromRGBO(0, 146, 143, 10)),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Week',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'File Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Month',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Submission Date',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Status',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            rows: reports.map((report) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text('${submissionCount++}'),
                                  ),
                                  DataCell(
                                    GestureDetector(
                                      onTap: () {
                                        _openPdfFile(report.fileName);
                                      },
                                      child: Text(report.fileName ?? '-'),
                                    ),
                                  ),
                                  DataCell(Text(report.month ?? '-')),
                                  DataCell(Text(report.submissionDate ?? '-')),
                                  DataCell(Text(
                                    report.status ?? '-',
                                    style: TextStyle(
                                        color: report.statusColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded),
                                      onPressed: () {
                                        _editReport(report);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AttachFileDetailsPage(
                                  reportType: ReportType.file,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(0, 146, 143, 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  100), // Set the border radius to 100
                            ),
                          ),
                          icon: const Icon(Icons.add_circle,
                              color: Colors
                                  .white), // Icon data for elevated button
                          label: const Text(
                            "New Report",
                            style: TextStyle(color: Colors.white),
                          ), // Label text for elevated button
                        ),
                      ),
                    ],
                  );
                })),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        routeNames: const {
          'Summary': '/summary',
          'Monthly Report': '/monthly_report',
          'Final Report': '/final_report',
        },
        
      ),
    );
  }

  void _editReport(MonthlyReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachFileDetailsPage(
          reportType: ReportType.file,
          editReport: report,
        ),
      ),
    );
  }

  void _openPdfFile(String? fileUrl) async {
    if (fileUrl != null && fileUrl.isNotEmpty) {
      try {
        await launch(fileUrl);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the PDF file.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid PDF file URL.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
