import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class studentForm extends StatefulWidget {
  studentForm({
    Key? key,
    this.initialBr,
    this.initialContact,
    this.initialAddress,
    this.initialIc,
    this.initialCitizenship,
    this.initialMajor,
    required this.matric,
    required String initialName,
    required String initialEmail,
  }) : super(key: key);

  final String? initialBr,
      initialContact,
      initialAddress,
      initialIc,
      initialCitizenship,
      initialMajor;
  final String matric;

  @override
  _studentFormState createState() => _studentFormState();
}

const List<String> major = <String>['Major', 'BIT', 'BCS'];
const List<String> br = <String>['Br', 'Sr'];
String dropdownValueMajor = 'Major';
String dropDownValueBr = 'Br';

class _studentFormState extends State<studentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController ic = TextEditingController();
  TextEditingController citizenship = TextEditingController();
  late String _matric;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _matric = widget.matric;
    name.text = '${user?.displayName}';
    email.text = '${user?.email}';
    dropDownValueBr = widget.initialBr ?? '-';
    contact.text = widget.initialContact ?? '-';
    address.text = widget.initialAddress ?? '-';
    ic.text = widget.initialIc ?? '-';
    citizenship.text = widget.initialCitizenship ?? '-';
    dropdownValueMajor = widget.initialMajor ?? '-';
  }

  void goStudent() {
    Navigator.pop(context, {
      'name': name.text,
      'email': email.text,
      'br': dropDownValueBr,
      'contact': contact.text,
      'address': address.text,
      'ic': ic.text,
      'citizenship': citizenship.text,
      'major': dropdownValueMajor
    });
  }

  Widget _name({required String name}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black87, fontSize: 17),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  Widget _matricNo({required String matricNo}) => Container(
        child: Column(
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
        ),
      );

  Widget _email({required String email}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              email,
              style: const TextStyle(color: Colors.black87, fontSize: 17),
            )
          ],
        ),
      );

  Widget _phone({required String phone}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              phone,
              style: const TextStyle(color: Colors.black87, fontSize: 17),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                          flex: 1,
                                          child: Container(
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
                                              value: dropDownValueBr,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueBr = value!;
                                                });
                                              },
                                              items: br.map<
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
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              iconSize: 24,
                                              elevation: 16,
                                            ),
                                          )),
                                      const SizedBox(width: 10),
                                      Flexible(
                                          flex: 2,
                                          child: TextFormField(
                                            controller: name,
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
                                                labelText: 'Name'),
                                            readOnly: true,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Matric No',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54)),
                                      _matricNo(matricNo: _matric),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                      items:
                                          major.map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text(value),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                      elevation: 16,
                                    ),
                                  ),
                                ]))),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              contact.text = value;
                            });
                          },
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
                          onChanged: (value) {
                            setState(() {
                              address.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.location_on_rounded),
                            labelText: 'Current Address',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              ic.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.credit_card_rounded),
                            labelText: 'IC/Passport No',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              citizenship.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                            fillColor: Colors.grey[100],
                            filled: true,
                            prefixIcon: const Icon(Icons.flag_circle_rounded),
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
                                          'Student Name': name.text,
                                          'Matric No': _matric,
                                          'Email': email.text,
                                          'Major': dropdownValueMajor,
                                          'Contact No': contact.text,
                                          'Address': address.text,
                                          'IC or Passport': ic.text,
                                          'Citizenship': citizenship.text,
                                        });
                                      }
                                      goStudent();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            148, 112, 18, 1),
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text('Save',
                                        style: TextStyle(color: Colors.white)),
                                  ))
                                ]))
                      ]),
                )))));
  }
}
