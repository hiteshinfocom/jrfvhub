import 'api_service.dart';

class DashboardService {

  DashboardService._();

  static Future<Map<String,dynamic>>
  getDashboard(String vendorCode) async {

    final response = await ApiService.get(
      "dashboard.php?partycode=$vendorCode",
    );

    print(response);

    if(response != null &&
        response["success"] == true){

      return response["data"];
    }

    return {};
  }

}