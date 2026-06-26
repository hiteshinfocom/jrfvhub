import 'api_service.dart';

class DispatchService {

  static Future<List<dynamic>>
  getDispatchList(
    String partyCode,
    String userType,
  ) async {

    String url =
        "dispatch_list.php?usertype=$userType";

    if (userType != "Transport") {
      url += "&partycode=$partyCode";
    }

    final response =
        await ApiService.get(url);

    if (response is List) {
      return response;
    }

    if (response != null &&
        response["data"] is List) {
      return response["data"];
    }

    return [];
  }

  static Future<Map<String, dynamic>>
  updateDispatchStatus({
    required String id,
    required String status,
    String remark = "",
  }) async {

    final response =
        await ApiService.post(
      "update_dispatch_status.php",
      {
        "id": id,
        "status": status,
        "remark": remark,
      },
    );

    return response ?? {};
  }
}