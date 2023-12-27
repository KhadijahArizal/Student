import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/Screen/Announcements/announcements.dart';
import 'package:supervisor/Screen/FinalReport/studentFinalReport.dart';
import 'package:supervisor/Screen/Monthly/studentMonthlyReport.dart';
import 'package:supervisor/Screen/StudentList/studentDetails.dart';
import 'package:supervisor/Screen/Summary.dart';
import 'package:supervisor/Screen/StudentList/studentList.dart';
import 'package:supervisor/Screen/data.dart';
import 'package:supervisor/SignIn/SignIn.dart';
import 'package:supervisor/SignIn/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDW17txVZK6rztMZDkUbxdKm2dPg1RysCI",
          authDomain: "ikict-f49f6.firebaseapp.com",
          databaseURL: "https://ikict-f49f6-default-rtdb.firebaseio.com",
          projectId: "ikict-f49f6",
          storageBucket: "ikict-f49f6.appspot.com",
          messagingSenderId: "753383357173",
          appId: "1:753383357173:web:8ed039663a24205f9fe3bc",
          measurementId: "G-0LXK2QRZMH"));

  Data dataInstance = Data();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: dataInstance)
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iKICT | Supervisor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 146, 143, 10),
        fontFamily: 'Futura',
      ),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/signIn': (context) => const SignIn(),
        '/summary': (context) => const Summary(title: 'Summary'),
        '/student_list': (context) =>
            const StudentList(title: 'List of Students'),
        '/announc': (context) => const Announc(title: 'Announcements'),
        '/student_details': (context) => StudentDetails(
              title: 'Student Details',
              studentName: '',
              Matric: '',
              status: '',
              onStatusChanged: (String) {},
            ),
        '/monthly': (context) =>
            const SMonthlyReport(title: 'Student Monthly Report'),
        '/final': (context) => const SFinalReport(title: 'Student Final Report')
      },
    );
  }
}
