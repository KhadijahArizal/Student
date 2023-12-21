import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/faq.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/LayerTwo/help.dart';
import 'package:student/Service/auth_service.dart';
import 'package:student/SignIn/SignIn.dart';
import '../layerOne/coverLetter.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

class sideNav2 extends StatelessWidget {
  final String studentStatus;

  const sideNav2({required this.studentStatus});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Drawer(
      backgroundColor: Colors.white,
      child: Material(
          color: Colors.white,
          child: ListView(children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 146, 143, 10),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Center the items horizontally
                children: [
                  Image.asset(
                    'assets/iium.png', // Your image asset
                    height: 50, // Adjust the height as needed
                    width: 50, // Adjust the width as needed
                  ),
                  const SizedBox(
                      width: 10), // Add spacing between the image and text
                  const Text(
                    'i-KICT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Futura',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'Cover Letter',
                icon: Icons.email_rounded,
                onClicked: (() => selectedItem(context, 0))),
            const SizedBox(
              height: 10,
            ),
            Visibility(
                child: buildMenuItem(
                    text: 'Placements',
                    icon: Icons.place_rounded,
                    onClicked: (() => selectedItem(context, 1)))),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'FAQ',
                icon: Icons.question_answer_rounded,
                onClicked: (() => selectedItem(context, 2))), //_visible = false
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'Help',
                icon: Icons.help_center_rounded,
                onClicked: (() => selectedItem(context, 3))),
            const SizedBox(
              height: 15,
            ),
            const Divider(
              color: Colors.black54,
            ),
            buildMenuItem(
              text: 'Logout',
              icon: Icons.exit_to_app_rounded,
              onClicked: () async {
                try {
                  await authService.handleSignOut();
                  // Navigate to the sign-in page or any other desired page after logout
                  Navigator.of(context).pop(); // Close the drawer
                  // Navigate to the sign-in page or any other desired page after logout
                  // For example, you can use Navigator to go to the sign-in page:
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        SignIn(), // Replace with your sign-in page
                  ));
                  // Display the success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('YEAYY! Logout'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print("Error during logout: $e");
                }
              },
            ),
          ])),
    );
  }

  Widget buildMenuItem(
      {required String text, required IconData icon, VoidCallback? onClicked}) {
    const hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(
          icon,
          color: const Color.fromRGBO(0, 168, 80, 10),
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontFamily: 'Futura'),
        ),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const CoverLetter(title: 'Cover Letter'),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Placements(
            title: 'Placements',
            companyName: '',
          ),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FAQ(title: 'FAQ'),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Help(title: 'Help'),
        ));
        break;
    }
  }
}
