import 'api_service.dart';

class PurchaseOrderService {

  // ================= PURCHASE ORDER LIST =================

  static Future<List<dynamic>> getPurchaseOrders(
    String vendorCode,
  ) async {

    final response = await ApiService.get(
      "purchase_orders.php?vendor_code=$vendorCode",
    );

    if (response != null && response is List) {

      return response;

    } else {

      return [];
    }
  }

  static Future<bool> updatePurchase({
    required String PONo,
    required String completeQty,
    required String pendingQty,
    required String status,
  }) async {

    final response = await ApiService.post(
      "update_jobwork.php",
      {
        "PONo": PONo,
        "complete_qty": completeQty,
        "pending_qty": pendingQty,
        "status": status,
      },
    );

    return response != null &&
        response["status"] == true;
  }

  // ================= STATUS UPDATE =================

static Future<Map<String, dynamic>>updatePOStatus({
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
completePO({
  required String issueId,
  required String finishQty,
  String remarks = "",
}) async {

  return await updatePOStatus(
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