/*import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key, required String title}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  late PDFDocument _coverLetterPdfDocument;
  late PDFDocument _placementVerificationPdfDocument;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPDFs();
  }

  void loadPDFs() async {
    try {
      _coverLetterPdfDocument =
          await PDFDocument.fromAsset('assets/Help/iap_cover_letter.pdf');
      _placementVerificationPdfDocument = await PDFDocument.fromAsset(
          'assets/Help/iap_placement_verification.pdf');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDFs: $e');
    }
  }

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
            'FAQ',
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
          padding: const EdgeInsets.all(20),
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
                      // PDF viewer for 'IAP Cover Letter'
                      SizedBox(
                        height: 300, // Adjust the height as needed
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PDFViewer(
                                document: _coverLetterPdfDocument,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Add some spacing

                  // Title for 'IAP Placement Verification'
                  ExpansionTile(
                    title: const Text(
                      'IAP Placement Verification',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      // PDF viewer for 'IAP Placement Verification'
                      SizedBox(
                        height: 300, // Adjust the height as needed
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PDFViewer(
                                document: _placementVerificationPdfDocument,
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
*/