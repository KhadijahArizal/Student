import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/Tab/student.dart';

class studentForm extends StatefulWidget {
  const studentForm({Key? key}) : super(key: key);

  @override
  _studentFormState createState() => _studentFormState();
}

const List<String> major = <String>['Major', 'BIT', 'BCS'];
const List<String> a = <String>['Br', 'Sr'];
String dropdownValue = '';

class _studentFormState extends State<studentForm> {
  final _formKey = GlobalKey<FormState>();
  //TextEditingController major = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController ic = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController citizenship = TextEditingController();

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

  Widget _matric({required String matric}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              matric,
              style: const TextStyle(color: Colors.black87, fontSize: 17),
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
                                          child: DropdownMenu<String>(
                                        initialSelection: a.first,
                                        onSelected: (String? value) {
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                        dropdownMenuEntries: a
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                          return DropdownMenuEntry<String>(
                                              value: value, label: value);
                                        }).toList(),
                                      )),
                                      const SizedBox(width: 10),
                                      Flexible(
                                          child: TextFormField(
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
                                                labelText: 'your name',
                                              ),
                                              enabled: false)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none)),
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        prefixIcon:
                                            const Icon(Icons.link_rounded),
                                        labelText: 'matric no',
                                      ),
                                      enabled: false),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.link_rounded),
                                      labelText: 'email',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        address.text = value;
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.credit_card_rounded),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.flag_circle_rounded),
                                      labelText: 'Citizenship',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        phone.text = value;
                                      });
                                    },
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
                                      prefixIcon: const Icon(Icons.call_rounded),
                                      labelText: 'Phone No',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  
                                  DropdownMenu<String>(
                                    initialSelection: major.first,
                                    onSelected: (String? value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                    dropdownMenuEntries: major
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  )
                                ]))),
                        const SizedBox(height: 25),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                 Expanded(child: ElevatedButton(
                                    onPressed: () {
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(148, 112, 18, 1),
                                           minimumSize: const Size.fromHeight(50)
                                    ),
                                    child: const Text('Save'),
                                  ))
                                ]))
                      ]),
                )))));
  }
}
