import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/Monthly/createReport.dart';
import 'package:file_picker/file_picker.dart';

class WeeklyTask extends StatefulWidget {
  const WeeklyTask({super.key, required this.title});
  final String title;

  @override
  _WeeklyTaskState createState() => _WeeklyTaskState();
}

class _WeeklyTaskState extends State<WeeklyTask> {
  Widget _Attach({
    required String attach,
    required VoidCallback onTap, // Add the onTap parameter
  }) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap function
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.file_present_sharp,
                size: 20, color: Color.fromRGBO(148, 112, 18, 1)),
            const SizedBox(width: 5),
            Text(
              attach,
              style: const TextStyle(
                  color: Color.fromRGBO(148, 112, 18, 1), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _Snap({required String snap}) => Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.camera_alt,
                size: 20, color: Color.fromRGBO(148, 112, 18, 1)),
            const SizedBox(width: 5),
            Text(
              snap,
              style: const TextStyle(
                  color: Color.fromRGBO(148, 112, 18, 1), fontSize: 15),
            )
          ],
        ),
      );

  Widget _Write({
    required String write,
    required VoidCallback onTap, // Add the onTap parameter
  }) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap function
      child: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.add_box,
                size: 20, color: Color.fromRGBO(148, 112, 18, 1)),
            const SizedBox(width: 5),
            Text(
              write,
              style: const TextStyle(
                  color: Color.fromRGBO(148, 112, 18, 1), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

//File Picker
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // You can specify the file types you want to allow
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        // You can access the selected file using file.name, file.path, etc.
        print('Selected file: ${file.name}');
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color:
                    Colors.black87.withOpacity(0.7), // Use the specified color
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
                              const Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 20),
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Monthly Reports',
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w900)),
                                                Text('Weekly Task',
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 20,
                                                    ))
                                              ])
                                        ]),
                                  ]),
                              const SizedBox(height: 20),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Add Submission',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black54)),
                                          const SizedBox(height: 20),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            _Attach(
                                                              attach:
                                                                  'Attach File',
                                                              onTap: () {
                                                                _pickFile();
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            _Write(
                                                              write:
                                                                  'Create Report',
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              CreateReportPage()),
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                            _Snap(
                                                                snap:
                                                                    'Snap a Picture'),
                                                          ]),
                                                    ])
                                              ]),
                                        ],
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 30),
                            ]))))));
  }
}
