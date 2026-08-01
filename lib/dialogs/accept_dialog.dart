import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'accept_result.dart';

class AcceptDialog {
  static Future<AcceptResult?> show({
    required BuildContext context,
    required DateTime weekStartDate,
    required DateTime weekEndDate,
  }) async {
    DateTime? selectedDate;
    final reasonController = TextEditingController();

bool isExtended = false;

    return await showDialog<AcceptResult>(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                    const Center(
                      child: Text(
                        "Accept Planning",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Select Expected Completion Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),

                    InkWell(
                      borderRadius:
                          BorderRadius.circular(12),
                      onTap: () async {

                        final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? weekStartDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 3650),
                        ),
                      );

                      if (date != null) {
                        final outside =
                            date.isBefore(weekStartDate) ||
                            date.isAfter(weekEndDate);

                        setState(() {
                          selectedDate = date;
                          isExtended = outside;
                        });
                      }

                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.blue,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? "Select Date"
                                    : DateFormat(
                                            "dd MMM yyyy")
                                        .format(
                                            selectedDate!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Allowed : ${DateFormat("dd MMM").format(weekStartDate)} - ${DateFormat("dd MMM yyyy").format(weekEndDate)}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),

                    if (selectedDate != null)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isExtended
                            ? Colors.orange.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isExtended
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isExtended
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle,
                            color: isExtended
                                ? Colors.orange
                                : Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isExtended
                                  ? "Selected date is outside the planning week."
                                  : "Selected date is within the planning week.",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isExtended
                                    ? Colors.orange.shade800
                                    : Colors.green.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isExtended) ...[
                      const SizedBox(height: 15),

                      const Text(
                        "Reason *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "તારીખ બદલવાનું કારણ લખો",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),

                    Row(
                      children: [

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },
                            child:
                                const Text("Cancel"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedDate == null
                                ? null
                                : () {
                                    if (isExtended &&
                                        reasonController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Please enter reason."),
                                        ),
                                      );
                                      return;
                                    }

                                    Navigator.pop(
                                      context,
                                      AcceptResult(
                                        date: selectedDate!,
                                        reason: reasonController.text.trim(),
                                        isExtended: isExtended,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Accept"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}