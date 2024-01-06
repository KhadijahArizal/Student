import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Help extends StatefulWidget {
  const Help({Key? key, required String title}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 25,
              color: Color.fromRGBO(0, 146, 143, 10), // Use the specified color
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Help',
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
            color: Color.fromRGBO(0, 146, 143, 10),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  // Title for 'IAP Cover Letter'
                  ExpansionTile(
                    title: const Text(
                      'IAP Cover Letter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Container(
                        height: 300,
                        child: const PDFView(
                          filePath: 'assets/Help/iap_cover_letter.pdf',
                          autoSpacing: true,
                          pageFling: true,
                          swipeHorizontal: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ExpansionTile(
                    title: const Text(
                      'IAP Placement Verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Container(
                        height: 300, // Adjust the height as needed
                        child: const PDFView(
                          filePath:
                              'assets/Help/iap_placement_verification.pdf',
                          autoSpacing: true,
                          pageFling: true,
                          swipeHorizontal: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
