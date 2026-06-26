import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/ready_stock_service.dart';

class ReadyStockScreen extends StatefulWidget {
  const ReadyStockScreen({super.key});

  @override
  State<ReadyStockScreen> createState() =>
      _ReadyStockScreenState();
}

class _ReadyStockScreenState
    extends State<ReadyStockScreen> {

bool isLoading = true;

String partyCode = "";

List<dynamic> stockList = [];

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

  partyCode =
      user["partycode"] ?? "";

  final data =
      await ReadyStockService
          .getReadyStock(
    partyCode,
  );

  setState(() {

    stockList = data;

    filteredList = data;

    isLoading = false;
  });
}
void searchItem(String value) {

  if (value.isEmpty) {

    setState(() {
      filteredList = stockList;
    });

    return;
  }

  final search =
      value.toLowerCase();

  setState(() {

    filteredList =
        stockList.where((item) {

      return item["item_name"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["item_code"]
              .toString()
              .toLowerCase()
              .contains(search) ||

          item["drawing_no"]
              .toString()
              .toLowerCase()
              .contains(search);

    }).toList();
  });
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
          "Ready Stock",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                    Icons.inventory_2,
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
                        "Ready Items",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      Text(
                        "${filteredList.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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

            child: TextField(

              controller:
                  searchController,
                  onChanged: searchItem,

              decoration:
                  InputDecoration(

                hintText:
                    "Search Item",

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
                : ListView.builder(

              padding:
                  const EdgeInsets.all(10),

              itemCount: filteredList.length,

              itemBuilder: (context, index) {

                final item =
                    filteredList[index];

                double qty =
                    double.tryParse(
                      item["complete_qty"]
                          .toString(),
                    ) ??
                    0;

                return Container(

                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  decoration:
                      BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color: Colors
                            .grey.shade200,
                        blurRadius: 6,
                        offset:
                            const Offset(
                          0,
                          2,
                        ),
                      ),
                    ],
                  ),

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      14,
                    ),

                    child: Column(

                      children: [

                        Row(

                          children: [

                            CircleAvatar(

                              backgroundColor:
                                  Colors.blue
                                      .shade50,

                              child:
                                  const Icon(
                                Icons
                                    .inventory,
                                color:
                                    Colors.blue,
                              ),
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            Expanded(

                              child: Text(
                                item["item_name"]
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Container(

                              padding:
                                  const EdgeInsets.symmetric(

                                horizontal:
                                    10,

                                vertical: 4,
                              ),

                              decoration:
                                  BoxDecoration(

                                color: qty > 100
                                    ? Colors
                                        .green
                                        .withValues(
                                        alpha:
                                            .15,
                                      )
                                    : Colors
                                        .orange
                                        .withValues(
                                        alpha:
                                            .15,
                                      ),

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),

                              child: Text(

                                qty > 100
                                    ? "Available"
                                    : "Low Stock",

                                style:
                                    TextStyle(

                                  color:
                                      qty > 100
                                          ? Colors
                                              .green
                                          : Colors
                                              .orange,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Table(

                          border:
                              TableBorder.all(

                            color: Colors
                                .grey
                                .shade300,
                          ),

                          children: [

                            TableRow(

                              decoration:
                                  BoxDecoration(

                                color: Colors
                                    .blue
                                    .shade50,
                              ),

                              children: const [
                                _TableHeader("Item Code"),
                                _TableHeader("Qty"),
                                _TableHeader("Drawing"),
                              ],
                            ),

                            TableRow(
                              children: [

                                _tableValue(
                                  item["item_code"]
                                      .toString(),
                                ),

                                _tableValue(
                                  item["complete_qty"]
                                      .toString(),
                                ),

                                _tableValue(
                                  item["drawing_no"]
                                      .toString(),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Builder(
                          builder: (_) {

                            double issueQty =
                                double.tryParse(
                                  item["issue_qty"]
                                      .toString(),
                                ) ??
                                0;

                            double progress =
                                issueQty == 0
                                    ? 0
                                    : qty / issueQty;

                            return LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              minHeight: 8,
                              borderRadius:
                                  BorderRadius.circular(10),
                            );
                          },
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