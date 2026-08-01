import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/dashboard/notification_screen.dart';
import '../../screens/jobwork/JobWorkScreen.dart';
import '../../screens/planning/planning_screen.dart';
import '../../screens/purchase_orders/purchase_order_screen.dart';
import '../../screens/ready_items/ready_stock_screen.dart';
import '../../screens/dispatch/dispatch_screen.dart';
import '../../screens/dashboard/qr_login.dart';

class SideProfileDrawer extends StatelessWidget {
  final String companyName;
  final String vendorCode;
  final String gstNo;
  final String contactPerson;
  final String mobile;
  final String email;

  const SideProfileDrawer({
    super.key,
    required this.companyName,
    required this.vendorCode,
    required this.gstNo,
    required this.contactPerson,
    required this.mobile,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffF8FAFC),

      child: SafeArea(
        child: Column(
          children: [

            //==================================================
            // HEADER
            //==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff2563EB),
                    Color(0xff1D4ED8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Container(
                        width: 70,
                        height: 70,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.factory_rounded,
                          size: 38,
                          color: Color(0xff2563EB),
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 15,
                            ),

                            SizedBox(width: 5),

                            Text(
                              "Verified",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    companyName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Vendor : $vendorCode",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      const Icon(
                        Icons.phone_android,
                        color: Colors.white70,
                        size: 17,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          mobile,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [

                      const Icon(
                        Icons.email_outlined,
                        color: Colors.white70,
                        size: 17,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                children: [

                  const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      bottom: 10,
                    ),
                    child: Text(
                      "MAIN MENU",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  // Menu items Part-2 માં આવશે...
                  _menuTile(
                    icon: Icons.dashboard_rounded,
                    title: "Dashboard",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  _menuTile(
                    icon: Icons.precision_manufacturing,
                    title: "Job Work",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const JobWorkScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.event_note_rounded,
                    title: "Planning",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const PlanningScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.shopping_cart_outlined,
                    title: "Purchase Orders",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const PurchaseOrderScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.inventory_2_outlined,
                    title: "Ready Stock",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const ReadyStockScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.local_shipping_outlined,
                    title: "Dispatch",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const DispatchScreen());
                    },
                  ),

                  const Divider(height: 28),

                  _menuTile(
                    icon: Icons.notifications_active_outlined,
                    title: "Notifications",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const NotificationScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.qr_code_scanner_rounded,
                    title: "QR Login",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const QrLoginScreen());
                    },
                  ),

                  _menuTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const SettingsScreen());
                    },
                  ),
                   ],
              ),
            ),

            //==================================================
            // FOOTER
            //==================================================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: Column(
                children: [

                  Row(
                    children: const [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Version 2.1.0",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(
                        Icons.sync,
                        size: 18,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Last Sync : Today",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(
                        Icons.cloud_done,
                        size: 18,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Server : JRFPL",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //==================================================
  // MENU TILE
  //==================================================

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xff2563EB),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: onTap,
      ),
    );
  }

  //==================================================
  // LOGOUT
  //==================================================

  void _showLogoutDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to logout?",
      textCancel: "Cancel",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();

        await AuthService.logout();

        Get.offAllNamed("/login");
      },
    );
  }
}