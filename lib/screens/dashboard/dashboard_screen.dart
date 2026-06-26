import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'qr_login.dart';
import '../../services/auth_service.dart';
import '../jobwork/JobWorkScreen.dart';
import '../purchase_orders/purchase_order_screen.dart';
import '../ready_items/ready_stock_screen.dart';
import '../dispatch/dispatch_screen.dart';
import '../settings/settings_screen.dart';
import '../chat/chat_bot_screen.dart';
import 'status_list_screen.dart';
import 'notification_screen.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  // ================= USER DATA =================

  String vendorCode = "";
  String partyname = "";
  String gst ="";
  String contactPerson = "";
  String mobile = "";
  String email = "";

  int vendorId = 0;

  // ================= DASHBOARD DATA =================

  String poCount = "18";
  String jobworkCount = "12";
  String dispatchCount = "05";
  String paymentAmount = "₹25K";
  String pendingPayment = "₹12K";
  String completedJob = "42";

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadUserData();
  }

  // ================= LOAD SESSION =================

  Future<void> loadUserData() async {

  final user =
      await AuthService.getUser();

  print("USER DATA = $user");

  setState(() {

    vendorId =
        user["vendorid"] ?? 0;

    print("VENDOR ID = $vendorId");

    vendorCode =
        user["partycode"] ?? "";

    partyname =
        user["company_name"] ?? "";

    gst =
        user["gst_no"] ?? "";

    contactPerson =
        user["contact_person"] ?? "";

    mobile =
        user["mobileno"] ?? "";

    email =
        user["email"] ?? "";

    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff4f7fc),

      // ================= APP BAR =================

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.white,

        titleSpacing: 18,

        title: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              "Welcome Back 👋",

              style: TextStyle(

                fontSize: 13,

                color: Colors.grey,
              ),
            ),

            Text(

              partyname.isEmpty
                  ? "Vendor Dashboard"
                  : partyname,

              style: const TextStyle(

                fontSize: 22,

                fontWeight:
                    FontWeight.bold,

                color:
                    Color(0xff1e293b),
              ),
            ),
          ],
        ),

        actions: [

          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Color(0xff1e293b),
                ),
              ),

              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "12",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ================= DRAWER =================

      drawer: Drawer(

        backgroundColor: Colors.white,

        child: Column(

          children: [

            // ================= PROFILE =================

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.only(

                top: 60,
                left: 20,
                right: 20,
                bottom: 25,
              ),

              decoration:
                  const BoxDecoration(

                gradient: LinearGradient(

                  colors: [

                    Color(0xff4f46e5),
                    Color(0xff6366f1),
                  ],
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const CircleAvatar(

                    radius: 38,

                    backgroundColor:
                        Colors.white,

                    child: Icon(

                      Icons.person,

                      size: 40,

                      color:
                          Color(0xff4f46e5),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(

                    partyname,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 20,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'GST No. : $gst',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(

                    'Vendor Code : $vendorCode',

                    style: const TextStyle(

                      color:
                          Colors.white70,

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    'Contact : $contactPerson',

                    style: const TextStyle(

                      color:
                          Colors.white70,

                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    'Mobile No. : $mobile',

                    style: const TextStyle(

                      color:
                          Colors.white70,

                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            drawerMenu(

              Icons.dashboard_rounded,

              "Dashboard",

              true,

              () {},
            ),

            drawerMenu(
              Icons.shopping_bag_outlined,
              "Purchase Orders",
              false,
              () {
                Get.to(() => const PurchaseOrderScreen());
              },
            ),

            drawerMenu(

              Icons.precision_manufacturing,

              "Job Work",

              false,

              () {

                Get.to(
                  () =>
                      const JobWorkScreen(),
                );
              },
            ),

            drawerMenu(
              Icons.inventory_2_outlined,
              "Ready Stock",
              false,
              () {
                Get.to(() => const ReadyStockScreen());
              },
            ),

            drawerMenu(
              Icons.local_shipping_outlined,
              "Dispatch",
              false,
              () {
                Get.to(() => const DispatchScreen());
              },
            ),

            drawerMenu(
              Icons.settings_outlined,
              "Settings",
              false,
              () {
                Get.to(() => const SettingsScreen());
              },
            ),

            drawerMenu(
              Icons.qr_code_scanner,
              "Link Device",
              false,
              () {
                Get.to(
                  () => const QrLoginScreen(),
                );
              },
            ),

            const Spacer(),

            const Divider(),

            drawerMenu(

              Icons.logout_rounded,

              "Logout",

              false,

              () async {

                await AuthService.logout();

                Get.offAllNamed(
                  "/login",
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // ================= CHAT SUPPORT =================

floatingActionButton: Stack(

  clipBehavior: Clip.none,

  children: [

    Container(

      height: 65,
      width: 65,

      decoration: const BoxDecoration(

        shape: BoxShape.circle,

        gradient: LinearGradient(

          colors: [
            Color(0xFF25D366),
            Color(0xFF128C7E),
          ],
        ),
      ),

      child: IconButton(

        icon: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 30,
        ),

        onPressed: () {

          Get.to(
            () => ChatBotScreen(
              vendorId: vendorId,
            ),
          );
        },
      ),
    ),

    Positioned(

      right: -2,
      top: -2,

      child: Container(

        width: 22,
        height: 22,

        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),

        child: const Center(

          child: Text(
            "3",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  ],
),

floatingActionButtonLocation:
    FloatingActionButtonLocation.endFloat,

      // ================= BODY =================

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : RefreshIndicator(

              onRefresh:
                  loadUserData,

              child:
                  SingleChildScrollView(

                physics:
                    const AlwaysScrollableScrollPhysics(),

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                    18,
                  ),

                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      

                      // ================= QUICK ACTION =================

                      const Text(

                        "Quick Statistics",

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight:
                              FontWeight.bold,

                          color:
                              Color(0xff1e293b),
                        ),
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      LayoutBuilder(
                        builder: (context, constraints) {

                          int crossAxisCount =
                              constraints.maxWidth > 900
                                  ? 4
                                  : constraints.maxWidth > 600
                                      ? 3
                                      : 2;

                          return GridView.builder(

                            shrinkWrap: true,

                            physics:
                                const NeverScrollableScrollPhysics(),

                            itemCount: 8,

                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(

                              crossAxisCount:
                                  crossAxisCount,

                              crossAxisSpacing: 12,

                              mainAxisSpacing: 12,

                              childAspectRatio: 1.05,
                            ),

                            itemBuilder: (context, index) {

                              final items = [

                                priorityCard(
                                  "Most Urgent",
                                  "12",
                                  Icons.warning_amber_rounded,
                                  Colors.red,
                                ),

                                priorityCard(
                                  "Very High",
                                  "18",
                                  Icons.priority_high,
                                  Colors.deepOrange,
                                ),

                                priorityCard(
                                  "High",
                                  "25",
                                  Icons.trending_up,
                                  Colors.amber,
                                ),

                                priorityCard(
                                  "Delay",
                                  "7",
                                  Icons.schedule,
                                  Colors.grey,
                                ),

                                priorityCard(
                                  "New",
                                  "30",
                                  Icons.fiber_new,
                                  Colors.blue,
                                ),

                                dashboardCard(
                                  "Purchase Orders",
                                  poCount,
                                  Icons.shopping_cart_rounded,
                                  const Color(0xff3b82f6),
                                ),

                                dashboardCard(
                                  "Job Work",
                                  jobworkCount,
                                  Icons.precision_manufacturing,
                                  Colors.orange,
                                ),

                                dashboardCard(
                                  "Dispatch",
                                  dispatchCount,
                                  Icons.local_shipping_rounded,
                                  Colors.green,
                                ),
                              ];

                              return items[index];
                            },
                          );
                        },
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ================= MENU =================

  Widget drawerMenu(

    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap,

  ) {

    return Container(

      margin:
          const EdgeInsets.symmetric(

        horizontal: 12,
        vertical: 4,
      ),

      decoration: BoxDecoration(

        color: selected

            ? const Color(
                0xffeef2ff,
              )

            : Colors.transparent,

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: ListTile(

        leading: Icon(

          icon,

          color: selected

              ? const Color(
                  0xff4f46e5,
                )

              : Colors.grey.shade700,
        ),

        title: Text(

          title,

          style: TextStyle(

            fontWeight:
                FontWeight.w600,

            color: selected

                ? const Color(
                    0xff4f46e5,
                  )

                : const Color(
                    0xff334155,
                  ),
          ),
        ),

        onTap: onTap,
      ),
    );
  }

Widget priorityCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {

  return InkWell(

    borderRadius:
        BorderRadius.circular(24),

    onTap: () {

      Get.to(
        () => StatusListScreen(
          status: title,
        ),
      );
    },

    child: Container(

      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Container(

            padding:
                const EdgeInsets.all(12),

            decoration: BoxDecoration(

              color:
                  color.withOpacity(0.12),

              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            maxLines: 2,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}


  // ================= DASHBOARD CARD =================

  Widget dashboardCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {

  return Container(

    padding:
        const EdgeInsets.all(12),

    decoration: BoxDecoration(

      color: Colors.white,

      borderRadius:
          BorderRadius.circular(20),

      boxShadow: const [

        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),

    child: Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Container(

          padding:
              const EdgeInsets.all(10),

          decoration: BoxDecoration(

            color:
                color.withValues(
              alpha: .12,
            ),

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),

          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),

        const Spacer(),

        FittedBox(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

  // ================= INFO BOX =================

  Widget infoBox(
    String title,
    String value,
  ) {

    return Container(

      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: Colors.white
            .withOpacity(0.15),

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Column(

        children: [

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(

            title,

            style: const TextStyle(

              color:
                  Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ================= RECENT ACTIVITY =================

  Widget recentActivity(

    IconData icon,
    String title,
    String time,
    Color color,

  ) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(8),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),

      child: Row(

        children: [

          Container(

            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration: BoxDecoration(

              color:
                  color.withOpacity(
                0.12,
              ),

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Icon(

              icon,

              color: color,

              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [

                Text(

                  title,

                  style:
                      const TextStyle(

                    fontSize: 15,

                    fontWeight:
                        FontWeight
                            .w700,

                    color:
                        Color(
                      0xff1e293b,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(

                  time,

                  style:
                      const TextStyle(

                    fontSize: 13,

                    color:
                        Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}