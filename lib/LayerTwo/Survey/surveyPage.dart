// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/summary.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _question1Controller = TextEditingController();
  final TextEditingController _question2Controller = TextEditingController();
  final TextEditingController _question3Controller = TextEditingController();
  final TextEditingController _question4Controller = TextEditingController();
  final TextEditingController _question5Controller = TextEditingController();
  int _rating = 0;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late User? user = FirebaseAuth.instance.currentUser;

  // Survey
  late DatabaseReference _surveyRef;
  late Future<List<SurveyData1>> _surveyFuture;

  @override
  void initState() {
    super.initState();
    checkSurveyStatus();
    if (user != null) {
      _surveyRef =
          FirebaseDatabase.instance.ref('Student').child('Student Survey');
      _surveyFuture = _fetchSvsurveyData();
    }
  }

  Future<List<SurveyData1>> _fetchSvsurveyData() async {
    List<SurveyData1> userDataList1 = [];
    try {
      DataSnapshot surveySnapshot =
          await _surveyRef.once().then((event) => event.snapshot);
      Map<dynamic, dynamic>? surveyData =
          surveySnapshot.value as Map<dynamic, dynamic>?;

      if (surveyData != null) {
        surveyData.forEach((key, value) {
          if (value is Map<dynamic, dynamic> && key == userId) {
            SurveyData1 survey = SurveyData1(
              userId: userId,
            );
            userDataList1.add(survey);
          }
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    print(userDataList1);
    return userDataList1;
  }

  Future<void> checkSurveyStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      DatabaseReference surveyRef = FirebaseDatabase.instance
          .ref('Student')
          .child('Student Survey')
          .child(userId);

      DataSnapshot surveySnapshot =
          await surveyRef.once().then((event) => event.snapshot);

      Map<dynamic, dynamic>? surveyData =
          surveySnapshot.value as Map<dynamic, dynamic>?;

      if (surveyData != null) {
        // The survey has been submitted, show the SurveyReview pop-up dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<SurveyData1>>(
                      future: _surveyFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromRGBO(0, 146, 143, 10),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              const Text(
                                'Survey Has been Submitted',
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 146, 143, 10),
                                  fontSize: 17,
                                ),
                              ),
                              const Text(
                                'Do you want to edit the survey?',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const Summary(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'No',
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 146, 143, 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SurveyPage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(0, 146, 143, 10),
                                    ),
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Survey',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            fontFamily: 'Futura',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            size: 25,
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87.withOpacity(0.7),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Summary()),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
            color: Color.fromRGBO(0, 146, 143, 10), size: 30),
      ),
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
                Colors.white30.withOpacity(0.2),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildQuestionTextField(
                  1,
                  'What is the most important thing that you learnt from your Industrial Attachment Programme?',
                  _question1Controller,
                ),
                const SizedBox(height: 20),
                _buildQuestionTextField(
                  2,
                  'What do you wish you had spent more time doing during your Industrial Attachment Programme? (Describe and specify project or task given)',
                  _question2Controller,
                ),
                const SizedBox(height: 20),
                _buildQuestionTextField(
                  3,
                  'On what part of the project did you do your best work during your Industrial Attachment Programme?',
                  _question3Controller,
                ),
                const SizedBox(height: 20),
                _buildQuestionTextField(
                  4,
                  'What are the comments and suggestions that you have for our Industrial Attachment Programme?',
                  _question4Controller,
                ),
                const SizedBox(height: 20),
                _buildQuestionTextField(
                  5,
                  'Have you been offered a job with the company? If yes, state the job position. If you declined the job offer, state the reason for your decline.',
                  _question5Controller,
                ),
                const SizedBox(height: 20),
                _buildRatingQuestion(),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            _submitSurvey();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(0, 146, 143, 10),
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionTextField(
    int questionNumber,
    String question,
    TextEditingController controller,
  ) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 6,
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$questionNumber. $question',
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller,
                maxLines: 3,
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
                  hintText: 'Your answer here...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingQuestion() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '6. Rate your overall Industrial Attachment Programme',
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 1; i <= 5; i++)
                EmoticonRadioButton(
                  value: i,
                  groupValue: _rating,
                  onChanged: (int? value) {
                    setState(() {
                      _rating = value!;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitSurvey() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userId = user.uid;

      DatabaseReference userRef = FirebaseDatabase.instance
          .ref('Student')
          .child('Student Survey')
          .child(userId);

      userRef.set({
        'Student ID': userId,
        'important thing that you learnt': _question1Controller.text,
        'you wish you had spent more time doing': _question2Controller.text,
        'your best work during internship': _question3Controller.text,
        'comments and suggestions for IAP': _question4Controller.text,
        'offered a job': _question5Controller.text,
        'rating': _rating,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<List<SurveyData1>>(
                    future: _surveyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(0, 146, 143, 10),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Survey Has been Submitted',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 146, 143, 10),
                                fontSize: 17,
                              ),
                            ),
                            const Text(
                              'Do you want to edit the survey?',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 146, 143, 10),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SurveyPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(0, 146, 143, 10),
                                  ),
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }
}

class EmoticonRadioButton extends StatelessWidget {
  final int value;
  final int? groupValue;
  final ValueChanged<int?>? onChanged;

  const EmoticonRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(value),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value == groupValue
              ? Colors.yellow[800]
              : const Color.fromRGBO(0, 146, 143, 10),
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: getEmoticon(value),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getEmoticon(int value) {
    switch (value) {
      case 1:
        return '1'; // Sad
      case 2:
        return '2'; // Neutral
      case 3:
        return '3'; // Happy
      case 4:
        return '4'; // Very Happy
      case 5:
        return '5'; // Extremely Happy
      default:
        return '';
    }
  }
}

class SurveyData1 {
  final String userId;

  SurveyData1({
    required this.userId,
  });
}
