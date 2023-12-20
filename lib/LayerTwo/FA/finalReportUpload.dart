import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FinalReportUpload extends StatefulWidget {
  const FinalReportUpload({
    Key? key,
    this.initialTitle,
    this.initialDrive,
    this.initialDate,
    this.initialStatus,
    this.onFileSelected,
  }) : super(key: key);

  final String? initialTitle, initialDrive, initialDate, initialStatus;
  final void Function(String fileName)? onFileSelected;

  @override
  _FinalReportUploadState createState() => _FinalReportUploadState();
}

class _FinalReportUploadState extends State<FinalReportUpload> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fileNameController;
  TextEditingController title = TextEditingController();
  TextEditingController drive = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  late TextEditingController _statusController;
  DateTime selectedDate = DateTime.now();
  String? selectedFilePath;

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please submit your $fieldName';
    }
    return null;
  }

  //RealtimeDatabase
  final finaldb = FirebaseDatabase.instance.ref('Final Report');
  
  @override
  void initState() {
    super.initState();
    _fileNameController = TextEditingController(text: "-");
    title.text = widget.initialTitle ?? '-';
    drive.text = widget.initialDrive ?? '-';
    dateinput.text = widget.initialDate ?? '-';
    _statusController = TextEditingController(text: "-");
    selectedDate = DateTime.now();
    dateinput.text = DateFormat('dd MMMM yyyy').format(selectedDate);
  }

  Widget _File({
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.file_present_rounded,
          size: 28, color: Color.fromRGBO(148, 112, 18, 1)),
    );
  }

  Widget _Cam({
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.camera_alt_rounded,
          size: 28, color: Color.fromRGBO(148, 112, 18, 1)),
    );
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _fileNameController.text = result.files.first.name;
        });

        widget.onFileSelected?.call(file.name);
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }

  void goUpload() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        {
          'title': title.text,
          'drive': drive.text,
          'date': dateinput.text,
          'status': _statusController.text,
          'fileName': _fileNameController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                color: Color.fromRGBO(148, 112, 18, 1), size: 30)),
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
                        child: Column(
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
                                            onChanged: (value) {
                                              setState(() {
                                                title.text = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none)),
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
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                      TextFormField(
                                                        onChanged: (value) {
                                                          setState(() {
                                                            drive.text = value;
                                                          });
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                      width: 0,
                                                                      style: BorderStyle
                                                                          .none)),
                                                          fillColor:
                                                              Colors.grey[100],
                                                          filled: true,
                                                          prefixIcon:
                                                              const Icon(Icons
                                                                  .link_rounded),
                                                          hintText: 'https://',
                                                          labelText:
                                                              'Google Drive Link',
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        _fileNameController
                                                                .text.isNotEmpty
                                                            ? 'Selected File: ${_fileNameController.text}'
                                                            : '',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Colors.green[700],
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ])),
                                                const SizedBox(width: 10),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    _File(onTap: _pickFile),
                                                    _Cam(
                                                      onTap: () {},
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                          const SizedBox(height: 20),
                                          TextFormField(
                                            controller: dateinput,
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
                                            controller: _statusController,
                                            decoration: const InputDecoration(
                                                labelText: 'Status'),
                                            readOnly: true,
                                          ),
                                        ],
                                      ))),
                              const SizedBox(height: 20),
                              Container(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            finaldb.set({
                                              'Report Title': title.text,
                                              'File':
                                                  _fileNameController.text,
                                              'Drive Link': drive.text,
                                              'Date': dateinput.text,
                                              'Status': _statusController.text,
                                            });
                                            goUpload();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      148, 112, 18, 1),
                                              minimumSize:
                                                  const Size.fromHeight(50)),
                                          child: const Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ))
                                      ])),
                            ]))))));
  }
}
