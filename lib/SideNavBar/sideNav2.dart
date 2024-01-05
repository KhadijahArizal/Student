// ignore_for_file: use_build_context_synchronously, deprecated_member_use, unused_element, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Detect%20Status/statusManagament.dart';
import 'package:student/LayerTwo/placements.dart';
import 'package:student/Service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../layerOne/coverLetter.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

bool _isVisible = true;

class sideNav2 extends StatelessWidget {
  final StatusManagement _statusManagement =
      StatusManagement();
      final StatusManagement statusManagement;

  sideNav2({Key? key,required this.statusManagement});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    _statusManagement.statusStream.listen((String status) {
      _isVisible = (status == 'Active');
      print('Status changed: $_isVisible'); // For debugging
    });

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
            buildMenuItem(
                text: 'Placements',
                icon: Icons.place_rounded,
                onClicked: (() => selectedItem(context, 1))),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
                text: 'Help',
                icon: Icons.help_rounded,
                onClicked: (() => selectedItem(context, 2))),
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
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/auth');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('YEAYY! Logout'),
                      duration: Duration(seconds: 2),
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
          color: const Color.fromRGBO(0, 146, 143, 10),
        ),
        title: Text(
          text,
          style: const TextStyle(color: Colors.black87, fontFamily: 'Futura'),
        ),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  void launchExternalLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        launchExternalLink(
          'https://drive.google.com/drive/folders/1jE8IUkj4N06JNa4yqLSLs4XUHJRMVHfn?usp=sharing',
        );
        break;
    }
  }
}
