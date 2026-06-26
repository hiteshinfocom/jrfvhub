import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/jw_service.dart';
import '../../services/auth_service.dart';
import '../dashboard/pdf_viewer_screen.dart';

class JobWorkScreen extends StatefulWidget {
  const JobWorkScreen({super.key});

  @override
  State<JobWorkScreen> createState() =>
      _JobWorkScreenState();
}

class _JobWorkScreenState
    extends State<JobWorkScreen> {

  // ================= LOADING =================

  bool isLoading = true;

  // ================= ALL DATA =================

  List<dynamic> jobWorkList = [];

  // ================= FILTER DATA =================

  List<dynamic> filteredList = [];

  // ================= SEARCH =================

  final TextEditingController
      searchController =
      TextEditingController();

  // ================= VENDOR CODE =================

  String vendorCode = "";
  String selectedStatus = "All";
  @override
  void initState() {

    super.initState();

    loadVendorData();
  }

   // 👇 અહીં મૂકો

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ================= LOAD USER =================

  Future<void> loadVendorData() async {

    final user =
        await AuthService.getUser();

    vendorCode =
        user["partycode"] ?? "";

    fetchJobWorkData();
  }

  // ================= FETCH DATA =================

  Future<void> fetchJobWorkData() async {

  setState(() {
    isLoading = true;
  });

  final data =
      await JobWorkService.getJobWorkList(
    vendorCode,
  );

  searchController.clear();
  selectedStatus = "All";

  setState(() {
    jobWorkList = data;
    filteredList = data;
    isLoading = false;
  });
}

  // ================= SEARCH FILTER =================

  void searchJobWork(String value) {
  applyFilters();
}
  // ================= STATUS COLOR =================

  Color statusColor(String status) {

  switch (
      status.toLowerCase()) {

    case "assigned":
      return Colors.orange;

    case "accepted":
      return Colors.blue;

    case "in process":
      return Colors.purple;

    case "partially completed":
        return Colors.deepOrange;

    case "completed":
      return Colors.green;

    default:
      return Colors.grey;
  }
}

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
  backgroundColor: const Color(0xfff5f7fb),

  appBar: AppBar(
    elevation: 0,
    centerTitle: true,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff1E40AF),
          ],
        ),
      ),
    ),
    title: const Text(
      "Job Work Status",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),

  body: Column(
    children: [

      // SUMMARY CARD
      Container(
  margin: const EdgeInsets.all(12),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xff2563EB),
        Color(0xff3B82F6),
      ],
    ),
    borderRadius: BorderRadius.circular(18),
  ),
  child: Column(
    children: [

      Row(
        children: [

          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.precision_manufacturing,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Text(
                  "Total Job Works",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),

                Text(
                  "${filteredList.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      const SizedBox(height: 15),

      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [

          summaryBox(
            "Assigned",
            jobWorkList.where((e) =>
              e["status"]
              .toString()
              .toLowerCase() ==
              "assigned").length,
          ),

          summaryBox(
            "Accepted",
            jobWorkList.where((e) =>
              e["status"]
              .toString()
              .toLowerCase() ==
              "accepted").length,
          ),

          summaryBox(
            "Process",
            jobWorkList.where((e) =>
              e["status"]
              .toString()
              .toLowerCase() ==
              "in process").length,
          ),

          summaryBox(
            "Done",
            jobWorkList.where((e) =>
              e["status"]
              .toString()
              .toLowerCase() ==
              "completed").length,
          ),
        ],
      ),
    ],
  ),
),

      // SEARCH BOX
      Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: TextField(
          controller: searchController,
          onChanged: searchJobWork,
          decoration: InputDecoration(
            hintText: "Search Job No, Item Name",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [

            const Icon(
              Icons.filter_list,
              color: Colors.blue,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "All",
                    child: Text("All Status"),
                  ),
                  DropdownMenuItem(
                    value: "assigned",
                    child: Text("Assigned"),
                  ),
                  DropdownMenuItem(
                    value: "accepted",
                    child: Text("Accepted"),
                  ),
                  DropdownMenuItem(
                    value: "in process",
                    child: Text("In Process"),
                  ),
                  DropdownMenuItem(
                    value: "partially completed",
                    child: Text("Partially Completed"),
                  ),
                  DropdownMenuItem(
                    value: "completed",
                    child: Text("Completed"),
                  ),
                ],
                onChanged: (value) {

                  selectedStatus =
                      value ?? "All";

                  applyFilters();
                },
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 10),

          // ================= BODY =================

          Expanded(

            child: isLoading

                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )

                : filteredList.isEmpty

                    ? const Center(
                        child: Text(
                          "No Data Found",
                        ),
                      )

                    : RefreshIndicator(

                        onRefresh:
                            fetchJobWorkData,

                        child:
                            ListView.builder(

                          padding:
                              const EdgeInsets.all(
                            6,
                          ),

                          itemCount:
                              filteredList
                                  .length,

                          itemBuilder:
                              (context,
                                  index) {

                            final item =
                                filteredList[
                                    index];

                            double totalQty =
                              double.tryParse(
                                item["issue_qty"].toString(),
                              ) ??
                              0;

                            double completeQty =
                              double.tryParse(
                                item["complete_qty"].toString(),
                              ) ??
                              0;

                            double progress =
                                totalQty == 0

                                    ? 0

                                    : completeQty /
                                        totalQty;

                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [

                                  // Header

                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["jobwork_no"].toString(),
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Challan : ${item["challan_no"]}",
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor(
                                              item["status"].toString(),
                                            ).withValues(alpha: 0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item["status"].toString(),
                                            style: TextStyle(
                                              color: statusColor(
                                                item["status"].toString(),
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 5),

                                        PopupMenuButton<String>(
                                          icon: const Icon(
                                            Icons.more_vert,
                                            size: 20,
                                          ),
                                          onSelected: (value) {

                                            switch (value) {

                                              case "approve":
                                                showApproveDialog(item);
                                                break;

                                              case "issue":
                                                showIssueDialog(item);
                                                break;

                                              case "drawing":

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => PdfViewerScreen(
                                                      pdfUrl: item["drawing_pdf"] ?? "",
                                                      drawingNo: item["drawing_no"] ?? "",
                                                      
                                                    ),
                                                  ),
                                                );

                                                break;

                                              case "dispatch":
                                                showDispatchDialog(item);
                                                break;
                                            }
                                          },
                                          itemBuilder: (context) {

                                            List<PopupMenuEntry<String>> menus = [];

                                            final status = item["status"]
                                                .toString()
                                                .toLowerCase();

                                            if (status == "assigned") {
                                              menus.add(
                                                const PopupMenuItem(
                                                  value: "approve",
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text("Accept"),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }

                                            menus.add(
                                                const PopupMenuItem(
                                                value: "issue",
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.report_problem,
                                                        color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text("Raise Issue"),
                                                  ],
                                                ),
                                              ),
                                            );

                                            menus.add(
                                              const PopupMenuItem(
                                                value: "drawing",
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.picture_as_pdf,
                                                        color: Colors.red,
                                                        size: 18),
                                                    SizedBox(width: 8),
                                                    Text("Drawing PDF"),
                                                  ],
                                                ),
                                              ),
                                            );

                                            if (status == "accepted" ||
                                                status == "in process" ||
                                                status == "partially completed") {
                                              menus.add(
                                                const PopupMenuItem(
                                                  value: "dispatch",
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.local_shipping,
                                                          color: Colors.blue,
                                                          size: 18),
                                                      SizedBox(width: 8),
                                                      Text("Dispatch Material"),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }

                                            return menus;
                                          },
                                        )
                                      ],
                                    ),
                                  ),

                                  // Item Name

                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          item["item_name"].toString(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          "Item Code : ${item["item_code"]}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Divider(height: 1),

                                        // Table

                                        Table(
                                    border: TableBorder.all(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                    children: [

                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                        ),
                                        children: [
                                          tableHeader("Drawing"),
                                          tableHeader("Issue"),
                                          tableHeader("Finish"),
                                          tableHeader("Balance"),
                                        ],
                                      ),

                                      TableRow(
                                        children: [
                                          tableValue(
                                            item["drawing_no"].toString(),
                                          ),
                                          tableValue(
                                            item["issue_qty"].toString(),
                                          ),
                                          tableValue(
                                            item["complete_qty"].toString(),
                                          ),
                                          tableValue(
                                            item["pending_qty"].toString(),
                                          ),
                                        ],
                                      ),

                                      TableRow(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                        ),
                                        children: [

                                          tableHeader("Issue Dt"),

                                          tableValue(
                                            item["issue_date"]
                                                .toString(),
                                          ),

                                          tableHeader("Return Dt"),

                                          tableValue(
                                            item["return_date"]
                                                    ?.toString() ??
                                                "-",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [

                                            Row(
                                              children: [

                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),

                                                const SizedBox(width: 5),

                                                Text(
                                                  item["issue_date"]
                                                      .toString(),
                                                  style:
                                                      const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Text(
                                              "${(progress * 100).toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                color:
                                                    Color(0xff2563EB),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 8,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        buildStatusActions(item),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  void applyFilters() {

  List<dynamic> data = jobWorkList;

  // Search Filter
  if (searchController.text.isNotEmpty) {

    final search =
        searchController.text.toLowerCase();

    data = data.where((item) {

      return item["jobwork_no"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["item_name"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["drawing_no"]
              .toString()
              .toLowerCase()
              .contains(search);

    }).toList();
  }

  // Status Filter
  if (selectedStatus != "All") {

    data = data.where((item) {

      return item["status"]
              .toString()
              .toLowerCase() ==
          selectedStatus;

    }).toList();
  }

  setState(() {
    filteredList = data;
  });
}
  void showApproveDialog(dynamic item) {

  final remarkController =
      TextEditingController();

  DateTime? returnDate;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {

      return StatefulBuilder(
        builder: (context, setDialogState) {

          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom +
                  20,
            ),

            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color:
                          Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const CircleAvatar(
                    radius: 32,
                    backgroundColor:
                        Color(0xffDCFCE7),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Accept Job Work",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    item["jobwork_no"]
                        .toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 15),

                  InkWell(
                    onTap: () async {

                      final picked =
                          await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now(),
                        firstDate:
                            DateTime.now(),
                        lastDate:
                            DateTime(2100),
                      );

                      if (picked != null) {
                        setDialogState(() {
                          returnDate =
                              picked;
                        });
                      }
                    },

                    child: Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets.all(
                        15,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.calendar_month,
                            color:
                                Colors.blue,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Text(
                              returnDate ==
                                      null
                                  ? "Expected Return Date"
                                  : "${returnDate!.day}/${returnDate!.month}/${returnDate!.year}",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,

                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check,
                      ),

                      label: const Text(
                        "Accept Job Work",
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.green,
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),

                      onPressed: () async {

                        if (returnDate ==
                            null) {

                          Get.snackbar(
                            "Validation",
                            "Please select return date",
                          );

                          return;
                        }

                        try {

                          await JobWorkService.updateJobWorkStatus(
                            action: "approve",
                            issueId: item["issue_id"].toString(),
                            remark: remarkController.text,
                            returnDate: returnDate!
                                .toIso8601String()
                                .split('T')
                                .first,
                          );

                          Navigator.pop(
                              context);

                          await fetchJobWorkData();

                          Get.snackbar(
                            "Success",
                            "Job Work Accepted Successfully",
                            backgroundColor:
                                Colors.green,
                            colorText:
                                Colors.white,
                          );

                        } catch (e) {

                          Get.snackbar(
                            "Error",
                            e.toString(),
                            backgroundColor:
                                Colors.red,
                            colorText:
                                Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showDispatchDialog(dynamic item) {

  final challanController =
      TextEditingController();
  final remarkController = 
      TextEditingController();

  DateTime? dispatchDate;

  showDialog(
    context: context,
    builder: (context) {

      return StatefulBuilder(
        builder: (context, setDialogState) {

          return AlertDialog(
            title: const Text(
              "Dispatch Material",
            ),

            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  TextField(
                    controller: challanController,
                    decoration:
                        const InputDecoration(
                      labelText: "Challan No",
                    ),
                  ),

                  const SizedBox(height: 10),

                  ListTile(
                    contentPadding:
                        EdgeInsets.zero,
                    title: Text(
                      dispatchDate == null
                          ? "Select Dispatch Date"
                          : "${dispatchDate!.day}/${dispatchDate!.month}/${dispatchDate!.year}",
                    ),
                    trailing: const Icon(
                      Icons.calendar_month,
                    ),
                    onTap: () async {

                      final picked =
                          await showDatePicker(
                        context: context,
                        firstDate:
                            DateTime(2020),
                        lastDate:
                            DateTime(2100),
                        initialDate:
                            DateTime.now(),
                      );

                      if (picked != null) {

                        setDialogState(() {

                          dispatchDate =
                              picked;
                        });
                      }
                    }, 
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: remarkController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Remark",
                    ),
                  ),
                ],
              ),
            ),

            actions: [

              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child:
                    const Text("Cancel"),
              ),

              ElevatedButton(
                onPressed: () async {

                  if (challanController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Validation",
                      "Enter Challan No",
                    );
                    return;
                  }

                  if (dispatchDate == null) {
                    Get.snackbar(
                      "Validation",
                      "Select Dispatch Date",
                    );
                    return;
                  }

                  final data = {
                    "jobwork_no": item["jobwork_no"],
                    "challan_no": challanController.text,
                    "dispatch_date":
                        dispatchDate?.toIso8601String(),
                    "remark":
                        remarkController.text,
                  };

                  debugPrint(data.toString());

                  // await JobWorkService.dispatchMaterial(data);

                  final result =
                      await JobWorkService.dispatchMaterial(
                    data,
                  );

                  if (result["success"] == true) {

                    Navigator.pop(context);

                    await fetchJobWorkData();

                    Get.snackbar(
                      "Success",
                      result["message"] ??
                          "Material Dispatched",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );

                  } else {

                    Get.snackbar(
                      "Error",
                      result["message"] ??
                          "Dispatch Failed",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    },
  );
}

  // ================= TEXT BOX =================


  static Widget tableHeader(
  String text,
) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

static Widget tableValue(
  String text,
) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}

Widget summaryBox(
  String title,
  int count,
) {
  return Column(
    children: [

      Text(
        count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
        ),
      ),
    ],
  );
}
Widget buildStatusActions(
  dynamic item,
) {

  final status =
      item["status"]
          .toString()
          .toLowerCase();

  if (status == "assigned") {

    return ActionChip(
      avatar: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 18,
      ),
      label: const Text(
        "Accept Job Work",
      ),
      onPressed: () =>
          showApproveDialog(item),
    );
  }

  if (status == "accepted") {

    return ActionChip(
      avatar: const Icon(
        Icons.play_arrow,
        color: Colors.blue,
        size: 18,
      ),
      label: const Text(
        "Start Production",
      ),
      onPressed: () async {

        final result =
            await JobWorkService.updateJobWorkStatus(
          action: "start",
          issueId:
              item["issue_id"].toString(),
        );

        if (result["success"] == true) {

          await fetchJobWorkData();

          Get.snackbar(
            "Success",
            result["message"],
            backgroundColor:
                Colors.green,
            colorText:
                Colors.white,
          );
        }
      },
    );
  }

  if (status == "in process" ||
    status == "partially completed") {

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [

        ActionChip(
          avatar: const Icon(
            Icons.done_all,
            color: Colors.green,
            size: 18,
          ),
          label: Text(
            status == "partially completed"
                ? "Add Finish Qty"
                : "Complete",
          ),
          onPressed: () {
            showCompleteDialog(item);
          },
        ),

        ActionChip(
          avatar: const Icon(
            Icons.local_shipping,
            color: Colors.orange,
            size: 18,
          ),
          label: const Text(
            "Dispatch",
          ),
          onPressed: () =>
              showDispatchDialog(
            item,
          ),
        ),
      ],
    );
  }

  if (status == "completed") {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green
            .withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [

          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 18,
          ),

          SizedBox(width: 6),

          Text(
            "Completed",
            style: TextStyle(
              color: Colors.green,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  return const SizedBox();
}

void showCompleteDialog(dynamic item) {

  final qtyController =
      TextEditingController();

  final noteController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(

      title: const Text(
        "Complete Production",
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 10),

            TextField(
              controller: qtyController,
              keyboardType:
                  TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Finish Qty",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Remarks",
              ),
            ),
          ],
        ),
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () async {

            final result =
                await JobWorkService.completeJobWork(
              issueId:
                  item["issue_id"].toString(),
              finishQty:
                  qtyController.text,
              remarks:
                  noteController.text,
            );

            if (result["success"] == true) {

              Navigator.pop(context);

              await fetchJobWorkData();

              Get.snackbar(
                "Success",
                result["message"],
                backgroundColor:
                    Colors.green,
                colorText:
                    Colors.white,
              );
            }
          },
          child: const Text(
            "Submit",
          ),
        ),
      ],
    ),
  );
}
void showIssueDialog(dynamic item) {

  final noteController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(

      title: const Text(
        "Raise Query / Problem",
      ),

      content: TextField(
        controller: noteController,
        maxLines: 5,
        decoration: const InputDecoration(
          hintText:
              "Describe your problem...",
          border:
              OutlineInputBorder(),
        ),
      ),

      actions: [

        TextButton(
          onPressed: () =>
              Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () async {

            await JobWorkService.updateJobWorkStatus(
              action: "issue",
              issueId:
                  item["issue_id"]
                      .toString(),
              remark:
                  noteController.text,
            );

            Navigator.pop(context);

            Get.snackbar(
              "Success",
              "Issue Submitted",
            );
          },
          child: const Text(
            "Submit",
          ),
        ),
      ],
    ),
  );
}
}