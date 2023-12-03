import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupervisorForm extends StatefulWidget {
  const SupervisorForm({
    Key? key,
    this.initialSupervisor,
    this.initialEmail,
    this.initialContact,
  }) : super(key: key);

  final String? initialSupervisor, initialEmail, initialContact;

  @override
  _SupervisorFormState createState() => _SupervisorFormState();
}

class _SupervisorFormState extends State<SupervisorForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController supervisor = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSupervisor != null) {
      supervisor.text = widget.initialSupervisor ?? '-';
      email.text = widget.initialEmail ?? '-';
      contact.text = widget.initialContact ?? '-';
    }
  }

  void goSupervisor() {
    Navigator.pop(context, {
      'supervisor': supervisor.text,
      'email': email.text,
      'contact': contact.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
        appBar: AppBar(
            title: const Text(
              'Supervisor Details',
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Futura'),
            ),
            leading: IconButton(
              icon: Icon(
                size: 25,
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData(
                color: Color.fromRGBO(148, 112, 18, 1), size: 30)),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Form(
                                key: _formKey,
                                child: Column(children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        supervisor.text = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.person_rounded),
                                      labelText: 'Supervisor Name',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        email.text = value;
                                      });
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.email_rounded),
                                      labelText: 'Email',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        contact.text = value;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      fillColor: Colors.grey[100],
                                      filled: true,
                                      prefixIcon:
                                          const Icon(Icons.call_rounded),
                                      labelText: 'Contact No',
                                    ),
                                  ),
                                ]))),
                        const SizedBox(height: 25),
                        Container(
                            alignment: Alignment.bottomRight,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {
                                      goSupervisor();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            148, 112, 18, 1),
                                        minimumSize: const Size.fromHeight(50)),
                                    child: const Text('Save'),
                                  ))
                                ]))
                      ]),
                )))));
  }
}
