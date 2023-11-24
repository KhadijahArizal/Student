import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/faq.dart';
import 'package:student/LayerTwo/lidv.dart';
import 'package:student/LayerTwo/settings.dart';
import '../layerOne/coverLetter.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

class sideNav2 extends StatelessWidget {
   final String studentStatus; // Accept studentStatus as an optional parameter

  // Constructor that accepts studentStatus (optional)
  const sideNav2({required this.studentStatus});

  @override
  Widget build(BuildContext context) {
 bool isVisible = studentStatus == 'Active'; // Determine if LIDV menu should be visible

    return Drawer(
      backgroundColor: Colors.white,
      child: Material(
          color: Colors.white,
          child: ListView(children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(148, 112, 18, 10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Center the items horizontally
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
               visible: isVisible, // Pass visibility condition to buildMenuItem
              child: buildMenuItem(
                    text: 'LIDV',
                    icon: Icons.home_filled,
                    onClicked: (() => selectedItem(context, 1)))),
                const SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                    text: 'FAQ',
                    icon: Icons.question_answer_rounded,
                    onClicked: (() =>
                        selectedItem(context, 2))), //_visible = false
                const SizedBox(
                  height: 10,
                ),
                buildMenuItem(
                    text: 'Settings',
                    icon: Icons.settings,
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
                  onClicked: () => SystemNavigator.pop(),
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
          color: const Color.fromRGBO(148, 112, 18, 10),
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
          builder: (context) => const LIDV(title: 'LIDV'),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FAQ(title: 'FAQ'),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Settings(title: 'Settings'),
        ));
        break;
    }
  }
}
