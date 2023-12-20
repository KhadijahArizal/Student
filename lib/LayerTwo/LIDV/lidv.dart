import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/LIDV/lidvEdit.dart';

class LIDV extends StatefulWidget {
  const LIDV({
    Key? key,
    required String title,
    this.name,
    this.sem,
    this.session,
    this.mahallah,
    this.block,
    this.room,
  }) : super(key: key);

  final String? name, sem, session, mahallah, block, room;

  @override
  _LIDVState createState() => _LIDVState();
}

class _LIDVState extends State<LIDV> {
  late TextEditingController name =
      TextEditingController(text: widget.name ?? '-');
  late TextEditingController sem =
      TextEditingController(text: widget.sem ?? '-');
  late TextEditingController session =
      TextEditingController(text: widget.session ?? '-');
  late TextEditingController mahallah =
      TextEditingController(text: widget.mahallah ?? '-');
  late TextEditingController block =
      TextEditingController(text: widget.block ?? '-');
  late TextEditingController room =
      TextEditingController(text: widget.room ?? '-');

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.name ?? '-');
    sem = TextEditingController(text: widget.sem ?? '-');
    session = TextEditingController(text: widget.session ?? '-');
    mahallah = TextEditingController(text: widget.mahallah ?? '-');
    block = TextEditingController(text: widget.block ?? '-');
    room = TextEditingController(text: widget.room ?? '-');
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

  Widget _buildDetail2(String label, String value, String value2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        Row(
          children: [
          Text(
          value,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(width:5),
        Text(
          value2,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        )]),
        const SizedBox(height: 50),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.name}');
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              size: 25,
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87.withOpacity(0.7), // Use the specified color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'LIDV',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                fontFamily: 'Futura'),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(
            color: Color.fromRGBO(148, 112, 18, 1),
            size: 30,
          )),
      body: SafeArea(
        
          child: Container(
              padding: const EdgeInsets.all(10),
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
                            Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildDetail('Name', name.text),
                                    _buildDetail('Name', '${widget.name}'),
                                    
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  children: [
                                    _buildDetail2('Semester', dropDownValueSemL, dropdownValueSession),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _buildDetail(
                                        'Mahallah', dropDownValueMahallah),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildDetail('Block', block.text),
                                    _buildDetail('Room No', room.text),
                                  ]),
                            ]),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Tooltip(
                                    message: '',
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showIns(context);
                                          },
                                          child: const Icon(
                                            Icons.info,
                                            size: 30,
                                            color:
                                                Color.fromRGBO(148, 112, 18, 1),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 70),
                            Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => lidvEdit(
                                                  initialName: name.text,
                                                  initialSem: dropDownValueSemL,
                                                  initialSession:
                                                      dropdownValueSession,
                                                  initialMahallah:
                                                      dropDownValueMahallah,
                                                  initialBlock: block.text,
                                                  initialRoom: room.text),
                                            ),
                                          );

                                          if (result != null) {
                                            setState(() {
                                              print(
                                                  'Result from FinalReportUpload: $result');
                                              name.text = result['name'] ?? '-';
                                              dropDownValueSemL =
                                                  result['sem'] ?? '-';
                                              dropdownValueSession =
                                                  result['session'] ?? '-';
                                              dropDownValueMahallah =
                                                  result['mahallah'] ?? '-';
                                              block.text =
                                                  result['block'] ?? '-';
                                              room.text = result['room'] ?? '-';
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              148, 112, 18, 1),
                                          minimumSize:
                                              const Size.fromHeight(50),
                                        ),
                                        child: const Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))
                                    ]))
                          ]))))),
    );
  }

  void showIns(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Instructions',
            style: TextStyle(
              color: Colors.red[800],
              fontSize: 17,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura',
            ),
          ),
          content: Column(children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '1. LIDV supporting letter is ',
                  ),
                  TextSpan(
                    text: 'STRICTLY ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Industrial Attachment Programme purposes. ',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '2. Make sure you already secured a placement and it is ',
                  ),
                  TextSpan(
                    text: 'VERIFIED ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'before requesting LIDV(refer to "Placement" menu). ',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '3. Use the  ',
                  ),
                  TextSpan(
                    text: 'emailed supporting letter ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'for mahallah registration (Manual).',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '4. Your application will be sent to RSD for notification and any inquiries please refer to RSD and respective Mahallah.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '5. The Department will not be responsible for ',
                  ),
                  TextSpan(
                    text: 'any incorrect information and failures ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'to secure LIDV.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '6. ',
                  ),
                  TextSpan(
                    text: 'Print ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'the emailed supporting letter using ',
                  ),
                  TextSpan(
                    text: 'a Laser Printed on A4 Size (80gsm).',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ]),
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
}
