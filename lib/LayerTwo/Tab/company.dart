// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';
import 'package:student/LayerTwo/Tab/edit/companyForm.dart';
import 'package:open_filex/open_filex.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
    this.company,
    this.letter,
    this.zone,
    this.monthlyA,
    this.status,
    this.companyAdd,
    this.postcode,
    this.duration,
    this.start,
    this.end,
    required this.onOfferLetterSelected,
  }) : super(key: key);

  final String? company,
      letter,
      zone,
      monthlyA,
      status,
      companyAdd,
      postcode,
      duration,
      start,
      end;
  final void Function(String?) onOfferLetterSelected;

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  late TextEditingController company;
  late TextEditingController letter;
  late TextEditingController zone;
  late TextEditingController monthlyA;
  late TextEditingController status;
  late TextEditingController companyAdd;
  late TextEditingController postcode;
  late TextEditingController duration;
  late TextEditingController start;
  late TextEditingController end;
  Data companyDate = Data();

  @override
  void initState() {
    super.initState();
    company = TextEditingController(text: widget.company ?? '-');
    letter = TextEditingController(text: widget.letter ?? '-');
    zone = TextEditingController(text: widget.zone ?? '-');
    monthlyA = TextEditingController(text: widget.monthlyA ?? '-');
    status = TextEditingController(text: widget.status ?? '-');
    companyAdd = TextEditingController(text: widget.companyAdd ?? '-');
    postcode = TextEditingController(text: widget.postcode ?? '-');
    start = TextEditingController(text: widget.start ?? '-');
    end = TextEditingController(text: widget.end ?? '-');
    duration = TextEditingController(text: widget.duration ?? '-');
  }

  Widget _buildOfferLetter(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        GestureDetector(
          onTap: () {
            Provider.of<Data>(context, listen: false).selectedFile;
            /*(fileDownloadURL) {
              print('Selected offer letter: $fileDownloadURL');
            };*/
            //companyDate.selectedFile;
            //widget.onOfferLetterSelected(companyDate.selectedFile);
            // OpenFilex.open(Provider.of<Data>(context).selectedFile);
          },
          child: const Text(
            'View',
            style: TextStyle(color: Colors.green, fontFamily: 'Futura'),
          ),
        ),
        const SizedBox(height: 50),
      ],
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

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
    companyDate = Provider.of<Data>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(40),
        child: Consumer<Data>(builder: (context, companyDate, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildOfferLetter(
                  'Offer Letter',
                  /*ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                      onPressed: companyDate.selectedFile,
                      child: const Text(
                        'Offer Letter',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Futura'),
                      )),*/
                ),
                _buildDetail2('Placement Status', status.text),
              ]),
              _buildDetail('Zone', dropDownValueZone),
              _buildDetail('Industry', dropDownValueIndustry),
              _buildDetail('Sector', dropDownValueSector),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildDetail('Monthly Allowance', studentData.monthlyA.text),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildDetail('Address', studentData.companyAdd.text),
                _buildDetail2('Postcode', studentData.postcode.text)
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildDetail('Start Date', companyDate.start.text),
                _buildDetail('End Date', companyDate.end.text),
              ]),
              _buildDetail('Duration', companyDate.duration.text),
              const SizedBox(height: 70),
              Row(children: [
                Expanded(
                    child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyForm(
                          initialCompany: company.text,
                          initialLetter: letter.text,
                          initialIndustry: dropDownValueIndustry,
                          initialSector: dropDownValueSector,
                          initialZone: dropDownValueZone,
                          initialAllowance: monthlyA.text,
                          initialStatus: status.text,
                          initialAddress: companyAdd.text,
                          initialPostcode: postcode.text,
                          initialDuration: duration.text,
                          initialStart: start.text,
                          initialEnd: end.text,
                          onOfferLetterSelected: (fileDownloadURL) {
                            print('Selected offer letter: $fileDownloadURL');
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 146, 143, 10),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.edit_rounded,
                      color: Colors.white), // Icon data for elevated button
                  label:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ))
              ]),
            ],
          );
        }),
      ),
    );
  }
}
