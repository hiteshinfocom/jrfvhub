import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'notification_screen.dart';
import 'server_settings_screen.dart';
import 'about_app_screen.dart';

class SettingsScreen extends StatefulWidget {
const SettingsScreen({super.key});

@override
State<SettingsScreen> createState() =>
_SettingsScreenState();
}

class _SettingsScreenState
extends State<SettingsScreen> {

String vendorName = "";
String vendorCode = "";

@override
void initState() {
super.initState();
loadUser();
}

Future<void> loadUser() async {


final user =
    await AuthService.getUser();

debugPrint(
  "SETTINGS USER => $user",
);

setState(() {

  vendorName =
      user["company_name"] ?? "";

  vendorCode =
      user["partycode"] ?? "";
});


}

Future<void> logout() async {

  Get.dialog(

    Dialog(

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(25),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(24),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [

            Container(
              height: 80,
              width: 80,

              decoration: BoxDecoration(
                color: Colors.red
                    .withOpacity(0.1),

                shape:
                    BoxShape.circle,
              ),

              child: const Icon(
                Icons.logout,
                color: Colors.red,
                size: 40,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Logout",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Are you sure you want to logout from JRF Vendor Hub?",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },

                    style:
                        OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(
                        double.infinity,
                        50,
                      ),
                    ),

                    child:
                        const Text(
                      "Cancel",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        () async {

                      Get.back();

                      await AuthService
                          .logout();

                      Get.offAll(
                        () =>
                            const LoginScreen(),
                      );
                    },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red,

                      foregroundColor:
                          Colors.white,

                      minimumSize:
                          const Size(
                        double.infinity,
                        50,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),

                    child:
                        const Text(
                      "Logout",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

@override
Widget build(BuildContext context) {


return Scaffold(
  backgroundColor:
      const Color(0xffF5F7FB),

  appBar: AppBar(
    title: const Text(
      "Settings",
    ),
    centerTitle: true,
  ),

  body: ListView(
    padding:
        const EdgeInsets.all(16),

    children: [

      // HEADER

      Container(
        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          gradient:
              const LinearGradient(
            colors: [
              Color(0xff2563EB),
              Color(0xff1E40AF),
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            20,
          ),
        ),

        child: Column(
          children: [

            CircleAvatar(
              radius: 42,
              backgroundColor:
                  Colors.white,

              child: Text(
                vendorName
                        .isNotEmpty
                    ? vendorName[0]
                        .toUpperCase()
                    : "V",

                style:
                    const TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Colors.blue,
                ),
              ),
            ),

            const SizedBox(
                height: 12),

            Text(
              vendorName.isEmpty
                  ? "Vendor User"
                  : vendorName,

              textAlign:
                  TextAlign.center,

              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 5),

            Text(
              vendorCode.isEmpty
                  ? "Vendor Portal"
                  : "Code : $vendorCode",

              style:
                  const TextStyle(
                color:
                    Colors.white70,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      buildTile(
        icon: Icons.person,
        title: "Profile",
        onTap: () {
          Get.to(
            () =>
                const ProfileScreen(),
          );
        },
      ),

      buildTile(
        icon: Icons.lock,
        title:
            "Change Password",
        onTap: () {
          Get.to(
            () =>
                const ChangePasswordScreen(),
          );
        },
      ),

      buildTile(
        icon:
            Icons.notifications,
        title: "Notifications",
        onTap: () {
          Get.to(
            () =>
                const NotificationScreen(),
          );
        },
      ),

      buildTile(
        icon: Icons.dns,
        title:
            "Server Settings",
        onTap: () {
          Get.to(
            () =>
                const ServerSettingsScreen(),
          );
        },
      ),

      buildTile(
        icon: Icons.info,
        title: "About App",
        onTap: () {
          Get.to(
            () =>
                const AboutAppScreen(),
          );
        },
      ),

      buildTile(
        icon: Icons.support_agent,
        title: "Contact Support",
        onTap: () {

          showDialog(
            context: context,
            builder: (_) => AlertDialog(

              title: const Text(
                "Contact Support",
              ),

              content: const Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Icon(Icons.business),
                      SizedBox(width: 10),
                      Text(
                        "Jupiter Roll Forming Pvt. Ltd.",
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 10),
                      Text(
                        "IT Department",
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 10),
                      Text(
                        "+91 8238977333",
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(Icons.email),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "it@jupiterrollforming.com",
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child:
                      const Text("Close"),
                ),
              ],
            ),
          );
        },
      ),

      buildTile(
        icon: Icons.logout,
        title: "Logout",
        iconColor: Colors.red,
        onTap: logout,
      ),

      const SizedBox(height: 25),

      const Center(
        child: Text(
          "JRF Vendor Hub v1.0.0",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    ],
  ),
);


}

Widget buildTile({
required IconData icon,
required String title,
required VoidCallback onTap,
Color iconColor =
Colors.blue,
}) {


return Card(
  elevation: 1,

  margin:
      const EdgeInsets.only(
    bottom: 12,
  ),

  shape:
      RoundedRectangleBorder(
    borderRadius:
        BorderRadius.circular(
      15,
    ),
  ),

  child: ListTile(

    leading: CircleAvatar(
      backgroundColor:
          iconColor.withOpacity(
        0.15,
      ),

      child: Icon(
        icon,
        color: iconColor,
      ),
    ),

    title: Text(
      title,
      style: const TextStyle(
        fontWeight:
            FontWeight.w600,
      ),
    ),

    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 16,
    ),

    onTap: onTap,
  ),
);

}
}

