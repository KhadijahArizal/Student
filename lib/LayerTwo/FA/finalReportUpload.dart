// ignore_for_file: non_constant_identifier_names

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Survey/surveyPage.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class FinalReportUpload extends StatefulWidget {
  const FinalReportUpload({
    Key? key,
    this.initialTitle,
    this.initialDate,
    this.initialStatus,
    this.onFileSelected,
  }) : super(key: key);

  final String? initialTitle, initialDate, initialStatus;
  final void Function(String fileName)? onFileSelected;

  @override
  _FinalReportUploadState createState() => _FinalReportUploadState();
}

class _FinalReportUploadState extends State<FinalReportUpload> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  String selectedFileFinal = '';
  DateTime selectedDate = DateTime.now();
  late TextEditingController finalReportName;
  bool _isUploading = false;

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please submit your $fieldName';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    finalReportName = TextEditingController(text: "-");
    title.text = widget.initialTitle ?? '-';
    Data reportsProvider = Provider.of<Data>(context, listen: false);
    reportsProvider.dateinput.text =
        DateFormat('dd MMMM yyyy').format(DateTime.now());
    reportsProvider.monthController.text =
        DateFormat('MMMM').format(DateTime.now());
  }

  void _pickFile() async {
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
              .ref('Final Report/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              finalReportName.text = fileName;
              selectedFileFinal = fileDownloadURL;
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
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading =
            false; // Set loading state to false if picking is canceled
      });
    }
  }

  void _submitSurvey() {
    _showSurveyPopup();
  }

  void _showSurveyPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Survey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Thank you for submitting your final report! Would you like to answer a survey about your internship experience now? you still can do it later, the survey menu is now available in sidebar menu',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurveyPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 146, 143, 10)),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/final_report');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 146, 143, 10)),
              child: const Text(
                'Later',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            title: const Text(
              'Final Report',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Futura'),
            ),
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData(
                color: Color.fromRGBO(0, 146, 143, 10), size: 30)),
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.all(20),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Consumer<Data>(
                            builder: (context, reportsProvider, child) {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.title,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            width: 0,
                                                            style: BorderStyle
                                                                .none)),
                                                fillColor: Colors.grey[100],
                                                filled: true,
                                                prefixIcon: const Icon(
                                                    Icons.title_rounded),
                                                hintText: '',
                                                labelText: 'Report Title',
                                              ),
                                              validator: (value) =>
                                                  _validateField(
                                                      value, 'report title'),
                                            ),
                                            const SizedBox(height: 20),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Final Report File',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'Futura'),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        ElevatedButton(
                                                            onPressed:
                                                                _pickFile,
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      0,
                                                                      146,
                                                                      143,
                                                                      10),
                                                            ),
                                                            child: const Text(
                                                              'Attach File',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Futura'),
                                                            )),
                                                        if (_isUploading)
                                                          const CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                    Color>(
                                                              Color.fromRGBO(0,
                                                                  146, 143, 10),
                                                            ),
                                                          ),
                                                      ]),
                                                  const SizedBox(height: 7),
                                                  Text(
                                                    finalReportName
                                                            .text.isNotEmpty
                                                        ? 'Selected File: ${finalReportName.text}'
                                                        : '',
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily: 'Futura',
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              controller:
                                                  reportsProvider.dateinput,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none),
                                                ),
                                                fillColor: Colors.grey[100],
                                                filled: true,
                                                prefixIcon: const Icon(
                                                    Icons.calendar_today),
                                                labelText: 'Date',
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              controller:
                                                  reportsProvider.statusFinal,
                                              decoration: const InputDecoration(
                                                  labelText: 'Status'),
                                              readOnly: true,
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: Tooltip(
                                                    message:
                                                        'Submission should be in PDF format',
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showPDFformat(
                                                                context);
                                                          },
                                                          child: const Icon(
                                                            Icons.info,
                                                            size: 30,
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    146,
                                                                    143,
                                                                    10),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ))),
                                const SizedBox(height: 20),
                                Container(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              child: ElevatedButton(
                                            onPressed: () async {
                                              User? user = FirebaseAuth
                                                  .instance.currentUser;

                                              reportsProvider.finalReportName
                                                  .text = finalReportName.text;
                                              if (user != null) {
                                                String userId = user.uid;

                                                DatabaseReference userRef =
                                                    FirebaseDatabase.instance
                                                        .ref('Student')
                                                        .child('Final Report')
                                                        .child(userId);

                                                userRef.set({
                                                  'Student ID': userId,
                                                  'Report Title':
                                                      studentData.title.text,
                                                  'File Name': reportsProvider
                                                      .finalReportName.text,
                                                  'File': selectedFileFinal,
                                                  'Date': reportsProvider
                                                      .dateinput.text,
                                                  'Status': 'Submitted',
                                                  'StatusSV': 'Pending',
                                                  'StatusEX': 'Pending',
                                                  'FeedbackSV': 'No Feedback',
                                                  'FeedbackEX': 'No Feedback'
                                                });

                                                _submitSurvey();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        0, 146, 143, 10),
                                                minimumSize:
                                                    const Size.fromHeight(50)),
                                            child: const Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))
                                        ])),
                              ]);
                        }))))));
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
}
