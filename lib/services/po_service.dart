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
}