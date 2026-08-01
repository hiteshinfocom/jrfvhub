import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/planning/planning_screen.dart';
import '../../screens/jobwork/JobWorkScreen.dart';
import '../../screens/ready_items/ready_stock_screen.dart';
import '../../screens/dispatch/dispatch_screen.dart';

class ActionRequiredSection extends StatelessWidget {
  final int planningCount;
  final int jobWorkCount;
  final int readyStockCount;
  final int dispatchCount;

  const ActionRequiredSection({
    super.key,
    required this.planningCount,
    required this.jobWorkCount,
    required this.readyStockCount,
    required this.dispatchCount,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasActions =
        planningCount > 0 ||
        jobWorkCount > 0 ||
        readyStockCount > 0 ||
        dispatchCount > 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Row(
            children: [

              Icon(
                Icons.flash_on_rounded,
                color: Colors.orange,
                size: 24,
              ),

              SizedBox(width: 8),

              Text(
                "Action Required",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            hasActions
                ? "Complete the pending tasks below."
                : "Everything is up to date.",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 18),

          if (!hasActions)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.green.shade200,
                ),
              ),
              child: const Row(
                children: [

                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "No pending action. Great job!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (hasActions)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              crossAxisCount: 2,

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,

              childAspectRatio: 1.7,

              children: [

                if (planningCount > 0)
                  _actionCard(
                    color: Colors.blue,
                    icon: Icons.event_note_rounded,
                    title: "Planning",
                    subtitle: "Accept Planning",
                    count: planningCount,
                    onTap: () {
                      Get.to(() => const PlanningScreen());
                    },
                  ),

                if (jobWorkCount > 0)
                  _actionCard(
                    color: Colors.orange,
                    icon: Icons.precision_manufacturing,
                    title: "Job Work",
                    subtitle: "Update Progress",
                    count: jobWorkCount,
                    onTap: () {
                      Get.to(() => const JobWorkScreen());
                    },
                  ),

                if (readyStockCount > 0)
                  _actionCard(
                    color: Colors.green,
                    icon: Icons.inventory_2_outlined,
                    title: "Ready Stock",
                    subtitle: "Pending Update",
                    count: readyStockCount,
                    onTap: () {
                      Get.to(() => const ReadyStockScreen());
                    },
                  ),

                if (dispatchCount > 0)
                  _actionCard(
                    color: Colors.red,
                    icon: Icons.local_shipping_outlined,
                    title: "Dispatch",
                    subtitle: "Dispatch Pending",
                    count: dispatchCount,
                    onTap: () {
                      Get.to(() => const DispatchScreen());
                    },
                  ),
              ],
            ),
             ],
      ),
    );
  }

  //==================================================
  // ACTION CARD
  //==================================================

  Widget _actionCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withOpacity(.20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withOpacity(.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 22,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Text(
                      "Open",
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}