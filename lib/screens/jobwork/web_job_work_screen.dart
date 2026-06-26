import 'package:flutter/material.dart';
import '../../services/jw_service.dart';
import '../../services/auth_service.dart';
class JobWorkWebScreen extends StatefulWidget {
  const JobWorkWebScreen({super.key});

  @override
  State<JobWorkWebScreen> createState() =>
      _JobWorkWebScreenState();
}

class _JobWorkWebScreenState
    extends State<JobWorkWebScreen> {

  List jobWorkList = [];
  List filteredList = [];

  bool isLoading = false;

  final searchController =
      TextEditingController();

  String selectedStatus = "All";

  @override
    void initState() {
      super.initState();
      loadData();
    }

    Future<void> loadData() async {
      final user = await AuthService.getUser();

      final data =
          await JobWorkService.getJobWorkList(
        user["partycode"] ?? "",
      );

      setState(() {
        jobWorkList = data;
        filteredList = data;
      });
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff5f7fb),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            // HEADER

            Row(

              children: [

                const Text(
                  "Job Work Dashboard",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        filteredList = jobWorkList.where((e) {
                          return e["jobwork_no"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              e["item_name"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(value.toLowerCase());
                        }).toList();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search...",
                      prefixIcon: Icon(Icons.search),
                    ),
                  )
                ),
              ],
            ),

            const SizedBox(height: 20),

            // SUMMARY CARDS

            Row(

              children: [

                summaryCard(
                  "Total",
                  filteredList.length.toString(),
                  Colors.blue,
                ),

                const SizedBox(width: 15),

                summaryCard(
                  "Assigned",
                  jobWorkList
                      .where((e) =>
                          e["status"] ==
                          "assigned")
                      .length
                      .toString(),
                  Colors.orange,
                ),

                const SizedBox(width: 15),

                summaryCard(
                  "In Process",
                  jobWorkList
                      .where((e) =>
                          e["status"] ==
                          "in process")
                      .length
                      .toString(),
                  Colors.purple,
                ),

                const SizedBox(width: 15),

                summaryCard(
                  "Completed",
                  jobWorkList
                      .where((e) =>
                          e["status"] ==
                          "completed")
                      .length
                      .toString(),
                  Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FILTER

            Row(

              children: [

                SizedBox(
                  width: 250,
                  child:
                      DropdownButtonFormField<String>(
                        initialValue: selectedStatus,
                    items: const [

                      DropdownMenuItem(
                        value: "All",
                        child:
                            Text("All Status"),
                      ),

                      DropdownMenuItem(
                        value: "assigned",
                        child:
                            Text("Assigned"),
                      ),

                      DropdownMenuItem(
                        value: "accepted",
                        child:
                            Text("Accepted"),
                      ),

                      DropdownMenuItem(
                        value: "in process",
                        child:
                            Text("In Process"),
                      ),

                      DropdownMenuItem(
                        value: "completed",
                        child:
                            Text("Completed"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value ?? "All";

                        if (selectedStatus == "All") {
                          filteredList = jobWorkList;
                        } else {
                          filteredList = jobWorkList.where((e) {
                            return e["status"]
                                .toString()
                                .toLowerCase() ==
                                selectedStatus.toLowerCase();
                          }).toList();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // TABLE

            Expanded(

              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: SingleChildScrollView(

                  scrollDirection:
                      Axis.horizontal,

                  child: DataTable(

                   headingRowColor: WidgetStatePropertyAll(
  Colors.blue.shade50,
),

                    columns: const [

                      DataColumn(
                        label:
                            Text("Job No"),
                      ),

                      DataColumn(
                        label:
                            Text("Challan"),
                      ),

                      DataColumn(
                        label:
                            Text("Item"),
                      ),

                      DataColumn(
                        label:
                            Text("Drawing"),
                      ),

                      DataColumn(
                        label:
                            Text("Issue Qty"),
                      ),

                      DataColumn(
                        label:
                            Text("Finish Qty"),
                      ),

                      DataColumn(
                        label:
                            Text("Pending Qty"),
                      ),

                      DataColumn(
                        label:
                            Text("Status"),
                      ),

                      DataColumn(
                        label:
                            Text("Action"),
                      ),
                    ],

                    rows: filteredList.map(
                      (item) {

                        return DataRow(

                          cells: [

                            DataCell(
                              Text(
                                item["jobwork_no"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["challan_no"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["item_name"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["drawing_no"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["issue_qty"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["complete_qty"]
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text(
                                item["pending_qty"]
                                    .toString(),
                              ),
                            ),

                            DataCell(

                              Chip(
                                label: Text(
                                  item["status"]
                                      .toString(),
                                ),
                              ),
                            ),

                            DataCell(

                              PopupMenuButton(

                                itemBuilder:
                                    (context) => [

                                  const PopupMenuItem(
                                    value:
                                        "drawing",
                                    child: Text(
                                      "Drawing PDF",
                                    ),
                                  ),

                                  const PopupMenuItem(
                                    value:
                                        "dispatch",
                                    child: Text(
                                      "Dispatch",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryCard(
    String title,
    String value,
    Color color,
  ) {

    return Expanded(

      child: Container(

        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: color,
          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Column(

          children: [

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}