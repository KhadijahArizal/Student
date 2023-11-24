import 'package:flutter/material.dart';
import 'package:student/layerOne/announcement.dart';

class Passphrase extends StatefulWidget {
  const Passphrase({Key? key}) : super(key: key);

  @override
  _PassphraseState createState() => _PassphraseState();
}

final _pass = GlobalKey<FormState>();

class _PassphraseState extends State<Passphrase> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,size: 25),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(70),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/iium.png')),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'I-KICT',
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 112, 18, 1),
                                  fontSize: 60,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Playfair Display',
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Industrial Attachment Programme Dashboard',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontFamily: 'Futura',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ]),
                      ]),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Column(children: [
                        const Text(
                          'Enter Passphrase',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontFamily: 'Futura',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Padding(
                                padding: const EdgeInsets.all(5),
                                child: TextFormField(
                                  obscureText: passwordVisible,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                    fillColor: Colors.grey[100],
                                    filled: true,
                              alignLabelWithHint: false,
                                    prefixIcon:
                                        const Icon(Icons.note_alt_rounded),
                                    hintText:
                                        "Passphrase",
                                        suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                                  ),
                                )),                        
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Announcement(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(148, 112, 18, 1),
                            minimumSize:
                                const Size(double.infinity, 50), // Set button width
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Futura'),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ])),
      ),
    );
  }
}
