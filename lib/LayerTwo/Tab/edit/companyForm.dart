import 'package:flutter/services.dart';
import 'package:student/LayerTwo/placements.dart';

import 'zone_list.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm({Key? key}) : super(key: key);

  @override
  _CompanyFormState createState() => _CompanyFormState();
}

const List<String> zone = <String>[
  'zone',
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
  'sector',
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
  'industry',
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
final List<String> zones = [
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

String dropdownValue = '';
TextEditingController company = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController postcode = TextEditingController();
TextEditingController monthlyA = TextEditingController();

class _CompanyFormState extends State<CompanyForm> {
  final _formKey = GlobalKey<FormState>();

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
                                  SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: <Widget>[
                                          DropdownMenu<String>(
                                            initialSelection: industry.first,
                                            onSelected: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            dropdownMenuEntries: industry
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                          const SizedBox(width: 10),
                                          DropdownMenu<String>(
                                            initialSelection: sector.first,
                                            onSelected: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            dropdownMenuEntries: sector
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                          const SizedBox(width: 10),
                                          DropdownMenu<String>(
                                            initialSelection: zone.first,
                                            onSelected: (String? value) {
                                              setState(() {
                                                dropdownValue = value!;
                                              });
                                            },
                                            dropdownMenuEntries: zone
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                        ],
                                      )),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.monetization_on_rounded),
                                      labelText: 'Monthly Allownance',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                               Column(children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              _showZoneSelectionModal(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black87,
                                                side: const BorderSide(
                                                    color: Colors.white70),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25))),
                                            child: const Text(
                                              'Zone',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontFamily: 'Futura'),
                                            ))
                                      ]),
                                  const Divider(),
                                  Text(
                                    'Note',
                                    style: TextStyle(
                                        color: Colors.red[800],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Futura'),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Divider(),
                                  RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic,
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
                                            )),
                                        TextSpan(
                                          text:
                                              '(Oversea Placement Convert to MYR), ',
                                        ),
                                        TextSpan(
                                            text: 'Sector, Industry Sector, ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(text: 'and '),
                                        TextSpan(
                                            text: 'Zone ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(text: 'are correct.'),
                                      ],
                                    ),
                                  )
                                ]),
                              
                                ]))),
                        const SizedBox(height: 25),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            148, 112, 18, 1),
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text('Save'),
                                  ))
                                ]))
                      ]),
                )))));
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
