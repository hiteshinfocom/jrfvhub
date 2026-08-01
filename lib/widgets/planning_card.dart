import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/planning_model.dart';

class PlanningCard extends StatelessWidget {
  final PlanningModel planning;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback onPdf;

  const PlanningCard({
  super.key,
  required this.planning,
  required this.onAccept,
  required this.onReject,
  required this.onPdf,
});

  String formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat("dd MMM yyyy").format(date);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool small = width < 360;

    final double titleSize = small ? 13 : 15;
    final double textSize = small ? 11 : 12;
    final double iconSize = small ? 17 : 20;
    final double buttonHeight = small ? 34 : 38;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            ///==============================
            /// HEADER
            ///==============================

            Row(
              children: [

                Container(
                  height: small ? 38 : 42,
                  width: small ? 38 : 42,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.precision_manufacturing,
                    color: Colors.blue,
                    size: iconSize,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          Expanded(
                            child: Text(
                              planning.drawingNo,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          if (planning
                              .drawingVersion
                              .isNotEmpty)

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange
                                    .shade100,
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: Text(
                                "REV ${planning.drawingVersion}",
                                style:
                                    const TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),

                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        planning.itemDesc,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: textSize,
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 12),

            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 12),

            ///==============================
            /// PLANNING DETAILS
            ///==============================
            Row(
              children: [

                Expanded(
                  child: compactTile(
                    icon: Icons.calendar_month_outlined,
                    title: "Month",
                    value: planning.monthOfPlanning.isEmpty
                        ? "-"
                        : DateFormat("MMM yyyy").format(
                            DateTime.parse(
                              planning.monthOfPlanning,
                            ),
                          ),
                    small: small,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: compactTile(
                    icon: Icons.view_week_outlined,
                    title: "Week",
                    value: planning.weekOfPlanning,
                    small: small,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [

                Expanded(
                  child: compactTile(
                    icon: Icons.event_available,
                    title: "Planning Date",
                    value: formatDate(
                      planning.vendorDate,
                    ),
                    small: small,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: compactTile(
                    icon: Icons.inventory_2_outlined,
                    title: "Qty",
                    value: "${planning.departmentQty.toStringAsFixed(0)} PCS",
                    small: small,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 14),

            Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),

            const SizedBox(height: 12),

            ///==============================
            /// ACTION BUTTONS
            ///==============================
            if (planning.vendorStatus == "Pending") ...[
              Row(
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text("PDF"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    child: const Text("Accept"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onReject,
                    child: const Text("Reject"),
                  ),
                ),

              ],
            ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: small ? 8 : 10,
                ),
                decoration: BoxDecoration(
                  color: planning.vendorStatus == "Accept"
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      planning.vendorStatus == "Accept"
                          ? Icons.check_circle
                          : Icons.cancel,
                      size: small ? 18 : 20,
                      color: planning.vendorStatus == "Accept"
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      planning.vendorStatus,
                      style: TextStyle(
                        fontSize: small ? 13 : 14,
                        fontWeight: FontWeight.bold,
                        color: planning.vendorStatus == "Accept"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget compactTile({
    required IconData icon,
    required String title,
    required String value,
    required bool small,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: small ? 16 : 18,
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: small ? 9 : 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: small ? 11 : 12,
                    fontWeight: FontWeight.w600,
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