import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("About App"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2563EB),
                    Color(0xff1E40AF),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(20),
              ),

              child: const Column(
                children: [

                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.precision_manufacturing,
                      size: 45,
                      color: Colors.blue,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "JRF Vendor Hub",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Vendor Management System",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),

              child: const Padding(
                padding:
                    EdgeInsets.all(16),

                child: Column(
                  children: [

                    ListTile(
                      leading: Icon(
                        Icons.verified,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Version",
                      ),
                      subtitle: Text(
                        "1.0.0",
                      ),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(
                        Icons.business,
                        color: Colors.blue,
                      ),
                      title: Text(
                        "Company",
                      ),
                      subtitle: Text(
                        "Jupiter Roll Form Machines Pvt. Ltd.",
                      ),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(
                        Icons.code,
                        color: Colors.orange,
                      ),
                      title: Text(
                        "Developed By",
                      ),
                      subtitle: Text(
                        "IT Department",
                      ),
                    ),

                    Divider(),

                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.green,
                      ),
                      title: Text(
                        "Support",
                      ),
                      subtitle: Text(
                        "+91 82389 77333",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),

              child: const Padding(
                padding:
                    EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      "About Application",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "JRF Vendor Hub is a vendor portal application used for managing Job Work, Purchase Orders, Dispatch, Ready Material, Payments and Vendor Communication.",
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "© 2026 Jupiter Roll Form Machines Pvt. Ltd.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}