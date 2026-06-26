import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/chat_service.dart';
import 'chat_screen.dart';

class ChatBotScreen extends StatelessWidget {

  final int vendorId;

  const ChatBotScreen({
    super.key,
    required this.vendorId,
  });

  Future<void> openDepartment(
    String department,
  ) async {

    try {

      final roomId =
          await ChatService()
              .createRoom(
        vendorId: vendorId,
        department: department,
      );

      Get.to(
        () => ChatScreen(
          title: department,
          roomId: roomId,
          vendorId: vendorId,
        ),
      );

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor:
            Colors.red,
        colorText:
            Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xfff4f7fc,
      ),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,

        title: const Text(
          "Support Center",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          16,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            Container(

              width:
                  double.infinity,

              padding:
                  const EdgeInsets
                      .all(
                20,
              ),

              decoration:
                  BoxDecoration(

                gradient:
                    const LinearGradient(
                  colors: [
                    Color(
                        0xff2563eb),
                    Color(
                        0xff4f46e5),
                  ],
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  20,
                ),
              ),

              child:
                  const Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(
                    "👋 Welcome",
                    style:
                        TextStyle(
                      color:
                          Colors
                              .white,
                      fontSize:
                          24,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Select department to start chatting.",
                    style:
                        TextStyle(
                      color: Colors
                          .white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            const Text(
              "Departments",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            departmentCard(
              icon: Icons
                  .shopping_bag_outlined,
              title:
                  "Purchase Department",
              subtitle:
                  "Purchase Orders & Material",
              color:
                  Colors.blue,
            ),

            departmentCard(
              icon: Icons
                  .precision_manufacturing,
              title:
                  "Job Work Department",
              subtitle:
                  "Production & Job Work",
              color:
                  Colors.orange,
            ),

            departmentCard(
              icon: Icons
                  .local_shipping_outlined,
              title:
                  "Dispatch Department",
              subtitle:
                  "Delivery & Dispatch",
              color:
                  Colors.green,
            ),

            departmentCard(
              icon: Icons
                  .account_balance_wallet,
              title:
                  "Accounts Department",
              subtitle:
                  "Payment & Ledger",
              color:
                  Colors.purple,
            ),

            departmentCard(
              icon:
                  Icons.support_agent,
              title:
                  "Management",
              subtitle:
                  "Escalation Support",
              color:
                  Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget departmentCard({

    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,

  }) {

    return Card(

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      elevation: 2,

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: ListTile(

        contentPadding:
            const EdgeInsets.all(
          12,
        ),

        leading: Container(

          padding:
              const EdgeInsets.all(
            12,
          ),

          decoration:
              BoxDecoration(

            color: color.withOpacity(
              .15,
            ),

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(
          subtitle,
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),

        onTap: () {
          openDepartment(
            title,
          );
        },
      ),
    );
  }
}
