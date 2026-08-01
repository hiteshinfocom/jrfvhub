import 'package:flutter/material.dart';
import '../../services/dispatch_service.dart';
import '../../services/auth_service.dart';

class DispatchScreen extends StatefulWidget {

  final bool todayOnly;

  const DispatchScreen({
    super.key,
    this.todayOnly = false,
  });

  @override
  State<DispatchScreen> createState() =>
      _DispatchScreenState();
}

class _DispatchScreenState
    extends State<DispatchScreen> {

  final TextEditingController searchController =
    TextEditingController();

List<dynamic> transportList = [];
List<dynamic> filteredList = [];

bool isLoading = true;

/// Filter
String selectedStatus = "All";
String selectedDateFilter = "All";

/// Summary
int totalDispatch = 0;
int deliveredCount = 0;
int transitCount = 0;
int pendingCount = 0;

Widget filterChip(
  String status,
  StateSetter setSheetState,
) {
  return ChoiceChip(
    label: Text(status),
    selected: selectedStatus == status,
    onSelected: (_) {
      setSheetState(() {
        selectedStatus = status;
      });
    },
  );
}

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadDispatch();
  }

  void searchDispatch(String value) {
  final query = value.trim().toLowerCase();

  if (query.isEmpty) {
    filteredList = List.from(transportList);

    setState(() {});
    return;
  }

  filteredList = transportList.where((item) {

    bool contains(dynamic field) =>
        field
            .toString()
            .toLowerCase()
            .contains(query);

    return

        contains(item['itemCode']) ||

        contains(item['DrawingNo']) ||

        contains(item['Itemname']) ||

        contains(item['DriverName']) ||

        contains(item['VehicleNo']) ||

        contains(item['Department']) ||

        contains(item['Status']) ||

        contains(item['Remark']) ||

        contains(item['Qty']) ||

        contains(item['DateOfPickUp']);

  }).toList();

  setState(() {});
}

Future<void> loadDispatch() async {
  setState(() {
    isLoading = true;
  });

  try {
    final vendor = await AuthService.getVendor();

    final data = await DispatchService.getDispatchList(
      vendor['partycode'] ?? '',
      vendor['usertype'] ?? 'Vendor',
    );

    transportList = data;

    // Calculate summary counts
    calculateSummary();

    // Initially show all data
    filteredList = List.from(transportList);

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    debugPrint("Dispatch Error: $e");

    setState(() {
      isLoading = false;
      transportList = [];
      filteredList = [];
    });
  }
}

  Color statusColor(String status) {
  switch (status.toUpperCase()) {
    case "DELIVERED":
      return Colors.green;

    case "IN TRANSIT":
      return Colors.orange;

    case "PENDING":
      return Colors.red;

    default:
      return Colors.blue;
  }
}

void calculateSummary() {
  totalDispatch = transportList.length;

  deliveredCount = transportList.where((item) {
    return (item['Status'] ?? '')
            .toString()
            .trim()
            .toUpperCase() ==
        "DELIVERED";
  }).length;

  transitCount = transportList.where((item) {
    final status = (item['Status'] ?? '')
        .toString()
        .trim()
        .toUpperCase();

    return status == "IN TRANSIT" ||
        status == "TRANSIT";
  }).length;

  pendingCount = transportList.where((item) {
    return (item['Status'] ?? '')
            .toString()
            .trim()
            .toUpperCase() ==
        "PENDING";
  }).length;
}

