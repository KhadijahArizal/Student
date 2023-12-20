import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController univ = TextEditingController();
  TextEditingController rdepart = TextEditingController();
  TextEditingController kull = TextEditingController();
  TextEditingController edepart = TextEditingController();
  TextEditingController ch = TextEditingController();
  TextEditingController totalch = TextEditingController();
  TextEditingController note = TextEditingController();
  late TextEditingController _grd;
  late TextEditingController _partial;
  late TextEditingController _confirm;
  
  //RealtimeDatabase
  final iapformdb = FirebaseDatabase.instance.ref('IAP Form');
  
  //FirebaseFirestore
  final FirebaseFirestore _firebasefr = FirebaseFirestore.instance;
  

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

    name.text = widget.initialName ?? '';
    matric.text = widget.initialMatric ?? '';
    email.text = widget.initialEmail ?? '';
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
      return const Color.fromRGBO(148, 112, 18, 1);
    }

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
              color: Color.fromRGBO(148, 112, 18, 1), size: 30),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.sort,
                    color: Color.fromRGBO(148, 112, 18, 1), size: 30),
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
                      child: SingleChildScrollView(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  controller: name,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.person_rounded),
                                    labelText: 'Name',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: matric,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon: const Icon(Icons.badge_rounded),
                                    labelText: 'Matric No',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your matric no';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: phone,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon: const Icon(Icons.call_rounded),
                                    labelText: 'Phone',
                                    hintText: "011-xxxxxxx",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon: const Icon(Icons.email_rounded),
                                    labelText: 'Email',
                                    hintText: "admin@live.iium.edu.my",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                )),
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
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: Container(), // Remove underline
                                value: dropdownValueMajor,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValueMajor = value!;
                                  });
                                },
                                items: major.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(value),
                                      ),
                                    );
                                  },
                                ).toList(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: Container(), // Remove underline
                                value: dropdownValueAdmission,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValueAdmission = value!;
                                  });
                                },
                                items: addmission.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(value),
                                      ),
                                    );
                                  },
                                ).toList(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                iconSize: 24,
                                elevation: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: univ,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText: 'University Required Course',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: rdepart,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText: 'Department Required Course',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: kull,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText: 'Kulliyyah Required Course',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: edepart,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText: 'Department Elective Course',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: ch,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText:
                                        'Credit Hours for Current Semester',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number';
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(height: 5),

                            Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: totalch,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.school_rounded),
                                    labelText: 'Total Credit Hours Required',
                                    hintText: "0/0",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
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
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                underline: Container(), // Remove underline
                                value: dropdownValueSem,
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValueSem = value!;
                                  });
                                },
                                items: sem.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(value),
                                      ),
                                    );
                                  },
                                ).toList(),
                                icon: const Icon(Icons.keyboard_arrow_down),
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                              backgroundColor: Colors.black87,
                                              side: const BorderSide(
                                                  color: Colors.white70),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100))),
                                          child: const Text(
                                            'Instruction',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontFamily: 'Futura'),
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
                                          textAlign: TextAlign.right,
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                            onPressed: _pickFileGrd,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      148, 112, 18, 1),
                                            ),
                                            child: const Text(
                                              'Attach File',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Futura'),
                                            )),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.black87),
                                        ),
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
                                          textAlign: TextAlign.right,
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                            onPressed: _pickFilePartial,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      148, 112, 18, 1),
                                            ),
                                            child: const Text(
                                              'Attach File',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Futura'),
                                            )),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.black87),
                                        ),
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
                                          textAlign: TextAlign.right,
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                            onPressed: _pickFileConfirm,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      148, 112, 18, 1),
                                            ),
                                            child: const Text(
                                              'Attach File',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Futura'),
                                            )),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.camera_alt_rounded,
                                              color: Colors.black87),
                                        )
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
                                  onChanged: (value) {
                                    note.text = value;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                                    prefixIcon:
                                        const Icon(Icons.note_alt_rounded),
                                    labelText: 'Note to Coordinator',
                                    hintText:
                                        "write with clear explanation and respectful manner",
                                  ),
                                )),
                            const SizedBox(height: 5),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      if (_formKey.currentState!.validate()) {
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      iapformdb.child('iapData').set({
                                        'Name': name.text,
                                        'Matric': matric.text,
                                        'Phone No': phone.text,
                                        'Email': email.text,
                                        'Major': dropdownValueMajor,
                                        'Admission Type':
                                            dropdownValueAdmission,
                                        'Univ Required Course': univ.text,
                                        'Department Required Course':
                                            rdepart.text,
                                        'Kulliyyah Required Course': kull.text,
                                        'Department Elective Course':
                                            edepart.text,
                                        'CH Current Sem': ch.text,
                                        'Total CH': totalch.text,
                                        'Semester': dropdownValueSem,
                                        'Note': note.text
                                      });
                                      GoReview();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(148, 112, 18, 1),
                                    ),
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Futura',
                                      ),
                                    ),
                                  ),
                                ]),
                          ],
                        ),
                      )))
                ])))));
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
                      backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
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
  Future<String?> uploadGrd(String fileName) async { //File files
  
    final Reference =
        FirebaseStorage.instance.ref().child('Graduation Audit/$fileName');
        
    //final UploadTask = Reference.putFile(files);
    //await UploadTask.whenComplete(() {});
    
    final downloadLink = await Reference.getDownloadURL();
    return downloadLink;
  }

  void _pickFileGrd() async { 
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (pickedFile != null && pickedFile.files.isNotEmpty) {
        PlatformFile file = pickedFile.files.first;
        String fileName = pickedFile.files[0].name;
        //File files = File(pickedFile.files[0].path!); 
        //final downloadLink = await uploadGrd(fileName);

        iapformdb.child('iapFile').set({
          'FileName' : fileName
        });

        print('Selected file: ${file.name}');

        setState(() {
          _grd.text = pickedFile.files.first.name;
        });
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }

  void _pickFilePartial() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _partial.text = result.files.first.name;
        });
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }

  void _pickFileConfirm() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _confirm.text = result.files.first.name;
        });
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
  }
}
