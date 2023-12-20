import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'zone_list.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm(
      {Key? key,
      this.initialCompany,
      this.initialLetter,
      this.initialIndustry,
      this.initialSector,
      this.initialZone,
      this.initialAllowance,
      this.initialStatus,
      this.initialAddress,
      this.initialPostcode,
      this.initialDuration,
      this.initialStart,
      this.initialEnd})
      : super(key: key);

  final String? initialCompany,
      initialIndustry,
      initialLetter,
      initialSector,
      initialZone,
      initialAllowance,
      initialStatus,
      initialAddress,
      initialPostcode,
      initialDuration,
      initialStart,
      initialEnd;

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
String dropDownValueZone = 'Zone';
String dropDownValueSector = 'Sector';
String dropDownValueIndustry = 'Industry';

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();
  final company = TextEditingController();
  final postcode = TextEditingController();
  final monthlyA = TextEditingController();
  final duration = TextEditingController();
  final start = TextEditingController();
  final end = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  late TextEditingController _offerletter;
  late TextEditingController address ;
  late DatabaseReference companydb;

  @override
  void initState() {
    super.initState();
    companydb = FirebaseDatabase.instance.ref('Company Details');
    
    if (widget.initialCompany != null) {
      company.text = widget.initialCompany ?? '${widget.initialCompany}';
      _offerletter = TextEditingController(text: "-");
      dropDownValueIndustry = widget.initialIndustry!;
      dropDownValueSector = widget.initialSector!;
      dropDownValueZone = widget.initialZone!;
      address = TextEditingController(text: '${widget.initialAddress}');
      postcode.text = widget.initialPostcode!;
      monthlyA.text = widget.initialAllowance ?? '-';
      start.text = widget.initialStart ?? '-';
      end.text = widget.initialEnd ?? '-';
      duration.text = widget.initialDuration ?? '-';
    }
  }

  void goCompany() {
    Navigator.pop(context, {
      'company': company.text,
      'letter': _offerletter.text,
      'industry': dropDownValueIndustry,
      'sector': dropDownValueSector,
      'zone': dropDownValueZone,
      'address': address.text,
      'postcode': postcode.text,
      'monthlyA': monthlyA.text,
      'start': start.text,
      'end': end.text,
      'duration': duration.text
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        company.text = value;
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
                                                  style:
                                                      ElevatedButton.styleFrom(
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
                                            ]),
                                        const SizedBox(height: 7),
                                        Text(
                                          _offerletter.text.isNotEmpty
                                              ? 'Selected File: ${_offerletter.text}'
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Futura',
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[100],
                                    ),
                                    child: ExpansionTile(
                                      title: const Text(
                                          'Select Industry, Sector, and Zone',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                      children: [
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
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  underline:
                                                      Container(), // Remove underline
                                                  value: dropDownValueZone,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      dropDownValueZone =
                                                          value!;
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 5),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(value),
                                                        ),
                                                      );
                                                    },
                                                  ).toList(),
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
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
                                                  _showZoneSelectionModal(
                                                      context);
                                                },
                                                child: const Icon(
                                                  Icons.info,
                                                  size: 30,
                                                  color: Color.fromRGBO(
                                                      148, 112, 18, 1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        address.text = value;
                                      });
                                    },
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
                                      prefixIcon:
                                          const Icon(Icons.location_on_rounded),
                                      labelText: 'Address',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        postcode.text = value;
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
                                          Icons.local_post_office_rounded),
                                      labelText: 'Postcode',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        monthlyA.text = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
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
                                      prefixIcon: const Icon(
                                          Icons.monetization_on_rounded),
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
                                          controller: start,
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
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );

                                            if (pickedDate != null &&
                                                (startDate == null ||
                                                    pickedDate
                                                        .isAfter(startDate!))) {
                                              setState(() {
                                                startDate = pickedDate;
                                                start.text =
                                                    DateFormat('dd MMMM yyyy')
                                                        .format(pickedDate);
                                                calculateDuration();
                                              });
                                            } else {
                                              // Display an error for an invalid date range.
                                              showErrorDialog(
                                                  'Invalid date range');
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: end,
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
                                                  startDate ?? DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );

                                            if (pickedDate != null &&
                                                (endDate == null ||
                                                    pickedDate
                                                        .isAfter(endDate!))) {
                                              setState(() {
                                                endDate = pickedDate;
                                                end.text =
                                                    DateFormat('dd MMMM yyyy')
                                                        .format(pickedDate);
                                                calculateDuration();
                                              });
                                            } else {
                                              // Display an error for an invalid date range.
                                              showErrorDialog(
                                                  'Invalid date range');
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        TextFormField(
                                          controller: duration,
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
                                            labelText: 'Duration (Months)',
                                          ),
                                          readOnly: true,
                                        ),
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
                                                      148, 112, 18, 1),
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
                        Container(
                            child: Row(children: [
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              companydb.set({
                                'Company Name': company.text,
                                'Offer Letter': _offerletter.text,
                                'Industry': dropDownValueIndustry,
                                'Sector': dropDownValueSector,
                                'Zone': dropDownValueZone,
                                'Address': address.text,
                                'Postcode': postcode.text,
                                'Monthly Allowance': monthlyA.text,
                                'Start Date': start.text,
                                'End Date': end.text,
                              });
                              goCompany();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(148, 112, 18, 1),
                                minimumSize: const Size.fromHeight(50)),
                            child: const Text('Save',
                                style: TextStyle(color: Colors.white)),
                          ))
                        ]))
                      ]),
                )))));
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');

        setState(() {
          _offerletter.text = result.files.first.name;
        });
      }
    } catch (e) {
      print('Error picking a file: $e');
    }
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
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.black87)),
            ),
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

  void calculateDuration() {
    if (startDate != null && endDate != null) {
      if (endDate!.isBefore(startDate!)) {
        showErrorDialog('Invalid date range');
      } else {
        Duration difference = endDate!.difference(startDate!);
        int months = (difference.inDays / 30).floor();

        if (months < 6) {
          showErrorDialog('Duration must be at least 6 months.');
        } else {
          duration.text = months.toString();
        }
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Colors.black87)),
            ),
          ],
        );
      },
    );
  }
}
