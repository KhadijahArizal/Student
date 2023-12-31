// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:student/Service/auth_service.dart';
import 'package:student/layerOne/iapForm.dart';
import 'package:student/layerOne/announcement.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false));

class sideNav1 extends StatelessWidget {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Material(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
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
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'Announcements and Quick Reminder',
                icon: Icons.book,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 10),
            buildMenuItem(
                text: 'IAP Application',
                icon: Icons.app_registration,
                onClicked: () => selectedItem(context, 1)),
            const Spacer(), // Add Spacer to push "Quit" button to the bottom
            const Divider(
              color: Colors.black54,
            ),
          ],
        ),
      ),
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

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Announcement(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IapForm(),
        ));
        break;
    }
  }
}
