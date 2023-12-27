import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:student/Service/auth_service.dart';

class CoverLetter extends StatefulWidget {
  const CoverLetter(
      {Key? key, required String title, this.initialStart, this.initialEnd})
      : super(key: key);

  final String? initialStart, initialEnd;
  @override
  _CoverLetterState createState() => _CoverLetterState();
}

class _CoverLetterState extends State<CoverLetter> {
  User? user = FirebaseAuth.instance.currentUser;
  AuthService authService = AuthService();
  late Data studentData;
  Data clDate = Data();

/*
  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Name: ${user?.displayName}'),
              pw.Text('Matric No: ${studentData.matric.text}'),
              pw.Text('Start Date: ${clDate.clStart.text}'),
              pw.Text('End Date: ${clDate.clEnd.text}'),
              // Add more details as needed
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<void> savePdf(Uint8List pdfBytes) async {
    try {
      // Save PDF to a file and open it
      // You can customize the file name and location
      final result = await FileSaveHelper.saveAndOpenFile(
        pdfBytes,
        'cover letter_${user?.displayName}_${DateTime.now().toLocal()}',
        'pdf',
      );

      if (result) {
        print('PDF saved successfully.');
      } else {
        print('Error saving PDF.');
      }
    } catch (e) {
      print('Error saving or opening file: $e');
    }
  }
*/
  @override
  void initState() {
    super.initState();
    clDate = Provider.of<Data>(context, listen: false);
    clDate.clStart.text = widget.initialStart ?? '-';
    clDate.clEnd.text = widget.initialEnd ?? '-';
    studentData = Provider.of<Data>(context, listen: false);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 25,
                color:
                    Color.fromRGBO(0, 146, 143, 10), // Use the specified color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Cover Letter',
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
            )),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Consumer<Data>(builder: (context, clDate, child) {
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text('Matric No',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54)),
                                        _matricNo(
                                            matricNo: studentData.matric.text),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                          const Divider(),
                          const SizedBox(height: 10),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                TextFormField(
                                  key: UniqueKey(),
                                  readOnly: true,
                                  controller: clDate.clStart,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    labelText: 'Start Date',
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          clDate.clStartDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );

                                    if (pickedDate != null &&
                                        (clDate.clStartDate == null ||
                                            pickedDate.isAfter(
                                                clDate.clStartDate!))) {
                                      setState(() {
                                        clDate.clStartDate = pickedDate;
                                        clDate.clStart.text =
                                            DateFormat('dd MMMM yyyy')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                // End Date Picker
                                TextFormField(
                                  key: UniqueKey(),
                                  readOnly: true,
                                  controller: clDate.clEnd,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                    labelText: 'End Date',
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          clDate.clEndDate ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );

                                    if (pickedDate != null &&
                                        (clDate.clEndDate == null ||
                                            pickedDate
                                                .isAfter(clDate.clEndDate!))) {
                                      setState(() {
                                        clDate.clEndDate = pickedDate;
                                        clDate.clEnd.text =
                                            DateFormat('dd MMMM yyyy')
                                                .format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ]),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      showIns(context);
                                    },
                                    child: const Icon(
                                      Icons.info,
                                      size: 30,
                                      color: Color.fromRGBO(0, 146, 143, 10),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                // Wrap with Expanded
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    User? user =
                                        FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      String userId = user.uid;

                                      DatabaseReference userRef =
                                          FirebaseDatabase.instance
                                              .ref('Student')
                                              .child('Cover Letter')
                                              .child(userId);

                                      userRef.set({
                                        'Student Name':
                                            studentData.iapname.text,
                                        'Start Date': clDate.clStart.text,
                                        'End Date': clDate.clEnd.text,
                                      });
                                    }
                                    //Uint8List pdfBytes = await generatePdf();
                                    //await savePdf(pdfBytes);

                                    send(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 146, 143, 10),
                                    // maximumSize is deprecated, use fixedSize with width and height
                                    fixedSize: const Size.fromHeight(50),
                                  ),
                                  icon: const Icon(Icons.email,
                                      color: Colors.white),
                                  label: const Text(
                                    "Request",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]);
                      })))),
        ));
  }

  void showIns(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Instructions',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          content: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    const TextSpan(
                      text: '1. ',
                    ),
                    TextSpan(
                        text: 'IMPORTANT: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800])),
                    const TextSpan(
                      text: 'Read the ',
                    ),
                    const TextSpan(
                        text: 'FAQ Section ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(
                      text:
                          'on procedures of IAP Cover Letter first before generating the Cover Letter ',
                    ),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    TextSpan(
                      text: '2. Print the letter using a ',
                    ),
                    TextSpan(
                        text: 'laser print ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'on  ',
                    ),
                    TextSpan(
                        text: 'A4 ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'size ',
                    ),
                    TextSpan(
                        text: '(80gsm).',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    TextSpan(
                      text:
                          '3. The department will not responsible for any incorrect information that you make, especially the ',
                    ),
                    TextSpan(
                        text: 'START',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'and  ',
                    ),
                    TextSpan(
                        text: 'END ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'dates.',
                    ),
                  ])),
            ),
          ]),
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

  void send(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.done_all_rounded,
                    size: 110,
                    color: Colors.green[800],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Text(
                    'Thank You',
                    textAlign: TextAlign.center, //<-- Center text here
                    style: TextStyle(
                      color: Color.fromRGBO(0, 146, 143, 10),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    'Please check your Email for the requested cover letter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/summary');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                  ),
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white, fontFamily: 'Futura'),
                  )),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}

class FileSaveHelper {
  static Future<bool> saveAndOpenFile(
    Uint8List bytes,
    String fileName,
    String fileType,
  ) async {
    try {
      // Save file to device
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName.$fileType');
      await file.writeAsBytes(bytes);

      // Open the file using a file explorer or another app
      OpenFile.open(file.path);

      return true;
    } catch (e) {
      print('Error saving or opening file: $e');
      return false;
    }
  }
}
