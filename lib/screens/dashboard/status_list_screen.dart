import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'pdf_viewer_screen.dart';

class StatusListScreen extends StatefulWidget {
  final String status;

  const StatusListScreen({
    super.key,
    required this.status,
  });

  @override
  State<StatusListScreen> createState() =>
      _StatusListScreenState();
}

class _StatusListScreenState
    extends State<StatusListScreen> {

  List jobs = [];
  bool loading = true;
  String errorMessage = "";

  Widget infoChip(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(  
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 16,
            color: Colors.blue,
          ),

          const SizedBox(width: 5),

          Text(
            "$title : $value",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget cell(dynamic text) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 2,
      horizontal: 2,
    ),
    child: Text(
      text?.toString() ?? "",
      style: const TextStyle(
        fontSize: 10,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> updateStatus(
  String jobWorkNo,
  String status,
) async {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(
        "$status Updated",
      ),
    ),
  );

  fetchJobs();
}

Future<void> updateDeliveryDate(
  String jobWorkNo,
  DateTime date,
) async {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(
        "Delivery Date Updated",
      ),
    ),
  );

  fetchJobs();
}

void showProblemDialog(String jobWorkNo) {

  String selectedProblem = "Drawing Problem";

  final remarksController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {

      return StatefulBuilder(
        builder: (context, setState) {

          return AlertDialog(
            title: const Text(
              "Problem Details",
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                DropdownButtonFormField<String>(
                  value: selectedProblem,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Problem Type",
                    border:
                        OutlineInputBorder(),
                  ),
                  items: const [

                    DropdownMenuItem(
                      value:
                          "Drawing Problem",
                      child: Text(
                        "Drawing Problem",
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          "Material Problem",
                      child: Text(
                        "Material Problem",
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          "Material Not Recived",
                      child: Text(
                        "Material Not Recived",
                      ),
                    ),

                    DropdownMenuItem(
                      value:
                          "Other Problem",
                      child: Text(
                        "Other Problem",
                      ),
                    ),
                  ],
                  onChanged: (value) {

                    setState(() {
                      selectedProblem =
                          value!;
                    });
                  },
                ),

                const SizedBox(
                  height: 12,
                ),

                TextField(
                  controller:
                      remarksController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(
                    labelText:
                        "Remarks",
                    hintText:
                        "Enter Details",
                    border:
                        OutlineInputBorder(),
                  ),
                ),
              ],
            ),

            actions: [

              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                },
                child: const Text(
                  "Cancel",
                ),
              ),

              ElevatedButton(
                onPressed: () async {

                  String remarks =
                      remarksController.text
                          .trim();

                  debugPrint(
                    "Job No: $jobWorkNo",
                  );

                  debugPrint(
                    "Problem: $selectedProblem",
                  );

                  debugPrint(
                    "Remarks: $remarks",
                  );

                  Navigator.pop(
                    dialogContext,
                  );

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "$selectedProblem Submitted",
                      ),
                    ),
                  );

                  // Call API here
                  // await submitProblem(
                  //   jobWorkNo,
                  //   selectedProblem,
                  //   remarks,
                  // );
                },
                child: const Text(
                  "Submit",
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  Future<void> fetchJobs() async {

    setState(() {
      loading = true;
      errorMessage = "";
    });

    try {

      final prefs =
          await SharedPreferences.getInstance();

      String vendorCode =
          prefs.getString("vendor_code") ?? "";

      final uri = Uri.https(
        'crm.jupiterrollforming.com',
        '/project2/api/jobs.php',
        {
          'vendor_code': vendorCode,
          'status': widget.status,
        },
      );

      final response =
          await http.get(uri);

      debugPrint(
          "API URL : ${uri.toString()}");

      debugPrint(
          "API RESPONSE : ${response.body}");

      if (response.statusCode == 200) {

        final jsonData =
            jsonDecode(response.body);

        if (jsonData["success"] == true) {

          setState(() {

            jobs =
                jsonData["data"] ?? [];

            loading = false;
          });

        } else {

          setState(() {

            errorMessage =
                jsonData["message"] ??
                    "Unknown Error";

            loading = false;
          });
        }

      } else {

        setState(() {

          errorMessage =
              "Server Error : ${response.statusCode}";

          loading = false;
        });
      }

    } catch (e) {

      debugPrint(e.toString());

      setState(() {

        errorMessage = e.toString();

        loading = false;
      });
    }
  }

  Color getStatusColor(String? status) {

  switch ((status ?? '').toUpperCase()) {
    case "PENDING":
      return Colors.orange;

    case "RECEIVED":
      return Colors.blue;

    case "COMPLETED":
    case "READY":
      return Colors.green;

    case "MOST URGENT":
      return Colors.red;

    case "IN PROCESS":
      return Colors.deepOrange;

    default:
      return Colors.grey;
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff4f7fc),

      appBar: AppBar(

        title: Text(widget.status),

        actions: [

          IconButton(

            onPressed: fetchJobs,

            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : errorMessage.isNotEmpty

              ? Center(
                  child: Text(
                    errorMessage,
                    style:
                        const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )

              : RefreshIndicator(

                  onRefresh: fetchJobs,

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      15,
                    ),

                    child: Column(

                      children: [

                        Container(

                          padding:
                              const EdgeInsets.all(8),

                          decoration:
                              BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),

                          child: Row(

                            children: [

                              Expanded(

                                child: TextField(

                                  decoration:
                                      InputDecoration(

                                    hintText:
                                        "Search...",

                                    prefixIcon:
                                        const Icon(Icons.search),
                                     filled: true,
                                    fillColor: const Color.fromARGB(255, 216, 209, 209),
                                    border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide.none),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              ElevatedButton.icon(

                                onPressed: () {},

                                icon: const Icon(
                                  Icons.filter_alt,
                                ),

                                label:
                                    const Text(
                                  "Filter",
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Expanded(
                          child: jobs.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Items Found",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: jobs.length,
                                   separatorBuilder: (_, __) =>
                                    const SizedBox(height: 2),
                                  itemBuilder: (context, index) {

                                    final job = jobs[index];

                                    return Card(
  margin: const EdgeInsets.only(bottom: 6),
  elevation: 1,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: const EdgeInsets.all(6),
    child: Column(
      children: [

        /// Header
        Row(
          children: [

            Expanded(
              flex: 3,
              child: Text(
                job['item_name'] ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: getStatusColor(
                  job['job_status']?.toString(),
                ).withOpacity(0.15),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                job['job_status'] ?? '',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        /// Table Style
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [

            TableRow(
              children: [
                cell("Drawing"),
                cell(job['drawing_no']),
                cell("Rev"),
                cell(job['Revison']),
              ],
            ),

            TableRow(
              children: [
                cell("Qty"),
                cell("${job['job_qty']}"),
                cell("Pending"),
                cell("${job['pending_qty']}"),
              ],
            ),

            TableRow(
              children: [
                cell("Delivery"),
                cell(job['delivery_date']),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
          ],
        ),

        const SizedBox(height: 5),

        /// Small Buttons
        Row(
          children: [

            Expanded(
              child: SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2035),
                    );

                    if (date != null) {
                      updateDeliveryDate(
                        job['jobwork_no'].toString(),
                        date,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  child: const Text("Date"),
                ),
              ),
            ),

            const SizedBox(width: 4),

            Expanded(
              child: SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("Ready Clicked");
                    updateStatus(
                      job['jobwork_no'].toString(),
                      "READY",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  child: const Text("Ready"),
                ),
              ),
            ),

            const SizedBox(width: 4),

            Expanded(
              child: SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: () {
                    showProblemDialog(
                      job['jobwork_no'].toString(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  child: const Text("Problem"),
                ),
              ),
            ),
            const SizedBox(width: 4),

Expanded(
  child: SizedBox(
    height: 28,
    child: ElevatedButton(
      onPressed: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
              pdfUrl: job['pdf_url'] ?? '',
              drawingNo: job['drawing_no'] ?? '',
            ),
          ),
        );

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.zero,
      ),
      child: const Text(
        "DWG",
        style: TextStyle(fontSize: 9),
      ),
    ),
  ),
),

          ],
        ),
      ],
    ),
  ),
);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}