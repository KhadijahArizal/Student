import 'package:flutter/material.dart';
import 'package:student/LayerTwo/Tab/edit/companyForm.dart';

class Company extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white.withOpacity(0.1),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offer Letter',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  'Zone',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              'Monthly Allowance',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const Text('RM', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 50),
            const Text(
              'Placement Verification Status',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 50),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                Text(
                  'Postcode',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  width: 10,
                  color: const Color.fromRGBO(148, 112, 18, 1),
                ),
                color: const Color.fromRGBO(148, 112, 18, 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Column(
                        children: [
                          Text(
                            'Duration',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Column(
                        children: [
                          Text(
                            'Start Date',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Column(
                        children: [
                          Text(
                            'End Date',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Container(
                alignment: Alignment.bottomRight,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Expanded(
                      child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyForm(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(148, 112, 18, 1),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(
                        Icons.edit_rounded), // Icon data for elevated button
                    label: const Text("Edit"),
                  ))
                ])),
          ],
        ),
      ),
    );
  }
}
