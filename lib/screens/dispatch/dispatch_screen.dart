import 'package:flutter/material.dart';
import '../../services/dispatch_service.dart';
import '../../services/auth_service.dart';

class DispatchScreen extends StatefulWidget {
  const DispatchScreen({super.key});

  @override
  State<DispatchScreen> createState() =>
      _DispatchScreenState();
}

class _DispatchScreenState
    extends State<DispatchScreen> {

  final TextEditingController
      searchController =
      TextEditingController();
      List<dynamic> transportList = [];
List<dynamic> filteredList = [];

bool isLoading = true;

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

Future<void> loadDispatch() async {
  try {
    final vendor =
        await AuthService.getVendor();

    final data =
        await DispatchService.getDispatchList(
      vendor['partycode'] ?? '',
      vendor['usertype'] ?? 'Vendor',
    );

    setState(() {
      transportList = data;
      filteredList = data;
      isLoading = false;
    });
  } catch (e) {
    debugPrint(e.toString());

    setState(() {
      isLoading = false;
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

          Container(

            margin:
                const EdgeInsets.all(12),

            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(

              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xff2563EB),
                  Color(0xff3B82F6),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Row(

              children: [

                const CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      Colors.white24,
                  child: Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 28,
                  ),
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Total Dispatch",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      Text(
                        filteredList.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // SEARCH

          Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            child: TextField(

              controller: searchController,

              onChanged: (value) {

                setState(() {

                  filteredList =
                      transportList.where((item) {

                    return item['itemCode']
                            .toString()
                            .toLowerCase()
                            .contains(
                              value.toLowerCase(),
                            ) ||

                        item['DrawingNo']
                            .toString()
                            .toLowerCase()
                            .contains(
                              value.toLowerCase(),
                            );

                  }).toList();
                });
              },

              decoration: InputDecoration(

                hintText:
                    "Search Item Code / Drawing No",

                prefixIcon:
                    const Icon(
                  Icons.search,
                ),

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
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