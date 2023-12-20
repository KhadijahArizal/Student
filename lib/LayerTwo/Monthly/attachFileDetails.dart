import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';

class AttachFileDetailsPage extends StatefulWidget {
  final MonthlyReport? editReport;

  const AttachFileDetailsPage(
      {super.key, this.editReport, required ReportType reportType});

  @override
  _AttachFileDetailsPageState createState() => _AttachFileDetailsPageState();
}

class _AttachFileDetailsPageState extends State<AttachFileDetailsPage> {
  late TextEditingController _fileNameController;
  late TextEditingController _statusController;
  late TextEditingController _monthController;
  late TextEditingController _submitController;

  //RealtimeDatabase
  final monthlydb = FirebaseDatabase.instance.ref('Monthly Report');

  @override
  void initState() {
    super.initState();
    _fileNameController =
        TextEditingController(text: widget.editReport?.fileName ?? "-");
    _statusController = TextEditingController(
        text: widget.editReport?.status ?? "Pending"); //Approved
    _monthController = TextEditingController(
      text: DateFormat('MMMM').format(DateTime.now()),
    );
    _submitController = TextEditingController(
        text: DateFormat('dd MMMM yyyy').format(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {

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
          color: Color.fromRGBO(148, 112, 18, 1),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    minimumSize:
                        MaterialStateProperty.all(const Size.fromHeight(100)),
                    backgroundColor: MaterialStateProperty.all(Colors.grey[50]),
                    side: MaterialStateProperty.all(const BorderSide(
                      color: Color.fromARGB(255, 216, 213, 213),
                    )),
                    elevation: MaterialStateProperty.all(0.01),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _fileNameController,
                  decoration: const InputDecoration(labelText: 'File Name'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _monthController,
                  decoration: const InputDecoration(labelText: 'Month'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _submitController,
                  decoration:
                      const InputDecoration(labelText: 'Submission Date'),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
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
                              color: Color.fromRGBO(
                                  148, 112, 18, 1)), // Set the border side
                          elevation: 0.0,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color.fromRGBO(148, 112, 18, 1),
                          ),
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        monthlydb.push().set({
                          'Name': _fileNameController.text,
                          'Month': _monthController.text,
                          'Submission Date': _submitController.text,
                          'Status': _statusController.text,
                        });
                        _saveReport();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                      ),
                      child: Text(
                          widget.editReport == null
                              ? 'Submit Report'
                              : 'Update Report',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveReport() {
    if (_fileNameController.text.trim().isEmpty) {
      // Display an error message to the user
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
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                ),
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Continue with saving the report
      print('File Name: ${_fileNameController.text}');
      print('Status: ${_statusController.text}');
      print('Month: ${_monthController.text}');
      print('Submission Date: ${_submitController.text}');

      Navigator.pop(
        context,
        MonthlyReport(
          fileName: _fileNameController.text,
          status: _statusController.text,
          month: _monthController.text,
          submissionDate: _submitController.text,
          reportType: ReportType.create,
          onCalculateStatus: (int approved, int pending, int rejected) {},
        ),
      );
    }
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _fileNameController.text = result.files.first.name;
        });
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }
}
