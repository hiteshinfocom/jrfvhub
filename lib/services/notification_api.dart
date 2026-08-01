import '../models/notification_model.dart';
import 'api_service.dart';

class NotificationApi {
  NotificationApi._();

  //==========================================================
  // GET NOTIFICATIONS
  //==========================================================

  static Future<List<NotificationModel>> getNotifications(
    String vendorCode,
  ) async {
    try {
      final response = await ApiService.get(
        "notifications.php?partycode=$vendorCode",
      );

      if (response == null) return [];

      if (response["success"] != true) return [];

      final List list = response["data"] ?? [];

      return list
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  //==========================================================
  // UNREAD COUNT
  //==========================================================

  static Future<int> getUnreadCount(
    String vendorCode,
  ) async {
    try {
      final response = await ApiService.get(
        "notification_count.php?partycode=$vendorCode",
      );

      if (response == null) return 0;

      if (response["success"] != true) return 0;

      return response["count"] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  //==========================================================
  // MARK AS READ
  //==========================================================

  static Future<bool> markAsRead(
    int notificationId,
  ) async {
    try {
      final response = await ApiService.post(
        "notification_read.php",
        {
          "notification_id": notificationId.toString(),
        },
      );

      if (response == null) return false;

      return response["success"] == true;
    } catch (e) {
      return false;
    }
  }
}