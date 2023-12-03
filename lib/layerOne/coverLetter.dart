import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CoverLetter extends StatefulWidget {
  const CoverLetter({Key? key, required String title}) : super(key: key);

  @override
  _CoverLetterState createState() => _CoverLetterState();
}

class _CoverLetterState extends State<CoverLetter> {
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  DateTime selectedDate = DateTime.now();

  DateTime? startDate;
  DateTime? endDate;

  Widget _name({required String name}) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(name,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold))
          ],
        ),
      );

  Widget _matricNo({required String matricNo}) => Container(
        child: Column(
          children: [
            Text(
              matricNo,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Future<void> _startDate(BuildContext context) async {
    final DateTime? spicked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2040));
    if (spicked != null && spicked != selectedDate) {
      setState(() {
        selectedDate = spicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color:
                    Colors.black87.withOpacity(0.7), // Use the specified color
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Cover Letter',
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
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Name',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          )),
                                      _name(name: 'Zahra Fathanah'),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('Matric No',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54)),
                                      _matricNo(matricNo: '2019050'),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                        const Divider(),
                        const SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Date',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Futura'),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: start,
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
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  labelText: 'Start Date',
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickedDate != null &&
                                      pickedDate != startDate) {
                                    setState(() {
                                      startDate = pickedDate;
                                      start.text = DateFormat('dd MMMM yyyy')
                                          .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ]),
                        const SizedBox(height: 15),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'End Date',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Futura'),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: end,
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
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  labelText: 'End Date',
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: startDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                  );

                                  if (pickedDate != null &&
                                      pickedDate != endDate) {
                                    setState(() {
                                      endDate = pickedDate;
                                      end.text = DateFormat('dd MMMM yyyy')
                                          .format(pickedDate);
                                    });
                                  }
                                },
                              ),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showIns(context);
                                      },
                                      child: const Icon(
                                        Icons.info,
                                        size: 30,
                                        color: Color.fromRGBO(148, 112, 18, 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                send();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(148, 112, 18, 1),
                                  minimumSize: const Size.fromHeight(50)),
                              icon: const Icon(
                                  Icons.email), //icon data for elevated button
                              label: const Text("Request"), //label text
                            ))
                      ])))),
        ));
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    const TextSpan(
                      text: '1. ',
                    ),
                    TextSpan(
                        text: 'IMPORTANT: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800])),
                    const TextSpan(
                      text: 'Read the ',
                    ),
                    const TextSpan(
                        text: 'FAQ Section ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(
                      text:
                          'on procedures of IAP Cover Letter first before generating the Cover Letter ',
                    ),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    TextSpan(
                      text: '2. Print the letter using a ',
                    ),
                    TextSpan(
                        text: 'laser print ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'on  ',
                    ),
                    TextSpan(
                        text: 'A4 ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'size ',
                    ),
                    TextSpan(
                        text: '(80gsm).',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ])),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: RichText(
                  text: const TextSpan(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: 'Futura'),
                      children: [
                    TextSpan(
                      text:
                          '3. The department will not responsible for any incorrect information that you make, especially the ',
                    ),
                    TextSpan(
                        text: 'START',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'and  ',
                    ),
                    TextSpan(
                        text: 'END ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: 'dates.',
                    ),
                  ])),
            ),
          ]),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void send() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.done_all_rounded,
                    size: 110,
                    color: Colors.green[800],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: Text(
                    'Thank You',
                    textAlign: TextAlign.center, //<-- Center text here
                    style: TextStyle(
                      color: Color.fromRGBO(148, 112, 18, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  child: Text(
                    'Please check your Email for the requested cover letter',
                    textAlign: TextAlign.center, //<-- Center text here
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                ),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Futura',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
