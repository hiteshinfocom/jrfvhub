import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../purchase_orders/purchase_order_screen.dart';
import '../jobwork/JobWorkScreen.dart';
import '../ready_items/ready_stock_screen.dart';
import '../dispatch/dispatch_screen.dart';
import '../settings/settings_screen.dart';

class WebDashboardScreen extends StatelessWidget {
  const WebDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff4f7fc),

      body: Row(

        children: [

          // ================= SIDEBAR =================

          Container(

            width: 260,

            color: Colors.white,

            child: Column(

              children: [

                Container(

                  height: 80,

                  alignment: Alignment.center,

                  child: const Text(

                    "JRFVHub",

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight: FontWeight.bold,

                      color: Color(0xff4f46e5),
                    ),
                  ),
                ),

                const Divider(),

                menuItem(
                  Icons.dashboard,
                  "Dashboard",
                  () {},
                ),

                menuItem(
                  Icons.shopping_bag,
                  "Purchase Orders",
                  () {
                    Get.to(
                      () => const PurchaseOrderScreen(),
                    );
                  },
                ),

                menuItem(
                  Icons.precision_manufacturing,
                  "Job Work",
                  () {
                    Get.to(
                      () => const JobWorkScreen(),
                    );
                  },
                ),

                menuItem(
                  Icons.inventory,
                  "Ready Stock",
                  () {
                    Get.to(
                      () => const ReadyStockScreen(),
                    );
                  },
                ),

                menuItem(
                  Icons.local_shipping,
                  "Dispatch",
                  () {
                    Get.to(
                      () => const DispatchScreen(),
                    );
                  },
                ),

                menuItem(
                  Icons.settings,
                  "Settings",
                  () {
                    Get.to(
                      () => const SettingsScreen(),
                    );
                  },
                ),

                const Spacer(),

                const Divider(),

                menuItem(
                  Icons.logout,
                  "Logout",
                  () {},
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // ================= CONTENT =================

          Expanded(

            child: Column(

              children: [

                Container(

                  height: 70,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),

                  color: Colors.white,

                  child: const Row(

                    children: [

                      Text(

                        "Vendor Dashboard",

                        style: TextStyle(

                          fontSize: 24,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Spacer(),

                      CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
                      ),
                    ],
                  ),
                ),

                Expanded(

                  child: SingleChildScrollView(

                    padding:
                        const EdgeInsets.all(25),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(

                          "Quick Statistics",

                          style: TextStyle(

                            fontSize: 24,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        GridView.count(

                          crossAxisCount: 4,

                          shrinkWrap: true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          crossAxisSpacing: 15,

                          mainAxisSpacing: 15,

                          childAspectRatio: 1.4,

                          children: const [

                            DashboardCard(
                              title: "Purchase Orders",
                              value: "18",
                              icon: Icons.shopping_cart,
                              color: Colors.blue,
                            ),

                            DashboardCard(
                              title: "Job Work",
                              value: "12",
                              icon: Icons.precision_manufacturing,
                              color: Colors.orange,
                            ),

                            DashboardCard(
                              title: "Dispatch",
                              value: "05",
                              icon: Icons.local_shipping,
                              color: Colors.green,
                            ),

                            DashboardCard(
                              title: "Pending Payment",
                              value: "₹12K",
                              icon: Icons.currency_rupee,
                              color: Colors.red,
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        Container(

                          height: 500,

                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(20),
                          ),

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Text(

                                "Recent Activities",

                                style: TextStyle(

                                  fontSize: 20,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Expanded(

                                child: ListView.builder(

                                  itemCount: 10,

                                  itemBuilder: (_, index) {

                                    return const ListTile(

                                      leading:
                                          Icon(Icons.history),

                                      title: Text(
                                        "Job Work Updated",
                                      ),

                                      subtitle:
                                          Text("Today"),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget menuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class DashboardCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: color,
            size: 32,
          ),

          const Spacer(),

          Text(

            value,

            style: TextStyle(

              color: color,

              fontSize: 28,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(title),
        ],
      ),
    );
  }
}