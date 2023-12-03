import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:student/LayerTwo/Monthly/monthlyReport.dart';

class CreateReportPage extends StatefulWidget {
  final ReportType reportType;
  
  CreateReportPage({required this.reportType, Key? key}) : super(key: key);
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  late TextEditingController _reportController;
  late TextEditingController _fileNameController;

  @override
  void initState() {
    super.initState();
    _reportController = TextEditingController();
    _fileNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        title: const Text(
          'Type Report',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            fontFamily: 'Futura',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save the current work
              _saveReport();
            },
          ),
        ],
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
                TextFormField(
                  controller: _fileNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none)),
                    fillColor: Colors.grey[100],
                    filled: true,
                    labelText: 'File Name',
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    controller: _reportController,
                    maxLines: null,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Type your report here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      // Submit the report to MonthlyReport page
                      _submitReport();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                    ),
                    child: const Text('Submit Report'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveReport() {
    // Implement your logic to save the current work
    // For simplicity, just print the report content and file name for now
    print('Saved File Name: ${_fileNameController.text}');
    print('Saved Report: ${_reportController.text}');
  }

  void _submitReport() {
    if (_fileNameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in the file name.'),
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
      return;
    }

    Navigator.pop(
      context,
      MonthlyReport(
        fileName: _fileNameController.text,
        status: 'Pending',
        month: DateFormat('MMMM').format(DateTime.now()),
        submissionDate:
            DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()),
        reportType: ReportType.create, // Pass the appropriate value
      ),
    );
  }
}
