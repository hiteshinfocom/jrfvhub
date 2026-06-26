import 'api_service.dart';

class JobWorkService {

  static Future<List<dynamic>> getJobWorkList(
    String vendorCode,
  ) async {

    final response = await ApiService.get(
      "jobwork_list.php?partycode=$vendorCode",
    );

    if (response is List) {
      return response;
    }

    return [];
  }

  static Future<bool> updateJobWork({
    required String jobworkNo,
    required String completeQty,
    required String pendingQty,
    required String status,
  }) async {

    final response = await ApiService.post(
      "update_jobwork.php",
      {
        "jobwork_no": jobworkNo,
        "complete_qty": completeQty,
        "pending_qty": pendingQty,
        "status": status,
      },
    );

    return response != null &&
        response["status"] == true;
  }

  // ================= STATUS UPDATE =================

static Future<Map<String, dynamic>>
updateJobWorkStatus({
  required String action,
  required String issueId,
  String remark = "",
  String returnDate = "",
  String challanNo = "",
  String qty = "",
  String vehicleNo = "",
  String driverName = "",
}) async {

  final response = await ApiService.post(
    "update_jobwork_status.php",
    {
      "action": action,
      "issue_id": issueId,
      "remark": remark,
      "return_date": returnDate,
      "challan_no": challanNo,
      "qty": qty,
      "vehicle_no": vehicleNo,
      "driver_name": driverName,
    },
  );

  return response ?? {};
}
static Future<Map<String, dynamic>>
completeJobWork({
  required String issueId,
  required String finishQty,
  String remarks = "",
}) async {

  return await updateJobWorkStatus(
    action: "complete",
    issueId: issueId,
    qty: finishQty,
    remark: remarks,
  );
}

static Future<Map<String, dynamic>>
dispatchMaterial(
  Map<String, dynamic> data,
) async {

  final response = await ApiService.post(
    "dispatch_material.php",
    data,
  );

  return response ?? {};
}
}