Widget summaryCard(
  String title,
  String value,
  Color color,
  IconData icon,
) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [

        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [

              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

void showFilterBottomSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                const Center(
                  child: Text(
                    "Filter Dispatch",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 8,
                  children: [
                    filterChip("All", setSheetState),
                    filterChip("Delivered", setSheetState),
                    filterChip("In Transit", setSheetState),
                    filterChip("Pending", setSheetState),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      applyFilter();
                    },
                    child: const Text("Apply Filter"),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    selectedStatus = "All";
                    Navigator.pop(context);
                    applyFilter();
                  },
                  child: const Text("Reset"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}



void applyFilter() {
  final now = DateTime.now();

  filteredList = transportList.where((item) {

    //-------------------------
    // STATUS FILTER
    //-------------------------

    bool statusMatch = true;

    if (selectedStatus != "All") {

      final status = (item['Status'] ?? '')
          .toString()
          .trim()
          .toUpperCase();

      switch (selectedStatus) {

        case "Delivered":
          statusMatch = status == "DELIVERED";
          break;

        case "In Transit":
          statusMatch =
              status == "IN TRANSIT" ||
              status == "TRANSIT";
          break;

        case "Pending":
          statusMatch = status == "PENDING";
          break;
      }
    }

    //-------------------------
    // DATE FILTER
    //-------------------------

    bool dateMatch = true;

    if (selectedDateFilter != "All") {

      try {

        final dispatchDate =
            DateTime.parse(
                item['DateOfPickUp']);

        switch (selectedDateFilter) {

          case "Today":

            dateMatch =
                dispatchDate.year ==
                    now.year &&
                dispatchDate.month ==
                    now.month &&
                dispatchDate.day ==
                    now.day;

            break;

          case "Last 7 Days":

            dateMatch = dispatchDate.isAfter(
              now.subtract(
                const Duration(days: 7),
              ),
            );

            break;

          case "This Month":

            dateMatch =
                dispatchDate.month ==
                    now.month &&
                dispatchDate.year ==
                    now.year;

            break;
        }

      } catch (_) {
        dateMatch = false;
      }
    }

    return statusMatch && dateMatch;

  }).toList();

  searchDispatch(searchController.text);

  setState(() {});
}


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff5f7fb),

      appBar: AppBar(

        elevation: 0,

        centerTitle: true,

        flexibleSpace: Container(
          decoration:
              const BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                Color(0xff2563EB),
                Color(0xff1E40AF),
              ],
            ),
          ),
        ),

        title: const Text(
          "Dispatch Status",
          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: Column(

        children: [

          // SUMMARY CARD

          Padding(
  padding: const EdgeInsets.all(12),
  child: GridView.count(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 2,
    childAspectRatio: 2.2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    children: [

      summaryCard(
        "Total",
        totalDispatch.toString(),
        Colors.blue,
        Icons.inventory_2,
      ),

      summaryCard(
        "Delivered",
        deliveredCount.toString(),
        Colors.green,
        Icons.check_circle,
      ),

      summaryCard(
        "Transit",
        transitCount.toString(),
        Colors.orange,
        Icons.local_shipping,
      ),

      summaryCard(
        "Pending",
        pendingCount.toString(),
        Colors.red,
        Icons.pending_actions,
      ),
    ],
  ),
),

          // SEARCH

          Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            child: Row(
  children: [

    Expanded(
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          searchDispatch(value);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText:
              "Search Item, Drawing, Driver, Vehicle...",

          prefixIcon: const Icon(Icons.search),

          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    searchDispatch("");
                    setState(() {});
                  },
                )
              : null,

          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),

    const SizedBox(width: 10),

    InkWell(
      onTap: showFilterBottomSheet,
      borderRadius:
          BorderRadius.circular(15),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius:
              BorderRadius.circular(15),
        ),
        child: const Icon(
          Icons.filter_alt_rounded,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
          ),

          const SizedBox(height: 10),

          Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : filteredList.isEmpty
                  ? const Center(
                      child: Text(
                        "No Dispatch Found",
                      ),
                    )
              : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {

                final item = filteredList[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [

                            CircleAvatar(
                              backgroundColor:
                                  Colors.blue.shade50,
                              child: const Icon(
                                Icons.local_shipping,
                                color: Colors.blue,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    item['itemCode'] ?? '',
                                    style:
                                        const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    item['DrawingNo'] ?? '',
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(
                                  item['Status'] ?? '',
                                ).withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                item['Status'] ?? '',
                                style: TextStyle(
                                  color: statusColor(
                                    item['Status'] ?? '',
                                  ),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Table(
                          border: TableBorder.all(
                            color:
                                Colors.grey.shade300,
                          ),
                          children: [

                            TableRow(
                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.blue.shade50,
                              ),
                              children: const [

                                _TableHeader(
                                    "Item"),

                                _TableHeader(
                                    "Qty"),

                                _TableHeader(
                                    "Dept"),
                              ],
                            ),

                            TableRow(
                              children: [

                                _tableValue(
                                  item['Itemname']
                                          ?.toString() ??
                                      '',
                                ),

                                _tableValue(
                                  item['Qty']
                                          ?.toString() ??
                                      '',
                                ),

                                _tableValue(
                                  item['Department']
                                          ?.toString() ??
                                      '',
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Table(
                          border: TableBorder.all(
                            color:
                                Colors.grey.shade300,
                          ),
                          children: [

                            TableRow(
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .orange.shade50,
                              ),
                              children: const [

                                _TableHeader(
                                    "Driver"),

                                _TableHeader(
                                    "Vehicle"),

                                _TableHeader(
                                    "Pickup"),
                              ],
                            ),

                            TableRow(
                              children: [

                                _tableValue(
                                  item['DriverName']
                                          ?.toString() ??
                                      '',
                                ),

                                _tableValue(
                                  item['VehicleNo']
                                          ?.toString() ??
                                      '',
                                ),

                                _tableValue(
                                  item['DateOfPickUp']
                                          ?.toString() ??
                                      '',
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets.all(
                            10,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .grey.shade100,
                            borderRadius:
                                BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              const Text(
                                "Remark",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 5),

                              Text(
                                item['Remark']
                                        ?.toString() ??
                                    '',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }

  static Widget _tableValue(
      String text) {
    return Padding(
      padding:
          const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign:
            TextAlign.center,
      ),
    );
  }
}

class _TableHeader
    extends StatelessWidget {

  final String text;

  const _TableHeader(
    this.text,
  );

  @override
  Widget build(
      BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign:
            TextAlign.center,
        style:
            const TextStyle(
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}