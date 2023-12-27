import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/SideNavBar/sideNav1.dart';
import 'package:student/layerOne/adminReview.dart';

String dropdownValueMajor = 'Major';
String dropdownValueAdmission = 'Admission Type';
String dropdownValueSem = 'Semester';
var gender = '';

const List<String> major = <String>['Major', 'BIT', 'BCS'];
const List<String> addmission = <String>[
  'Admission Type',
  'Local',
  'International'
];
const List<String> sem = <String>[
  'Semester',
  '1 2024/2025',
  '2 2024/2025',
  '3 2024/2025'
];

// ignore: must_be_immutable
class IapForm extends StatefulWidget {
  IapForm({
    Key? key,
    this.initialName,
    this.initialMatric,
    this.initialEmail,
  }) : super(key: key);

  late String? initialName, initialEmail, initialMatric;

  @override
  _IapFormState createState() => _IapFormState();
}

class _IapFormState extends State<IapForm> {
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  TextEditingController name = TextEditingController();
  TextEditingController matric = TextEditingController();
  TextEditingController email = TextEditingController();
  late TextEditingController _grd;
  late TextEditingController _partial;
  late TextEditingController _confirm;
  User? user = FirebaseAuth.instance.currentUser;
  String selectedFileGrd = '';
  String selectedFilePartial = '';
  String selectedFileCon = '';
  bool _isUploading1 = false;
  bool _isUploading2 = false;
  bool _isUploading3 = false;
  void GoReview() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminReviewPage(
            name: name.text,
            matric: matric.text,
            email: email.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _grd = TextEditingController(text: "-");
    _partial = TextEditingController(text: "-");
    _confirm = TextEditingController(text: "-");

    name.text = widget.initialName ?? '-';
    matric.text = widget.initialMatric ?? '-';
    email.text = '${user?.email}';
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return const Color.fromARGB(255, 214, 180, 96);
      }
      return const Color.fromRGBO(0, 146, 143, 10);
    }

    var studentData = Provider.of<Data>(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
          title: const Text(
            'IAP Application',
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
              color: Color.fromRGBO(0, 146, 143, 10), size: 30),
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
        drawer: sideNav1(),
        body: SafeArea(
            child: Container(
                width: double.infinity,
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
                    child: Column(children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: SingleChildScrollView(child:
                          Consumer<Data>(builder: (context, Data, child) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //personal details
                                        const Text(
                                          'Personal Details',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.iapname,
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
                                                    Icons.person_rounded),
                                                labelText: 'Name',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your name';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.matric,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.badge_rounded),
                                                labelText: 'Matric No',
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your matric no';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.contact,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.call_rounded),
                                                labelText: 'Phone',
                                                hintText: "011-xxxxxxx",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your phone number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: TextFormField(
                                              controller: email,
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
                                                    Icons.link_rounded),
                                                labelText: 'E-mail',
                                              ),
                                              readOnly: true),
                                        ),
                                        const SizedBox(height: 20),

                                        //academic details
                                        const Text(
                                          'Academic Details',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Text(
                                          '(State your study plan credit hours)',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[100],
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline:
                                                Container(), // Remove underline
                                            value: dropdownValueMajor,
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValueMajor = value!;
                                              });
                                            },
                                            items: major
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(value),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            iconSize: 24,
                                            elevation: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[100],
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline:
                                                Container(), // Remove underline
                                            value: dropdownValueAdmission,
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValueAdmission = value!;
                                              });
                                            },
                                            items: addmission
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(value),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            iconSize: 24,
                                            elevation: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.univ,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'University Required Course',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.rdepart,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'Department Required Course',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.kull,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'Kulliyyah Required Course',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.edepart,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'Department Elective Course',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.ch,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'Credit Hours for Current Semester',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 5),

                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.totalch,
                                              keyboardType:
                                                  TextInputType.number,
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
                                                    Icons.school_rounded),
                                                labelText:
                                                    'Total Credit Hours Required',
                                                hintText: "0/0",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the number';
                                                }
                                                return null;
                                              },
                                            )),
                                        const SizedBox(height: 20),

                                        //commercement IAP
                                        const Text(
                                          'Commercement of Industrial Attachment Programme',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Text(
                                          '(select semester for IAP commercement/start)',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[100],
                                          ),
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            underline:
                                                Container(), // Remove underline
                                            value: dropdownValueSem,
                                            onChanged: (String? value) {
                                              setState(() {
                                                dropdownValueSem = value!;
                                              });
                                            },
                                            items: sem
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(value),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down),
                                            iconSize: 24,
                                            elevation: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        //Attachment
                                        const Text(
                                          'Required Attachments',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                '(for validation purposes)',
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily: 'Futura'),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(width: 5),
                                              SizedBox(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        instruction();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.black87,
                                                          side:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white70),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100))),
                                                      child: const Text(
                                                        'Instruction',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Futura'),
                                                      )))
                                            ]),
                                        const Divider(
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(height: 5),
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Graduation Audit:',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 17,
                                                          fontFamily: 'Futura'),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ElevatedButton(
                                                        onPressed:
                                                            pickAndUploadFileGrd,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(0,
                                                                  146, 143, 10),
                                                        ),
                                                        child: const Text(
                                                          'Attach File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Futura'),
                                                        )),if (_isUploading1) const CircularProgressIndicator(),
                                                    const SizedBox(width: 10),
                                                  ]),
                                              Text(
                                                _grd.text.isNotEmpty
                                                    ? 'Selected File: ${_grd.text}'
                                                    : '',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'Futura',
                                                ),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Partial Transcript:',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 17,
                                                          fontFamily: 'Futura'),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ElevatedButton(
                                                        onPressed:
                                                            pickAndUploadFilePartial,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(0,
                                                                  146, 143, 10),
                                                        ),
                                                        child: const Text(
                                                          'Attach File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Futura'),
                                                        )),if (_isUploading2) const CircularProgressIndicator(),
                                                  ]),
                                              Text(
                                                _partial.text.isNotEmpty
                                                    ? 'Selected File: ${_partial.text}'
                                                    : '',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'Futura',
                                                ),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'Confirmation Slip:',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 17,
                                                          fontFamily: 'Futura'),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ElevatedButton(
                                                        onPressed:
                                                            pickAndUploadFileCon,
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(0,
                                                                  146, 143, 10),
                                                        ),
                                                        child: const Text(
                                                          'Attach File',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Futura'),
                                                        )),if (_isUploading3) const CircularProgressIndicator(),
                                                  ]),
                                              Text(
                                                _confirm.text.isNotEmpty
                                                    ? 'Selected File: ${_confirm.text}'
                                                    : '',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: 'Futura',
                                                ),
                                              ),
                                            ]),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: Tooltip(
                                                message:
                                                    'Submission should be in PDF format',
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        showPDFformat(context);
                                                      },
                                                      child: const Icon(
                                                        Icons.info,
                                                        size: 30,
                                                        color: Color.fromRGBO(
                                                            0, 146, 143, 10),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),

                                        //note
                                        const Text(
                                          'Note to IAP Coordinator',
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 17,
                                              fontFamily: 'Futura'),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Divider(
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(height: 5),
                                        Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: TextFormField(
                                              key: UniqueKey(),
                                              controller: studentData.note,
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
                                                    Icons.note_alt_rounded),
                                                labelText:
                                                    'Note to Coordinator',
                                                hintText:
                                                    "write with clear explanation and respectful manner",
                                              ),
                                            )),
                                        const SizedBox(height: 5),

                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                checkColor: Colors.white,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith(getColor),
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      isChecked = value!;
                                                    });
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              const Expanded(
                                                  child: Text(
                                                'I have read and understand the above statements.',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 17,
                                                    fontFamily: 'Futura'),
                                                textAlign: TextAlign.start,
                                              )),
                                            ]),

                                        //SUBMIT BUTTON
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;

                                                  if (user != null) {
                                                    String userId = user.uid;
                                                    DatabaseReference userRef =
                                                        FirebaseDatabase
                                                            .instance
                                                            .ref('Student')
                                                            .child('IAP Form')
                                                            .child(userId);

                                                    userRef.set({
                                                      'Name': studentData
                                                          .iapname.text,
                                                      'Matric': studentData
                                                          .matric.text,
                                                      'Phone No': studentData
                                                          .contact.text,
                                                      'Email': email.text,
                                                      'Major':
                                                          dropdownValueMajor,
                                                      'Admission Type':
                                                          dropdownValueAdmission,
                                                      'Univ Required Course':
                                                          studentData.univ.text,
                                                      'Department Required Course':
                                                          studentData
                                                              .rdepart.text,
                                                      'Kulliyyah Required Course':
                                                          studentData.kull.text,
                                                      'Department Elective Course':
                                                          studentData
                                                              .edepart.text,
                                                      'CH Current Sem':
                                                          studentData.ch.text,
                                                      'Total CH': studentData
                                                          .totalch.text,
                                                      'Semester':
                                                          dropdownValueSem,
                                                      'Note':
                                                          studentData.note.text,
                                                      'Graduation Audit':
                                                          selectedFileGrd,
                                                      'Partial Transcript':
                                                          selectedFilePartial,
                                                      'Confirmation Letter':
                                                          selectedFileCon
                                                    });

                                                    GoReview();
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  maximumSize: const Size(
                                                      double.infinity, 50),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          0, 146, 143, 10),
                                                ),
                                                child: const Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Futura',
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ],
                                    ),
                                  ))
                            ]);
                      })))
                ])))));
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

  void instruction() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Instructions for Required Attachments',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'FUTURA'),
                textAlign: TextAlign.left,
              )),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '1. Log into your Google Drive',
                        )
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '2. Create a folder named ',
                        ),
                        TextSpan(
                            text: '"Required Attachments" ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'on your Google Drive.',
                        ),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '3. Upload your ',
                        ),
                        TextSpan(
                            text:
                                'Graduation Audit, Partial Transcript & Graduation Audit ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'in PDF format',
                        ),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text:
                              '4. Right Click at each of the uploaded files and select ',
                        ),
                        TextSpan(
                            text: '"Get shareable link".',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '5. Set ',
                        ),
                        TextSpan(
                            text: '"Link Sharing off" ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'to ',
                        ),
                        TextSpan(
                            text: '"On",',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '6. Click ',
                        ),
                        TextSpan(
                            text: '"Sharing Settings" ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'and set to ',
                        ),
                        TextSpan(
                            text: '"anyone with the link can view".',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '7. Copy the URL by clicking ',
                        ),
                        TextSpan(
                            text: '"Copy Link" ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'and paste into ',
                        ),
                        TextSpan(
                            text: '"Shared Google Drive Link" ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: 'text box.',
                        ),
                      ])),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 5, left: 20, right: 20),
                  child: RichText(
                      text: const TextSpan(
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontFamily: 'Futura'),
                          children: [
                        TextSpan(
                          text: '8. Get shareable links for all the 3 files.',
                        ),
                      ])),
                ),
              ],
            ),
          ),
          actions: [
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    ),
                    child: const Text(
                      'Ok',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Futura'),
                    ))),
            const SizedBox(height: 10)
          ],
        );
      },
    );
  }

  //STORAGE
  Future<void> pickAndUploadFileGrd() async {
    try {
      setState(() {
      _isUploading1 = true;
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
              .ref('IAP Form/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              _grd.text = fileName;
              selectedFileGrd = fileDownloadURL;
              _isUploading1 = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
        _isUploading1 = false; // Set loading state to false if picking is canceled
      });
      }
    } catch (e) {
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading1 = false; // Set loading state to false if picking is canceled
      });
    }
  }

  Future<void> pickAndUploadFilePartial() async {
    try {
      setState(() {
      _isUploading2 = true;
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
              .ref('IAP Form/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              _partial.text = fileName;
              selectedFilePartial = fileDownloadURL;
              _isUploading2 = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
        _isUploading2 = false; // Set loading state to false if picking is canceled
      });
      }
    } catch (e) {
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading2 = false; // Set loading state to false if picking is canceled
      });
    }
  }

  Future<void> pickAndUploadFileCon() async {
    try {
      setState(() {
      _isUploading3 = true;
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
              .ref('IAP Form/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              _confirm.text = fileName;
              selectedFileCon = fileDownloadURL;
              _isUploading3 = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
        _isUploading3 = false; // Set loading state to false if picking is canceled
      });
      }
    } catch (e) {
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading3 = false; // Set loading state to false if picking is canceled
      });
    }
  }
}
