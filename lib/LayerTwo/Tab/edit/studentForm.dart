import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class studentForm extends StatefulWidget {
  studentForm({
    Key? key,
    this.initialSalutation,
    this.initialContact,
    this.initialAddress,
    this.initialIc,
    this.initialCitizenship,
    this.initialMajor,
    this.initialMatric,
    required String initialName,
    required String initialEmail,
  }) : super(key: key);

  final String? initialSalutation,
      initialContact,
      initialMatric,
      initialAddress,
      initialIc,
      initialCitizenship,
      initialMajor;

  @override
  _studentFormState createState() => _studentFormState();
}

const List<String> major = <String>['Major', 'BIT', 'BCS'];
String dropdownValueMajor = 'Major';
const List<String> salutation = <String>['Salutation', 'Br', 'Sr'];
String dropdownValueSalutation = 'Salutation';

class _studentFormState extends State<studentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController matric = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController ic = TextEditingController();
  TextEditingController citizenship = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    name.text = '${user?.displayName}';
    email.text = '${user?.email}';
    matric.text = widget.initialMatric ?? '-';
    contact.text = widget.initialContact ?? '-';
    address.text = widget.initialAddress ?? '-';
    ic.text = widget.initialIc ?? '-';
    citizenship.text = widget.initialCitizenship ?? '-';
    dropdownValueMajor = widget.initialMajor ?? '-';
    dropdownValueSalutation = widget.initialSalutation ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            title: const Text(
              'Student Details',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Consumer<Data>(
                    builder: (context, Data, child) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            flex: 1,
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline: Container(),
                                              value: dropdownValueSalutation,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropdownValueSalutation = value!;
                                                });
                                              },
                                              items: salutation.map<
                                                  DropdownMenuItem<String>>(
                                                (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Flexible(
                                              flex: 2,
                                              child: TextFormField(
                                                controller: name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                                width: 0,
                                                                style:
                                                                    BorderStyle
                                                                        .none)),
                                                    fillColor: Colors.grey[100],
                                                    filled: true,
                                                    prefixIcon: const Icon(
                                                        Icons.title_rounded),
                                                    labelText: 'Name'),
                                                readOnly: true,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        key: UniqueKey(),
                                        controller: studentData.matric,
                                        keyboardType: TextInputType.number,
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
                                              Icons.card_giftcard_rounded),
                                          labelText: 'Matric No',
                                        ),
                                        readOnly: true,
                                      ),
                                      const SizedBox(height: 20),
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
                                          underline: Container(),
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
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(value),
                                                ),
                                              );
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ]))),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: UniqueKey(),
                              controller: studentData.contact,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon: const Icon(Icons.call_rounded),
                                labelText: 'Contact No',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                  fillColor: Colors.grey[100],
                                  filled: true,
                                  prefixIcon: const Icon(Icons.link_rounded),
                                  labelText: 'E-mail',
                                ),
                                readOnly: true),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: UniqueKey(),
                              controller: studentData.address,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon:
                                    const Icon(Icons.location_on_rounded),
                                labelText: 'Current Address',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: UniqueKey(),
                              controller: studentData.ic,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon:
                                    const Icon(Icons.credit_card_rounded),
                                labelText: 'IC/Passport No',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              key: UniqueKey(),
                              controller: studentData.citizenship,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        width: 0, style: BorderStyle.none)),
                                fillColor: Colors.grey[100],
                                filled: true,
                                prefixIcon:
                                    const Icon(Icons.flag_circle_rounded),
                                labelText: 'Citizenship',
                              ),
                            ),
                            const SizedBox(height: 25),
                            Container(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          User? user =
                                              FirebaseAuth.instance.currentUser;

                                          if (user != null) {
                                            String userId = user.uid;
                                            DatabaseReference userRef =
                                                FirebaseDatabase.instance
                                                    .ref('Student')
                                                    .child('Student Details')
                                                    .child(userId);

                                            userRef.set({
                                              'Salutation': dropdownValueSalutation,
                                              'Student Name': name.text,
                                              'Matric No':
                                                  studentData.matric.text,
                                              'Email': email.text,
                                              'Major': dropdownValueMajor,
                                              'Contact No':
                                                  studentData.contact.text,
                                              'Address':
                                                  studentData.address.text,
                                              'IC or Passport':
                                                  studentData.ic.text,
                                              'Citizenship':
                                                  studentData.citizenship.text,
                                            });
                                            Navigator.pushNamed(context, '/details');
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    0, 146, 143, 10),
                                            minimumSize:
                                                const Size.fromHeight(50)),
                                        child: const Text('Save',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ))
                                    ]))
                          ]);
                    },
                  ),
                )))));
  }
}
