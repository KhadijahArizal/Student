import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:student/LayerTwo/Tab/data.dart';

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
  TextEditingController svname = TextEditingController();
  TextEditingController svemail = TextEditingController();
  TextEditingController svcontact = TextEditingController();

  @override
  void initState() {
    super.initState();
    svname.text = widget.initialSupervisor ?? '-';
    svemail.text = widget.initialEmail ?? '-';
    svcontact.text = widget.initialContact ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    var studentData = Provider.of<Data>(context);
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
                color: Color.fromRGBO(0, 146, 143, 10), size: 30)),
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
                  child: Consumer<Data>(builder: (context, Data, child) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: [
                                    TextFormField(
                                      key: UniqueKey(),
                                      controller: studentData.svname,
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
                                      key: UniqueKey(),
                                      controller: studentData.svemail,
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
                                      key: UniqueKey(),
                                      controller: studentData.svcontact,
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
                                        User? user =
                                            FirebaseAuth.instance.currentUser;

                                        if (user != null) {
                                          String userId = user.uid;
                                          DatabaseReference userRef =
                                              FirebaseDatabase.instance
                                                  .ref('Student')
                                                  .child('Supervisor Details')
                                                  .child(userId);

                                          userRef.set({
                                            'Supervisor Name':
                                                studentData.svname.text,
                                            'Contact No':
                                                studentData.svcontact.text,
                                            'Email': studentData.svemail.text,
                                            'userId': userId
                                          });
                                          Navigator.pushNamed(
                                              context, '/placements');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              0, 146, 143, 10),
                                          minimumSize:
                                              const Size.fromHeight(50)),
                                      child: const Text('Save',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ))
                                  ]))
                        ]);
                  }),
                )))));
  }
}
