import 'api_service.dart';

class ReadyStockService {

  static Future<List<dynamic>> getReadyStock(
      String partyCode) async {

    final response =
        await ApiService.get(
      "ready_stock.php?partycode=$partyCode",
    );

    if (response != null &&
        response is List) {
      return response;
    }

    return [];
  }
}