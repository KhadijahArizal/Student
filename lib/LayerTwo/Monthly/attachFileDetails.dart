import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class AttachFileDetailsPage extends StatefulWidget {
  final MonthlyReport? editReport;

  const AttachFileDetailsPage({
    super.key,
    this.editReport,
    required ReportType reportType,
  });

  @override
  _AttachFileDetailsPageState createState() => _AttachFileDetailsPageState();
}

extension DateTimeExtension on DateTime {}

class _AttachFileDetailsPageState extends State<AttachFileDetailsPage> {
  int submissionCount = 0;
  DateTime selectedDate = DateTime.now();
  String selectedFileMonthly = '';
  late TextEditingController monthlyR;
  bool _isUploading = false;

  Widget _name({required String name}) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold))
        ],
      );

  Widget _matricNo({required String matricNo}) => Column(
        children: [
          Text(
            matricNo,
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
                fontWeight: FontWeight.bold),
          )
        ],
      );

  @override
  void initState() {
    super.initState();
    monthlyR = TextEditingController(text: "-");
    Data reportsProvider = Provider.of<Data>(context, listen: false);
    reportsProvider.submitController.text =
        DateFormat('dd MMMM yyyy').format(DateTime.now());
    reportsProvider.monthController.text =
        DateFormat('MMMM').format(DateTime.now());
    reportsProvider.statusController.text = '-';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var studentData = Provider.of<Data>(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: Text(
          widget.editReport == null ? 'Add Report' : 'Edit Report',
          style: const TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(0, 146, 143, 10),
          size: 30,
        ),
      ),
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
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<Data>(builder: (context, reportsProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Name',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      )),
                                  _name(name: '${user?.displayName}'),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text('Matric No',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  _matricNo(matricNo: studentData.matric.text),
                                ],
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        _pickFile();
                      },
                      icon: const Icon(
                        Icons.add_rounded,
                        color: Colors.black,
                        size: 30, // Adjust the size of the icon
                      ),
                      label: const Text(
                        'Choose New File',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            const Size.fromHeight(100)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[50]),
                        side: MaterialStateProperty.all(const BorderSide(
                          color: Color.fromARGB(255, 216, 213, 213),
                        )),
                        elevation: MaterialStateProperty.all(0.01),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            message: 'Submission should be in PDF format',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showPDFformat(context);
                                  },
                                  child: const Icon(
                                    Icons.info,
                                    size: 30,
                                    color: Color.fromRGBO(0, 146, 143, 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 7),
                    Row(children: [
                      Expanded(
                          child: Text(
                        monthlyR.text.isNotEmpty
                            ? 'Selected File: ${monthlyR.text}'
                            : '-',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Futura',
                        ),
                      )),
                      if (_isUploading) const CircularProgressIndicator()
                    ]),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: reportsProvider.statusController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        labelText: 'Status',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: reportsProvider.submitController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'Submission Date',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: reportsProvider.monthController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: 'Month',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Tooltip(
                            message:
                                'Declaration\nBy clicking the submit button you are agreeing to the below statements: \n1. I have provided the correct and accurate information when completing this monthly report. \n2. I have consulted with my supervisor regarding the description of the assigned tasks for the month.\n3. I understand the department may collect my information and disclose to the kulliyyah for progress monitoring purposes.\n4. I am responsible for any legal implication imposed by the company for any misleading information found in the submitted report.',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showDeclaration(context);
                                  },
                                  child: const Icon(
                                    Icons.info,
                                    size: 30,
                                    color: Color.fromRGBO(0, 146, 143, 10),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Color.fromRGBO(0, 146, 143, 10)),
                              elevation: 0.0,
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 146, 143, 10),
                              ),
                            ),
                          )),
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              int submissionCount =
                                  reportsProvider.reports.length + 1;
                              if (user != null) {
                                String userId = user.uid;

                                if (widget.editReport != null) {
                                  Provider.of<Data>(context, listen: false)
                                      .removeReport(widget.editReport!);
                                }

                                DatabaseReference userRef = FirebaseDatabase
                                    .instance
                                    .ref('Student')
                                    .child('Monthly Report')
                                    .child(userId)
                                    .child('Reports')
                                    .push();

                                userRef.set({
                                  'Week': submissionCount,
                                  'Name': monthlyR.text,
                                  'Month': reportsProvider.monthController.text,
                                  'Submission Date':
                                      reportsProvider.submitController.text,
                                  'Status': 'Pending',
                                  'File': selectedFileMonthly,
                                });

                                _saveReport();
                                // Navigate back to the monthly report page
                                Navigator.pushNamed(context, '/monthly_report');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor:
                                  const Color.fromRGBO(0, 146, 143, 10),
                            ),
                            child: Text(
                                widget.editReport == null
                                    ? 'Submit Report'
                                    : 'Update Report',
                                style: const TextStyle(color: Colors.white)),
                          )),
                    ]),
                  ],
                );
              })),
        ),
      ),
    );
  }

  void showDeclaration(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Declaration',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          content: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      'By clicking the submit button you are agreeing to the below statements: \n',
                ),
                TextSpan(
                  text:
                      '\n1. I have provided the correct and accurate information when completing this monthly report. ',
                ),
                TextSpan(
                  text:
                      '\n2. I have consulted with my supervisor regarding the description of the assigned tasks for the month. ',
                ),
                TextSpan(
                  text:
                      '\n3. I understand the department may collect my information and disclose to the kulliyyah for progress monitoring purposes. ',
                ),
                TextSpan(
                    text:
                        '\n4. I am responsible for any legal implication imposed by the company for any misleading information found in the submitted report.'),
              ],
            ),
          ),
          actions: <Widget>[
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

  void showPDFformat(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Attention',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          content: RichText(
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontFamily: 'Futura',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Submission should be in ',
                ),
                TextSpan(
                  text: 'PDF format ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Futura',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
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

  void _saveReport() {
    if (selectedFileMonthly.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 17,
                fontWeight: FontWeight.w800,
                fontFamily: 'Futura',
              ),
            ),
            content: const Text('Please submit your report'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                ),
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isUploading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.isNotEmpty) {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userId = user.uid;

          // Upload file to Firebase Storage
          String fileName = result.files.single.name;
          Reference storageReference = firebase_storage.FirebaseStorage.instance
              .ref('Monthly Report/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              monthlyR.text = fileName;
              selectedFileMonthly = fileDownloadURL;
              _isUploading = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
          _isUploading =
              false; // Set loading state to false if picking is canceled
        });
      }
    } catch (e) {
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading =
            false; // Set loading state to false if picking is canceled
      });
    }
  }
}
