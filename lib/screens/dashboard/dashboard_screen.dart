import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/auth_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/notification_api.dart';

import '../chat/chat_bot_screen.dart';
import '../dispatch/dispatch_screen.dart';
import '../jobwork/JobWorkScreen.dart';
import '../planning/planning_screen.dart';
import '../purchase_orders/purchase_order_screen.dart';
import '../ready_items/ready_stock_screen.dart';
import 'notification_screen.dart';

import '../../widgets/dashboard/dashboard_appbar.dart';
import '../../widgets/dashboard/side_profile_drawer.dart';
import '../../widgets/dashboard/action_required.dart';
import '../../widgets/dashboard/quick_module_grid.dart';
import '../../widgets/dashboard/summary_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  //--------------------------------------------------
  // USER INFO
  //--------------------------------------------------

  String vendorCode = "";
  String partyName = "";
  String gstNo = "";
  String contactPerson = "";
  String mobile = "";
  String email = "";

  int vendorId = 0;
  int unreadNotificationCount = 0;

  //--------------------------------------------------
  // DASHBOARD COUNTS
  //--------------------------------------------------

  int assigned = 0;
  int accepted = 0;
  int inProcess = 0;
  int partialCompleted = 0;
  int completed = 0;

  int planning = 0;
  int purchase = 0;
  int readyStock = 0;
  int dispatch = 0;
  int payment = 0;

  int todayTask = 0;
  int todayDispatch = 0;

  int newPurchase = 0;
  int pendingPurchase = 0;
  int completedPurchase = 0;

  bool isLoading = true;

  //--------------------------------------------------
  // INIT
  //--------------------------------------------------

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadNotificationCount() async {
  unreadNotificationCount =
      await NotificationApi.getUnreadCount(
    vendorCode,
  );

  if (mounted) {
    setState(() {});
  }
}

  //--------------------------------------------------
  // LOAD USER
  //--------------------------------------------------

  Future<void> loadUserData() async {

    final user = await AuthService.getUser();

    vendorId = user["vendorid"] ?? 0;
    vendorCode = user["partycode"] ?? "";
    partyName = user["company_name"] ?? "";
    gstNo = user["gst_no"] ?? "";
    contactPerson = user["contact_person"] ?? "";
    mobile = user["mobileno"] ?? "";
    email = user["email"] ?? "";

    await loadDashboard();
    await loadNotificationCount();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //--------------------------------------------------
  // LOAD DASHBOARD
  //--------------------------------------------------

  Future<void> loadDashboard() async {

    final data =
        await DashboardService.getDashboard(
      vendorCode,
    );

    if (!mounted) return;

    setState(() {

      assigned =
          data["assigned"] ?? 0;

      accepted =
          data["accepted"] ?? 0;

      inProcess =
          data["in_process"] ?? 0;

      partialCompleted =
          data["partial_completed"] ?? 0;

      completed =
          data["completed"] ?? 0;

      planning =
          data["planning"] ?? 0;

      purchase =
          data["purchase"] ?? 0;

      readyStock =
          data["ready_stock"] ?? 0;

      dispatch =
          data["dispatch"] ?? 0;

      payment =
          data["payment"] ?? 0;

      todayTask =
          data["today_task"] ?? 0;

      todayDispatch =
          data["today_delivery"] ?? 0;

      newPurchase =
          data["new_purchase"] ?? 0;

      pendingPurchase =
          data["pending_purchase"] ?? 0;

      completedPurchase =
          data["completed_purchase"] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      appBar: DashboardAppBar(
        companyName: partyName,
        notificationCount: unreadNotificationCount,
        onNotificationTap: () async {
          await Get.to(
            () => const NotificationScreen(),
          );

          await loadNotificationCount();
        },
      ),

      drawer: SideProfileDrawer(
        companyName: partyName,
        vendorCode: vendorCode,
        gstNo: gstNo,
        contactPerson: contactPerson,
        mobile: mobile,
        email: email,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        child: const FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(
            () => ChatBotScreen(
              vendorId: vendorId,
            ),
          );
        },
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,

      body: RefreshIndicator(
        onRefresh: loadUserData,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              ActionRequiredSection(
                planningCount: planning,
                jobWorkCount: assigned,
                readyStockCount: readyStock,
                dispatchCount: dispatch,
              ),

              const QuickModuleGrid(),

              const SizedBox(height: 20),
               SummarySection(
                title: "Job Work Summary",
                icon: Icons.engineering,
                color: Colors.blue,
                items: [
                  SummaryItem(
                    title: "Assigned",
                    value: assigned,
                    icon: Icons.assignment,
                    color: Colors.blue,
                  ),
                  SummaryItem(
                    title: "Accepted",
                    value: accepted,
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  SummaryItem(
                    title: "In Process",
                    value: inProcess,
                    icon: Icons.sync,
                    color: Colors.orange,
                  ),
                  SummaryItem(
                    title: "Completed",
                    value: completed,
                    icon: Icons.task_alt,
                    color: Colors.teal,
                  ),
                ],
                onViewAll: () => Get.to(() => const JobWorkScreen()),
              ),

              SummarySection(
                title: "Planning Summary",
                icon: Icons.calendar_month,
                color: Colors.deepPurple,
                items: [
                  SummaryItem(
                    title: "Planning",
                    value: planning,
                    icon: Icons.event_note,
                    color: Colors.deepPurple,
                  ),
                ],
                onViewAll: () => Get.to(() => const PlanningScreen()),
              ),

              SummarySection(
                title: "Purchase Orders",
                icon: Icons.shopping_cart,
                color: Colors.indigo,
                items: [
                  SummaryItem(
                    title: "New",
                    value: newPurchase,
                    icon: Icons.fiber_new,
                    color: Colors.blue,
                  ),
                  SummaryItem(
                    title: "Pending",
                    value: pendingPurchase,
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                  SummaryItem(
                    title: "Completed",
                    value: completedPurchase,
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
                onViewAll: () =>
                    Get.to(() => const PurchaseOrderScreen()),
              ),

              SummarySection(
                title: "Ready Stock",
                icon: Icons.inventory_2,
                color: Colors.green,
                items: [
                  SummaryItem(
                    title: "Ready Items",
                    value: readyStock,
                    icon: Icons.inventory,
                    color: Colors.green,
                  ),
                ],
                onViewAll: () =>
                    Get.to(() => const ReadyStockScreen()),
              ),

              SummarySection(
                title: "Dispatch Summary",
                icon: Icons.local_shipping,
                color: Colors.red,
                items: [
                  SummaryItem(
                    title: "Dispatch",
                    value: dispatch,
                    icon: Icons.local_shipping,
                    color: Colors.red,
                  ),
                  SummaryItem(
                    title: "Today's Dispatch",
                    value: todayDispatch,
                    icon: Icons.today,
                    color: Colors.deepOrange,
                  ),
                ],
                onViewAll: () =>
                    Get.to(() => const DispatchScreen()),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}