import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../dialogs/accept_dialog.dart';
import '../../models/planning_model.dart';
import '../../services/planning_service.dart';
import '../../widgets/planning_card.dart';
import '../../screens/dashboard/pdf_viewer_screen.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  State<PlanningScreen> createState() => _PlanningScreenState();
}

class _PlanningScreenState
    extends State<PlanningScreen> {

  final TextEditingController searchController =
      TextEditingController();

  List<PlanningModel> planningList = [];

  List<PlanningModel> filteredList = [];

  bool loading = true;
  String vendorCode = "";

  @override
void initState() {
  super.initState();

  searchController.addListener(searchPlanning);

  loadVendorData();
}
void showMessageDialog({
  required String message,
  required bool success,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(success ? "Success" : "સૂચના"),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("બરાબર"),
          ),
        ],
      );
    },
  );
}

Future<void> loadVendorData() async {
  final user = await AuthService.getUser();

  vendorCode = user["partycode"] ?? "";

  await loadPlanning();
}

  Future<void> loadPlanning() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    try {
      final data = await PlanningService.getPlanning(
        vendorCode,
      );

      if (!mounted) return;

      setState(() {
        planningList = data;
        filteredList = data;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> downloadExcel() async {
  try {
    await PlanningService.downloadExcel(vendorCode);

    if (!mounted) return;

    showMessageDialog(
      success: true,
      message: "Planning Excel downloaded successfully.",
    );
  } catch (e) {
    if (!mounted) return;

    showMessageDialog(
      success: false,
      message: e.toString(),
    );
  }
}

  Future<void> acceptPlanning(PlanningModel planning) async {

  if (planning.weekStartDate == null ||
      planning.weekEndDate == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Planning Week Not Found"),
      ),
    );

    return;
  }

  final acceptResult = await AcceptDialog.show(
  context: context,
  weekStartDate: planning.weekStartDate!,
  weekEndDate: planning.weekEndDate!,
);

if (acceptResult == null) return;

final result = await PlanningService.acceptPlanning(
  planningId: planning.id,
  vendorCode: vendorCode,
  completionDate: DateFormat("yyyy-MM-dd").format(
    acceptResult.date,
  ),
  reason: acceptResult.reason,
  isExtended: acceptResult.isExtended,
);

if (!mounted) return;

showMessageDialog(
  message: result["message"] ?? "",
  success: result["status"] == true,
);

if (result["status"] == true) {
  loadPlanning();
}
}

Future<void> rejectPlanning(
    PlanningModel planning) async {

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {

      return AlertDialog(

        title:
            const Text("Reject Planning"),

        content: const Text(
          "Are you sure you want to reject this planning?",
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Reject",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

        ],
      );
    },
  );

  if (confirm != true) return;

  final result = await PlanningService.rejectPlanning(
  planningId: planning.id,
  vendorCode: vendorCode,
);

if (!mounted) return;

showMessageDialog(
  message: result["message"] ?? "",
  success: result["status"] == true,
);

if (result["status"] == true) {
  loadPlanning();
}
}

  void searchPlanning() {

    final keyword =
        searchController.text.toLowerCase();

    if (keyword.isEmpty) {

      setState(() {
        filteredList = planningList;
      });

      return;
    }

    setState(() {

      filteredList = planningList.where((e) {

        return e.drawingNo
                .toLowerCase()
                .contains(keyword) ||

            e.itemDesc
                .toLowerCase()
                .contains(keyword);

      }).toList();

    });

  }

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Planning"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search Drawing / Item",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: downloadExcel,
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  "Download Excel",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: buildBody(),
          ),

        ],
      ),

    );
  }

  Widget buildBody() {

    if (loading) {

      return const Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (filteredList.isEmpty) {

      return const Center(
        child: Text(
          "No Planning Found",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return RefreshIndicator(

      onRefresh: loadPlanning,

      child: ListView.builder(

        padding:
            const EdgeInsets.only(
          bottom: 20,
        ),

        itemCount:
            filteredList.length,

        itemBuilder:
            (context, index) {

          final planning =
              filteredList[index];

          return PlanningCard(
          planning: planning,

          onPdf: () {
            if (planning.drawingPdf.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Drawing PDF Not Available"),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PdfViewerScreen(
                  pdfUrl: planning.drawingPdf,
                  drawingNo: planning.drawingNo,
                ),
              ),
            );
          },

          onAccept: () {
            acceptPlanning(planning);
          },

          onReject: () {
            rejectPlanning(planning);
          },
        );

        },

      ),

    );

  }

}