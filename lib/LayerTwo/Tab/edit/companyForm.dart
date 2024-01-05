import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'zone_list.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm(
      {Key? key,
      this.initialCompany,
      this.initialIndustry,
      this.initialSector,
      this.initialZone,
      this.initialAllowance,
      this.initialStatus,
      this.initialAddress,
      this.initialPostcode,
      this.initialDuration,
      this.initialStart,
      this.initialEnd,
      this.onOfferLetterSelected})
      : super(key: key);

  final String? initialCompany,
      initialIndustry,
      initialSector,
      initialZone,
      initialAllowance,
      initialStatus,
      initialAddress,
      initialPostcode,
      initialDuration,
      initialStart,
      initialEnd;
  final void Function(String fileName)? onOfferLetterSelected;

  @override
  _CompanyFormState createState() => _CompanyFormState();
}

const List<String> zone = <String>[
  'Zone',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L'
];
const List<String> sector = <String>[
  'Sector',
  'Irrelevant',
  'Not Stated',
  'Agriculture, Forestry, and Fishing',
  'Mining and Quarrying',
  'Manufacturing',
  'Electricity, Gas, Steam, and Air Conditioning',
  'Water and Waste Service',
  'Construction',
  'Retail, Wholesale, and Vehicle Service',
  'Transport and Warehousing',
  'Accomodation and Food Service',
  'Information and Communication',
  'Financial, Insurance/Takaful Service',
  'Real Estate Service',
  'Professional, Scientific, and Technical Service',
  'Administrative and Support Service',
  'Public Administration and Safety',
  'Education and Training',
  'Health Care and Social Assistance',
  'Arts, Entertainment, and Recreation Service',
  'Other Services',
  'Private Households with Employeed Personel',
  'Territorial Organization and Bodies'
];
const List<String> industry = <String>[
  'Industry',
  'Irrelevant',
  'Not Stated',
  'Government',
  'Statutory Body',
  'Private Multinational',
  'Private Local',
  'Self Employed',
  'GLC',
  'NGO',
  'Others'
];
const List<String> zones = [
  'Zone A',
  'Zone B',
  'Zone C',
  'Zone D',
  'Zone E',
  'Zone F',
  'Zone G',
  'Zone H',
  'Zone I',
  'Zone J',
  'Zone K',
  'Zone L'
];
String? dropDownValueZone = 'Zone';
String? dropDownValueSector = 'Sector';
String? dropDownValueIndustry = 'Industry';

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController company = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController monthlyA = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController companyAdd = TextEditingController();
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  late TextEditingController offerletter;
  String selectedFile = '';
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    Data reportsProvider = Provider.of<Data>(context, listen: false);
    offerletter = TextEditingController(text: "-");
    company.text = widget.initialCompany ?? '-';
    dropDownValueIndustry = widget.initialIndustry;
    dropDownValueSector = widget.initialSector;
    dropDownValueZone = widget.initialZone;
    companyAdd.text = widget.initialAddress ?? '-';
    postcode.text = widget.initialPostcode ?? '-';
    monthlyA.text = widget.initialAllowance ?? '-';
    start.text = widget.initialStart ?? '-';
    end.text = widget.initialEnd ?? '-';
    reportsProvider.statusComp.text = '-';
  }

  void _pickFile() async {
    try {
      setState(() {
        _isUploading = true;
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
              .ref('Offer Letter/$userId/$fileName');
          UploadTask uploadTask =
              storageReference.putData(result.files.single.bytes!);
          await uploadTask.whenComplete(() async {
            // Retrieve download URL
            String fileDownloadURL = await storageReference.getDownloadURL();

            // Update selected file name
            setState(() {
              offerletter.text = fileName;
              selectedFile = fileDownloadURL;
              _isUploading = false;
            });
          });
        }
      } else {
        print("File picking canceled");
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      // Handle exceptions
      print("Error picking/uploading file: $e");
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            title: const Text(
              'Company Details',
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
                  child: Consumer<Data>(builder: (context, Data, child) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    TextFormField(
                                      key: UniqueKey(),
                                      controller: studentData.company,
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
                                            const Icon(Icons.domain_rounded),
                                        labelText: 'Company',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Offer Letter',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 15,
                                                      fontFamily: 'Futura'),
                                                  textAlign: TextAlign.left,
                                                ),
                                                const SizedBox(width: 10),
                                                ElevatedButton(
                                                    onPressed: _pickFile,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color.fromRGBO(
                                                              0, 146, 143, 10),
                                                    ),
                                                    child: const Text(
                                                      'Attach File',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Futura'),
                                                    )),
                                                if (_isUploading)
                                                  const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(0, 146, 143, 10),
                              ),
                            ),
                                              ]),
                                          const SizedBox(height: 7),
                                          Text(
                                            offerletter.text.isNotEmpty
                                                ? 'Selected File: ${offerletter.text}'
                                                : '',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontFamily: 'Futura',
                                            ),
                                          ),
                                        ]),
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      padding: const EdgeInsets.all(4),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline:
                                            Container(), // Remove underline
                                        value: dropDownValueIndustry,
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropDownValueIndustry = value!;
                                          });
                                        },
                                        items: industry
                                            .map<DropdownMenuItem<String>>(
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
                                        hint: const Text('  Industry'),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        iconSize: 24,
                                        elevation: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      padding: const EdgeInsets.all(4),
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        underline:
                                            Container(), // Remove underline
                                        value: dropDownValueSector,
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropDownValueSector = value!;
                                          });
                                        },
                                        items: sector
                                            .map<DropdownMenuItem<String>>(
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
                                        hint: const Text('  Sector'),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        iconSize: 24,
                                        elevation: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            padding: const EdgeInsets.all(4),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline:
                                                  Container(), // Remove underline
                                              value: dropDownValueZone,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  dropDownValueZone = value!;
                                                });
                                              },
                                              items: zone.map<
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
                                              hint: const Text('  Zone'),
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              iconSize: 24,
                                              elevation: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          flex: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              _showZoneSelectionModal(context);
                                            },
                                            child: const Icon(
                                              Icons.info,
                                              size: 30,
                                              color: Color.fromRGBO(
                                                  0, 146, 143, 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: UniqueKey(),
                                      controller: studentData.companyAdd,
                                      keyboardType: TextInputType.streetAddress,
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
                                        labelText: 'Address',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: UniqueKey(),
                                      controller: studentData.postcode,
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
                                            Icons.local_post_office_rounded),
                                        labelText: 'Postcode',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextFormField(
                                      key: UniqueKey(),
                                      controller: studentData.monthlyA,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        fillColor: Colors.grey[100],
                                        filled: true,
                                        prefixIcon: const Icon(
                                            Icons.monetization_on_rounded),
                                        prefixText: 'RM ', // Add this line
                                        labelText: 'Monthly Allowance',
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey[100],
                                      ),
                                      child: ExpansionTile(
                                        title: const Text(
                                            'Select Start Date and End Date',
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                        children: [
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            key: UniqueKey(),
                                            readOnly: true,
                                            controller: studentData.start,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              fillColor: Colors.grey[100],
                                              filled: true,
                                              prefixIcon: const Icon(
                                                  Icons.calendar_today),
                                              labelText: 'Start Date',
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    studentData.startDate ??
                                                        DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );

                                              if (pickedDate != null &&
                                                  (studentData.startDate ==
                                                          null ||
                                                      pickedDate.isAfter(
                                                          studentData
                                                              .startDate!))) {
                                                setState(() {
                                                  studentData.startDate =
                                                      pickedDate;
                                                  studentData.start.text =
                                                      DateFormat('dd MMMM yyyy')
                                                          .format(pickedDate);
                                                  studentData.calculateDuration(
                                                      context);
                                                });
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          // End Date Picker
                                          TextFormField(
                                            key: UniqueKey(),
                                            readOnly: true,
                                            controller: studentData.end,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  width: 0,
                                                  style: BorderStyle.none,
                                                ),
                                              ),
                                              fillColor: Colors.grey[100],
                                              filled: true,
                                              prefixIcon: const Icon(
                                                  Icons.calendar_today),
                                              labelText: 'End Date',
                                            ),
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    studentData.endDate ??
                                                        DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );

                                              if (pickedDate != null &&
                                                  (studentData.endDate ==
                                                          null ||
                                                      pickedDate.isAfter(
                                                          studentData
                                                              .endDate!))) {
                                                setState(() {
                                                  studentData.endDate =
                                                      pickedDate;
                                                  studentData.end.text =
                                                      DateFormat('dd MMMM yyyy')
                                                          .format(pickedDate);
                                                  studentData.calculateDuration(
                                                      context);
                                                });
                                              }
                                            },
                                          ),
                                          // Duration Field
                                          const SizedBox(height: 20),
                                          Text(
                                            'Duration (Months): ${studentData.duration.text}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: Tooltip(
                                            message:
                                                'Note\nMake sure Monthly Allowance (Oversea Placement Convert to MYR), Sector, Industry Sector, and Zone are correct.',
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showMoney(context);
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
                                    )
                                  ]))),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    studentData.duration.text = duration.text;
                                    studentData.calculateDuration(context);
                                    User? user =
                                        FirebaseAuth.instance.currentUser;

                                    if (user != null) {
                                      String userId = user.uid;

                                      DatabaseReference userRef =
                                          FirebaseDatabase.instance
                                              .ref('Student')
                                              .child('Company Details')
                                              .child(userId);

                                      if (int.parse(
                                              studentData.duration.text) >=
                                          6) {
                                        userRef.set({
                                          'Student ID': userId,
                                          'Company Name':
                                              studentData.company.text,
                                          'Offer Letter': selectedFile,
                                          'Industry': dropDownValueIndustry,
                                          'Sector': dropDownValueSector,
                                          'Zone': dropDownValueZone,
                                          'Address':
                                              studentData.companyAdd.text,
                                          'Postcode': studentData.postcode.text,
                                          'Monthly Allowance':
                                              'RM ${studentData.monthlyA.text}',
                                          'Start Date': studentData.start.text,
                                          'End Date': studentData.end.text,
                                          'Duration': studentData.duration.text,
                                          'Status':'Inactive'
                                        });
                                        Navigator.pushNamed(
                                            context, '/placements');
                                      } else {
                                        studentData.calculateDuration(context);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 146, 143, 10),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  child: const Text('Save',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          )
                        ]);
                  }),
                )))));
  }

  void showMoney(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Note',
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
                  text: 'Make sure ',
                ),
                TextSpan(
                  text: 'Monthly Allowance ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '(Oversea Placement Convert to MYR), ',
                ),
                TextSpan(
                  text: 'Sector, Industry Sector, ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'and '),
                TextSpan(
                  text: 'Zone ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: 'are correct.'),
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

  void _showZoneSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Zone',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ZoneList(
                        zones: zones,
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.bold)), // Pass the zones list here
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
