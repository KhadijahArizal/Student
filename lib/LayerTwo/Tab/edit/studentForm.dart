import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';

class studentForm extends StatefulWidget {
  studentForm({
    Key? key,
    this.initialContact,
    this.initialAddress,
    this.initialIc,
    this.initialCitizenship,
    this.initialMajor,
    this.initialMatric,
    required String initialName,
    required String initialEmail,
  }) : super(key: key);

  final String? initialContact,
      initialMatric,
      initialAddress,
      initialIc,
      initialCitizenship,
      initialMajor;

  @override
  _studentFormState createState() => _studentFormState();
}

const List<String> majorOptions = ['BIT', 'BCS'];
String? dropdownValueMajor;

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
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  //Student Details
  late DatabaseReference _iapFormRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    contact.text = widget.initialContact ?? '-';
    address.text = widget.initialAddress ?? '-';
    ic.text = widget.initialIc ?? '-';
    citizenship.text = widget.initialCitizenship ?? '-';
    dropdownValueMajor = widget.initialMajor;
    if (user != null) {
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      if (iapData != null) {
        iapData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String matric = value['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String email = iapData[key]['Email'] ?? '';
            String major = iapData[key]['Major'] ?? '';

            UserData user = UserData(
                userId: userId,
                matric: matric,
                name: name,
                email: email,
                major: major);
            userDataList.add(user);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return userDataList;
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
                            FutureBuilder<List<UserData>>(
                              future: _userDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  var user = snapshot.data?.isNotEmpty == true
                                      ? snapshot.data![0]
                                      : null;

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Form(
                                              key: _formKey,
                                              child: Column(children: [
                                                TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: user?.name ??
                                                              '-'),
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
                                                      fillColor:
                                                          Colors.grey[100],
                                                      filled: true,
                                                      prefixIcon: const Icon(
                                                          Icons.title_rounded),
                                                      labelText: 'Name'),
                                                  readOnly: true,
                                                ),
                                                const SizedBox(height: 20),
                                                TextFormField(
                                                  key: UniqueKey(),
                                                  controller:
                                                      TextEditingController(
                                                          text: user?.matric ??
                                                              '-'),
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                    prefixIcon: const Icon(Icons
                                                        .card_giftcard_rounded),
                                                    labelText: 'Matric No',
                                                  ),
                                                  readOnly: true,
                                                ),
                                                const SizedBox(height: 20),
                                                TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text: user?.major ??
                                                              '-'),
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
                                                      fillColor:
                                                          Colors.grey[100],
                                                      filled: true,
                                                      prefixIcon: const Icon(
                                                          Icons.school_rounded),
                                                      labelText: 'Major'),
                                                  readOnly: true,
                                                ),
                                              ]))),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        key: UniqueKey(),
                                        controller: studentData.contact,
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
                                          prefixIcon:
                                              const Icon(Icons.call_rounded),
                                          labelText: 'Contact No',
                                          hintText: 'Start with your country code. Ex, +62, +60'
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                          controller: TextEditingController(
                                              text: user?.email ?? '-'),
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
                                            labelText: 'E-mail',
                                          ),
                                          readOnly: true),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        key: UniqueKey(),
                                        controller: studentData.address,
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
                                              Icons.location_on_rounded),
                                          labelText: 'Current Address',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        key: UniqueKey(),
                                        controller: studentData.ic,
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
                                              Icons.credit_card_rounded),
                                          labelText: 'IC/Passport No',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        key: UniqueKey(),
                                        controller: studentData.citizenship,
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
                                              Icons.flag_circle_rounded),
                                          labelText: 'Citizenship',
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                    ],
                                  );
                                }
                              },
                            ),
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

                                            _fetchUserData()
                                                .then((userDataList) {
                                              if (userDataList.isNotEmpty) {
                                                UserData userData =
                                                    userDataList[0];

                                                userRef.set({
                                                  'Student ID': userId,
                                                  'Student Name': userData.name,
                                                  'Matric No': userData.matric,
                                                  'Email': userData.email,
                                                  'Major': userData.major,
                                                  'Contact No':
                                                      studentData.contact.text,
                                                  'Address':
                                                      studentData.address.text,
                                                  'IC or Passport':
                                                      studentData.ic.text,
                                                  'Citizenship': studentData
                                                      .citizenship.text,
                                                }).then((_) {
                                                  Navigator.pushNamed(
                                                      context, '/details');
                                                }).catchError((error) {
                                                  print(
                                                      'Error saving data: $error');
                                                  // Handle error appropriately
                                                });
                                              }
                                            });
                                            Navigator.pushNamed(
                                                context, '/details');
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

class UserData {
  final String userId, name, matric, email, major;

  UserData({
    required this.userId,
    required this.name,
    required this.matric,
    required this.email,
    required this.major,
  });
}
