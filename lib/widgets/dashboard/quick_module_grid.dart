import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/jobwork/JobWorkScreen.dart';
import '../../screens/planning/planning_screen.dart';
import '../../screens/purchase_orders/purchase_order_screen.dart';
import '../../screens/ready_items/ready_stock_screen.dart';
import '../../screens/dispatch/dispatch_screen.dart';
import '../../screens/dashboard/notification_screen.dart';

class QuickModuleGrid extends StatelessWidget {
  const QuickModuleGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <_QuickModule>[
      _QuickModule(
        title: "Job Work",
        icon: Icons.precision_manufacturing,
        color: Colors.orange,
        onTap: () => Get.to(() => const JobWorkScreen()),
      ),
      _QuickModule(
        title: "Planning",
        icon: Icons.event_note_rounded,
        color: Colors.blue,
        onTap: () => Get.to(() => const PlanningScreen()),
      ),
      _QuickModule(
        title: "Purchase",
        icon: Icons.shopping_cart_outlined,
        color: Colors.deepPurple,
        onTap: () => Get.to(() => const PurchaseOrderScreen()),
      ),
      _QuickModule(
        title: "Ready Stock",
        icon: Icons.inventory_2_outlined,
        color: Colors.green,
        onTap: () => Get.to(() => const ReadyStockScreen()),
      ),
      _QuickModule(
        title: "Dispatch",
        icon: Icons.local_shipping_outlined,
        color: Colors.red,
        onTap: () => Get.to(() => const DispatchScreen()),
      ),
      _QuickModule(
        title: "Notifications",
        icon: Icons.notifications_active_outlined,
        color: Colors.amber,
        onTap: () => Get.to(() => const NotificationScreen()),
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                color: Color(0xff2563EB),
              ),
              SizedBox(width: 8),
              Text(
                "Quick Modules",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: .95,
            ),
            itemBuilder: (context, index) {
              final item = modules[index];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color:
                                  item.color.withOpacity(.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              color: item.color,
                              size: 22,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickModule {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickModule({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}