import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/companyForm.dart';

class Company extends StatefulWidget {
  const Company({
    Key? key,
    this.company,
    this.letter,
    this.zone,
    this.monthlyA,
    this.status,
    this.address,
    this.postcode,
    this.duration,
    this.start,
    this.end,
  }) : super(key: key);

  final String? company,letter,zone,monthlyA,status,address,postcode,duration,start,end;

  @override
  _CompanyState createState() => _CompanyState();
}

class _CompanyState extends State<Company> {
  late TextEditingController company =
      TextEditingController(text: widget.company ?? '-');
  late TextEditingController letter =
      TextEditingController(text: widget.letter ?? '-');
  late TextEditingController zone =
      TextEditingController(text: widget.zone ?? '-');
  late TextEditingController monthlyA =
      TextEditingController(text: widget.monthlyA ?? '-');
  late TextEditingController status =
      TextEditingController(text: widget.status ?? '-');
  late TextEditingController address =
      TextEditingController(text: widget.address ?? '-');
  late TextEditingController postcode =
      TextEditingController(text: widget.postcode ?? '-');
  late TextEditingController duration =
      TextEditingController(text: widget.duration ?? '-');
  late TextEditingController start =
      TextEditingController(text: widget.status ?? '-');
  late TextEditingController end =
      TextEditingController(text: widget.status ?? '-');

  @override
  void initState() {
    super.initState();
    company = TextEditingController(text: widget.company ?? '-');
    letter = TextEditingController(text: widget.letter ?? '-');
    zone = TextEditingController(text: widget.zone ?? '-');
    monthlyA = TextEditingController(text: widget.monthlyA ?? '-');
    status = TextEditingController(text: widget.monthlyA ?? '-');
    address = TextEditingController(text: widget.address ?? '-');
    postcode = TextEditingController(text: widget.postcode ?? '-');
    duration = TextEditingController(text: widget.duration ?? '-');
    start = TextEditingController(text: widget.start ?? '-');
    end = TextEditingController(text: widget.end ?? '-');
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
    return SingleChildScrollView(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Offer Letter', letter.text),
              _buildDetail2('Zone', dropDownValueZone)
            ]),
            _buildDetail('Industry', dropDownValueIndustry),
            _buildDetail('Sector', dropDownValueSector),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Monthly Allowance', monthlyA.text),
              _buildDetail2('Placement Status', status.text)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Address', address.text),
              _buildDetail2('Postcode', postcode.text)
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildDetail('Start Date', start.text),
              _buildDetail2('End Date', end.text),
            ]),
            _buildDetail('Duration', duration.text),
            const SizedBox(height: 50),
            Container(
                child: Row(children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyForm(
                          initialCompany: company.text,
                          initialIndustry: dropDownValueIndustry,
                          initialSector: dropDownValueSector,
                          initialZone: dropDownValueZone,
                          initialAllowance: monthlyA.text,
                          initialStatus: status.text,
                          initialAddress: address.text,
                          initialPostcode: postcode.text,
                          initialDuration: duration.text,
                          initialStart: start.text,
                          initialEnd: end.text),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      print('Result: $result');
                      company.text = result['company'] ?? '-';
                      dropDownValueIndustry = result['industry'] ?? '-';
                      dropDownValueSector = result['sector'] ?? '-';
                      dropDownValueZone = result['zone'] ?? '-';
                      address.text = result['address'] ?? '-';
                      postcode.text = result['postcode'] ?? '-';
                      monthlyA.text = result['monthlyA'] ?? '-';
                      start.text = result['start'] ?? '-';
                      end.text = result['end'] ?? '-';
                      duration.text = result['duration'] ?? '-';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(
                    Icons.edit_rounded), // Icon data for elevated button
                label: const Text("Edit"),
              ))
            ])),
          ],
        ),
      ),
    );
  }
}
