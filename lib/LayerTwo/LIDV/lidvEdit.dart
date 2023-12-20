import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class lidvEdit extends StatefulWidget {
  const lidvEdit(
      {Key? key,
      this.initialName,
      this.initialSem,
      this.initialSession,
      this.initialMahallah,
      this.initialBlock,
      this.initialRoom})
      : super(key: key);

  final String? initialName,
      initialSem,
      initialSession,
      initialMahallah,
      initialBlock,
      initialRoom;

  @override
  _lidvEditState createState() => _lidvEditState();
}

const List<String> semL = <String>['Semester', '1', '2', '3'];
const List<String> session = <String>[
  'Session',
  '2023/2024',
  '2024/2025',
  '2025/2026'
];
const List<String> mahallah = <String>[
  'Mahallah',
  'Hafsa',
  'Asma',
  'Aminah',
  'Asiah',
  'Ruqayyah',
  'Halimah',
  'Maryam',
  'Faruq',
  'Zubari',
  'Ali',
  'Syafiyyah',
  'Salahuddin'
];
String dropdownValueSession = 'Session';
String dropDownValueSemL = 'Semester';
String dropDownValueMahallah = 'Mahallah';

class _lidvEditState extends State<lidvEdit> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController room = TextEditingController();
  late DatabaseReference lidvdb;

  @override
  void initState() {
    super.initState();
    lidvdb = FirebaseDatabase.instance.ref('LIDV');
    if (widget.initialName != null) {
      name.text = widget.initialName!;
      dropDownValueSemL = widget.initialSem ?? '-';
      dropdownValueSession = widget.initialSession ?? '-';
      dropDownValueMahallah = widget.initialMahallah ?? '-';
      block.text = widget.initialBlock ?? '-';
      room.text = widget.initialRoom ?? '-';
    }
  }

  void goLIDV() {
    Navigator.pop(context, {
      'name': name.text,
      'sem': dropDownValueSemL,
      'session': dropdownValueSession,
      'mahallah': dropDownValueMahallah,
      'block': block.text,
      'room': room.text,
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

  Widget _block({required String block}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              block,
              style: const TextStyle(color: Colors.black87, fontSize: 17),
            )
          ],
        ),
      );

  Widget _room({required String room}) => Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Text(
              room,
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
              'LIDV Details',
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
                                    child: Column(children: [
                                      TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              name.text = value;
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
                                                Icons.person_rounded),
                                            labelText: 'Name',
                                          )),
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
                                          value: dropDownValueSemL,
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropDownValueSemL = value!;
                                            });
                                          },
                                          items: semL
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
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          iconSize: 24,
                                          elevation: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
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
                                          value: dropdownValueSession,
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropdownValueSession = value!;
                                            });
                                          },
                                          items: session
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
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          iconSize: 24,
                                          elevation: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
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
                                          value: dropDownValueMahallah,
                                          onChanged: (String? value) {
                                            setState(() {
                                              dropDownValueMahallah = value!;
                                            });
                                          },
                                          items: mahallah
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
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          iconSize: 24,
                                          elevation: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            block.text = value;
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
                                          prefixIcon: const Icon(
                                              Icons.apartment_rounded),
                                          labelText: 'Block',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              room.text = value;
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
                                                Icons.meeting_room_rounded),
                                            labelText: 'Room No',
                                          )),
                                      const SizedBox(height: 25),
                                      Container(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                    child: ElevatedButton(
                                                  onPressed: () {
                                                    lidvdb.set({
                                                      'Name': name.text,
                                                      'Semester':
                                                          dropDownValueSemL,
                                                      'Session':
                                                          dropdownValueSession,
                                                      'Mahallah':
                                                          dropDownValueMahallah,
                                                      'Block': block.text,
                                                      'Room No': room.text,
                                                    });
                                                    goLIDV();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                  .fromRGBO(148,
                                                                  112, 18, 1),
                                                          minimumSize:
                                                              const Size
                                                                  .fromHeight(
                                                                  50)),
                                                  child: const Text('Save',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ))
                                              ]))
                                    ]),
                                  ))
                            ]))))));
  }
}
