import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/po_service.dart';

class PurchaseOrderScreen
    extends StatefulWidget {

  const PurchaseOrderScreen({
    super.key,
  });

  @override
  State<PurchaseOrderScreen>
      createState() =>
          _PurchaseOrderScreenState();
}

class _PurchaseOrderScreenState
    extends State<PurchaseOrderScreen> {

  bool isLoading = true;

  // 👇 Add here
  bool isGridView = false;

  String vendorCode = "";

  List<dynamic> poList = [];

  List<dynamic> filteredList = [];

  final TextEditingController
      searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {

    final user =
        await AuthService.getUser();

    vendorCode =
        user["partycode"] ?? "";

    final data =
        await PurchaseOrderService
            .getPurchaseOrders(
      vendorCode,
    );

    setState(() {

      poList = data;

      filteredList = data;

      isLoading = false;
    });
  }

  void searchPO(String value) {

  if (value.isEmpty) {
    setState(() {
      filteredList = poList;
    });
    return;
  }

  final search = value.toLowerCase();

  setState(() {

    filteredList =
        poList.where((item) {

      return item["PONo"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["ItemName"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["ItemCode"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["DrawingNo"]
              .toString()
              .toLowerCase()
              .contains(search);

    }).toList();
  });
}

  Color statusColor(String status) {

  switch (status.toLowerCase()) {

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
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xfff5f7fb,
      ),

      appBar: AppBar(
        title: const Text("Purchase Orders"),
        actions: [
          IconButton(
            icon: Icon(
              isGridView
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),

      body: Column(

        children: [

          Container(

            margin:
                const EdgeInsets.all(
              12,
            ),

            padding:
                const EdgeInsets.all(
              16,
            ),

            decoration:
                BoxDecoration(

              gradient:
                  const LinearGradient(
                colors: [

                  Color(
                    0xff2563EB,
                  ),

                  Color(
                    0xff3B82F6,
                  ),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Row(

              children: [

                const Icon(
                  Icons.shopping_bag,
                  color:
                      Colors.white,
                  size: 40,
                ),

                const SizedBox(
                  width: 15,
                ),

                Expanded(
                  child: Column(

                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Text(

                        "Total Purchase Orders",

                        style:
                            TextStyle(
                          color: Colors
                              .white70,
                        ),
                      ),

                      Text(

                        "${filteredList.length}",

                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                          fontSize:
                              26,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
            ),

            child: TextField(

              controller:
                  searchController,

              onChanged: (value) {
                searchPO(value);
                setState(() {});
              },

              decoration:
                  InputDecoration(

                hintText:
                    "Search PO",

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

          const SizedBox(
            height: 10,
          ),

          Expanded(
  child: isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )

      : isGridView

          ? GridView.builder(
              padding: const EdgeInsets.all(10),

              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio:
                    MediaQuery.of(context).size.width < 600
                        ? 0.85
                        : 1.2,
              ),

              itemCount:
                  filteredList.length,

              itemBuilder:
                  (context, index) {

                return poGridCard(
                  filteredList[index],
                );
              },
            )

          : ListView.builder(
              itemCount:
                  filteredList.length,

              itemBuilder:
                  (context, index) {

                final item =
                    filteredList[index];

                double issueQty =
                double.tryParse(
                  item["issueqty"].toString(),
                ) ?? 0;

                double finishQty =
                    double.tryParse(
                      item["FinishQty"].toString(),
                    ) ?? 0;

                double progress =
                    issueQty == 0
                        ? 0
                        : finishQty / issueQty;

                      return Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            // HEADER

                            Container(
                              padding:
                                  const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius:
                                    const BorderRadius.only(
                                  topLeft:
                                      Radius.circular(16),
                                  topRight:
                                      Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [

                                        Text(
                                          item["PONo"],
                                          style:
                                              const TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          item["issuedate"],
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor(
                                        item["status"],
                                      ).withValues(alpha: .15),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item["status"],
                                      style: TextStyle(
                                        color: statusColor(
                                          item["status"],
                                        ),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ITEM NAME

                            Padding(
                              padding:
                                  const EdgeInsets.all(12),
                              child: Align(
                                alignment:
                                    Alignment.centerLeft,
                                child: Text(
                                  item["ItemName"],
                                  style:
                                      const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            Table(
                              border: TableBorder.all(
                                color:
                                    Colors.grey.shade300,
                                width: .5,
                              ),
                              children: [

                                TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
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
                                    tableValue(item["DrawingNo"]),
                                    tableValue(item["issueqty"]),
                                    tableValue(item["FinishQty"]),
                                    tableValue(item["BalacnceQty"]),
                                  ],
                                ),
                              ],
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(12),
                              child: Column(
                                children: [

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [

                                      Text(
                                        "Return : ${item["returndate"] ?? "-"}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Text(
                                        "${(progress * 100).toStringAsFixed(0)}%",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 8,
                                  ),

                                  LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 8,
                                    borderRadius:
                                        BorderRadius.circular(
                                      10,
                                    ),
                                    valueColor:
                                        AlwaysStoppedAnimation(
                                      statusColor(
                                        item["status"],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  static Widget tableHeader(
  String text,
) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    ),
  );
}

static Widget tableValue(
  dynamic text,
) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      text.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
      ),
    ),
  );
}
Widget poGridCard(dynamic item) {

  double issueQty =
    double.tryParse(
      item["issueqty"].toString(),
    ) ?? 0;

  double finishQty =
      double.tryParse(
        item["FinishQty"].toString(),
      ) ?? 0;

  double progress =
      issueQty == 0
          ? 0
          : finishQty / issueQty;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          item["PONo"].toString(),
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          item["ItemName"].toString(),
          maxLines: 2,
          overflow:
              TextOverflow.ellipsis,
        ),

        const Spacer(),

        Text(
          "Issue : ${item["issueqty"]}",
        ),

        Text(
          "Finish : ${item["FinishQty"]}",
        ),

        Text(
          "Balance : ${item["BalacnceQty"]}",
        ),

        const SizedBox(height: 8),

        LinearProgressIndicator(
          value: progress,
        ),
      ],
    ),
  );
}
}