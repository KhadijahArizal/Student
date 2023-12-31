// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/edit/companyForm.dart';
import 'package:url_launcher/url_launcher.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
  }) : super(key: key);

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  Data companyDate = Data();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  //Company Details
  late DatabaseReference _iapFormRef;
  late DatabaseReference _companyRef;
  late Future<List<UserData>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _iapFormRef = FirebaseDatabase.instance.ref('Student').child('IAP Form');
      _companyRef =
          FirebaseDatabase.instance.ref('Student').child('Company Details');
      _userDataFuture = _fetchUserData();
    }
  }

  Future<List<UserData>> _fetchUserData() async {
    List<UserData> userDataList = [];
    try {
      DataSnapshot iapSnapshot =
          await _iapFormRef.once().then((event) => event.snapshot);
      DataSnapshot companySnapshot =
          await _companyRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? iapData =
          iapSnapshot.value as Map<dynamic, dynamic>?;
      Map<dynamic, dynamic>? companyData =
          companySnapshot.value as Map<dynamic, dynamic>?;

      if (iapData != null && companyData != null) {
        companyData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            String matric = iapData[key]['Matric'] ?? '';
            String name = iapData[key]['Name'] ?? '';
            String email = iapData[key]['Email'] ?? '';
            //Company Details
            String sDate = value['Start Date'] ?? '';
            String eDate = value['End Date'] ?? '';
            String compName = value['Company Name'] ?? '';
            String status = value['Status'] ?? 'Pending';
            String zone = value['Zone'] ?? '';
            String address = value['Address'] ?? '';
            String postcode = value['Postcode'] ?? '';
            String industry = value['Industry'] ?? '';
            String allowance = value['Monthly Allowance'] ?? '';
            String duration = value['Duration'] ?? '';
            String sector = value['Sector'] ?? '';
            String letter = value['Offer Letter'] ?? '';

            UserData user = UserData(
              userId: userId,
              email: email,
              matric: matric,
              name: name,
              sDate: sDate,
              eDate: eDate,
              compName: compName,
              status: status,
              zone: zone,
              address: address,
              postcode: postcode,
              industry: industry,
              allowance: allowance,
              duration: duration,
              sector: sector,
              letter: letter,
            );
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
    companyDate = Provider.of<Data>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
          color: Colors.white.withOpacity(0.1),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<UserData>>(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailFile(
                                  'Offer Letter', user?.letter ?? '-'),
                              _buildDetailStatus(
                                  'Placement Status', user?.status ?? '-'),
                            ]),
                        _buildDetail('Zone', user?.zone ?? '-'),
                        _buildDetail('Industry', user?.industry ?? '-'),
                        _buildDetail('Sector', user?.sector ?? '-'),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail(
                                  'Monthly Allowance', user?.allowance ?? '-'),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail('Address', user?.address ?? '-'),
                              _buildDetail2('Postcode', user?.postcode ?? '-')
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetail('Start Date', user?.sDate ?? '-'),
                              _buildDetail2('End Date', user?.eDate ?? '-'),
                            ]),
                        _buildDetail('Duration', user?.duration ?? '-'),
                        const SizedBox(height: 70),
                        
                      ],
                    );
                  }
                },
              ),
              Row(children: [
                          Expanded(
                              child: ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyForm(
                                    onOfferLetterSelected: (fileDownloadURL) {},
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 146, 143, 10),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            icon: const Icon(Icons.edit_rounded,
                                color: Colors
                                    .white), // Icon data for elevated button
                            label: const Text("Edit",
                                style: TextStyle(color: Colors.white)),
                          ))
                        ]),
            ],
          )),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildDetail2(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildDetailFile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            _openPdfFile(value);
          },
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(0, 146, 143, 10),
          ),
          child: const Text(
            'View',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildDetailStatus(String label, String value) {
    Color statusColor = _getStatusColor(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 15,
                  color: statusColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow[800]!;
      case 'Approved':
        return Colors.green[700]!;
      case 'Rejected':
        return Colors.red[700]!;
      default:
        return Colors.black87; // Default color
    }
  }

  void _openPdfFile(String fileUrl) async {
    if (fileUrl.isNotEmpty) {
      try {
        await launch(fileUrl);
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Could not open the PDF file.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid PDF file URL.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class UserData {
  final String userId;
  final String email, matric, name;

  final String sDate,
      eDate,
      compName,
      status,
      zone,
      address,
      postcode,
      industry,
      allowance,
      duration,
      sector,
      letter;

  UserData({
    required this.userId,
    required this.email,
    required this.matric,
    required this.name,
    required this.sDate,
    required this.eDate,
    required this.compName,
    required this.status,
    required this.zone,
    required this.address,
    required this.postcode,
    required this.industry,
    required this.allowance,
    required this.duration,
    required this.sector,
    required this.letter,
  });
}
