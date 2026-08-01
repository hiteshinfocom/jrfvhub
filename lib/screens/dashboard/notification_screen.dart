import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/notification_model.dart';
import '../../services/auth_service.dart';
import '../../services/notification_api.dart';
import '../planning/planning_screen.dart';
import '../jobwork/JobWorkScreen.dart';
import '../dispatch/dispatch_screen.dart';
import '../ready_items/ready_stock_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  bool isLoading = true;

  String vendorCode = "";

  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  //----------------------------------------------------------
  // LOAD NOTIFICATIONS
  //----------------------------------------------------------

  Future<void> loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final user = await AuthService.getUser();

      vendorCode = user["partycode"] ?? "";

      notifications =
          await NotificationApi.getNotifications(
        vendorCode,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  //----------------------------------------------------------
  // UI
  //----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        elevation: 0,
      ),

      body: RefreshIndicator(
        onRefresh: loadNotifications,

        child: _buildBody(),
      ),
    );
  }

  //----------------------------------------------------------
  // BODY
  //----------------------------------------------------------

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notifications.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),

          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 20),

          Center(
            child: Text(
              "No Notifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 10),

          Center(
            child: Text(
              "You're all caught up.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }

    // List Part-2 માં આવશે
    return ListView.builder(
  padding: const EdgeInsets.all(12),
  itemCount: notifications.length,
  itemBuilder: (context, index) {
    final item = notifications[index];

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
  if (!item.isRead) {
    await NotificationApi.markAsRead(item.id);

    setState(() {
      notifications[index] = NotificationModel(
        id: item.id,
        module: item.module,
        referenceId: item.referenceId,
        notificationType: item.notificationType,
        title: item.title,
        message: item.message,
        imageUrl: item.imageUrl,
        clickScreen: item.clickScreen,
        clickData: item.clickData,
        isSent: item.isSent,
        sentAt: item.sentAt,
        isRead: true,
        readAt: item.readAt,
        createdAt: item.createdAt,
      );
    });
  }

  _openScreen(item);
},
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //--------------------------------------------------
              // MODULE ICON
              //--------------------------------------------------

              CircleAvatar(
                radius: 24,
                backgroundColor:
                      _moduleColor(item.module).withValues(alpha: 0.12),
                child: Icon(
                  _moduleIcon(item.module),
                  color: _moduleColor(item.module),
                ),
              ),

              const SizedBox(width: 14),

              //--------------------------------------------------
              // DETAILS
              //--------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [

                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),

                        if (!item.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      item.message,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [

                        Icon(
                          Icons.category_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          item.module,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const Spacer(),

                        Text(
                          _formatTime(item.createdAt),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  },
);
  }

  //----------------------------------------------------------
// OPEN SCREEN
//----------------------------------------------------------

void _openScreen(NotificationModel item) {
  switch (item.clickScreen.toLowerCase()) {
    case "planning":
      Get.to(() => const PlanningScreen());
      break;

    case "jobwork":
      Get.to(() => const JobWorkScreen());
      break;

    case "dispatch":
      Get.to(() => const DispatchScreen());
      break;

    case "ready_stock":
      Get.to(() => const ReadyStockScreen());
      break;

    default:
      break;
  }
}

//----------------------------------------------------------
// FORMAT TIME
//----------------------------------------------------------

String _formatTime(String value) {
  try {
    final date = DateTime.parse(value);
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return "Just now";
    }

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} hr ago";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    if (diff.inDays < 7) {
      return "${diff.inDays} days ago";
    }

    return "${date.day}/${date.month}/${date.year}";
  } catch (_) {
    return value;
  }
}
  //----------------------------------------------------------
// MODULE ICON
//----------------------------------------------------------

IconData _moduleIcon(String module) {
  switch (module.toLowerCase()) {
    case "planning":
      return Icons.calendar_month;

    case "jobwork":
      return Icons.precision_manufacturing;

    case "dispatch":
      return Icons.local_shipping;

    case "ready_stock":
      return Icons.inventory_2;

    case "purchase":
      return Icons.shopping_cart;

    default:
      return Icons.notifications;
  }
}

//----------------------------------------------------------
// MODULE COLOR
//----------------------------------------------------------

Color _moduleColor(String module) {
  switch (module.toLowerCase()) {
    case "planning":
      return Colors.blue;

    case "jobwork":
      return Colors.orange;

    case "dispatch":
      return Colors.green;

    case "ready stock":
      return Colors.purple;

    case "purchase":
      return Colors.red;

    default:
      return Colors.grey;
  }
}
}