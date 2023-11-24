import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FinalReportUpload extends StatefulWidget {
  const FinalReportUpload({Key? key}) : super(key: key);

  @override
  _FinalReportUploadState createState() => _FinalReportUploadState();
}

class _FinalReportUploadState extends State<FinalReportUpload> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController drive = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedFilePath;

  @override
  void initState() {
    dateinput.text = '';
    super.initState();
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
      child: const Icon(Icons.camera_rounded,
          size: 28, color: Color.fromRGBO(148, 112, 18, 1)),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
    }
  }

  void navigateBackWithData() {
    Navigator.pop(context, {
      'title': title.text,
      'drive': drive.text,
      'date': dateinput.text,
    });
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
                                                      if (selectedFilePath !=
                                                          null)
                                                        const SizedBox(
                                                            height: 5),
                                                      Text(
                                                        'Selected File: $selectedFilePath',
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
                                                  Icons.calendar_month_rounded),
                                              labelText: 'Date',
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );

                                              if (pickedDate != null &&
                                                  pickedDate != selectedDate) {
                                                setState(() {
                                                  selectedDate = pickedDate;
                                                  dateinput.text =
                                                      DateFormat('dd MMMM yyyy')
                                                          .format(pickedDate);
                                                });
                                              }
                                            },
                                          )
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
                                            navigateBackWithData();
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      148, 112, 18, 1),
                                              minimumSize:
                                                  const Size.fromHeight(50)),
                                          child: const Text('Save'),
                                          
                                        ))
                                      ])),

                              //ROUNDED BUTTON
                              /*Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.only(top: 10),
                                      alignment: Alignment.bottomRight,
                                      child: Expanded(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                navigateBackWithData();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        148, 112, 18, 1),
                                                minimumSize:
                                                    const Size.fromHeight(50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                              ),
                                              child: const Text("Save")))),*/
                            ]))))));
  }
}
