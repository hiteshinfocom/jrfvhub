class NotificationModel {
  final int id;
  final String module;
  final int referenceId;
  final String notificationType;
  final String title;
  final String message;
  final String imageUrl;
  final String clickScreen;
  final Map<String, dynamic> clickData;
  final bool isSent;
  final String? sentAt;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.module,
    required this.referenceId,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.clickScreen,
    required this.clickData,
    required this.isSent,
    required this.sentAt,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: json["id"] ?? 0,
      module: json["module"] ?? "",
      referenceId: json["reference_id"] ?? 0,
      notificationType:
          json["notification_type"] ?? "",
      title: json["title"] ?? "",
      message: json["message"] ?? "",
      imageUrl: json["image_url"] ?? "",
      clickScreen: json["click_screen"] ?? "",
      clickData:
          json["click_data"] is Map<String, dynamic>
              ? json["click_data"]
              : <String, dynamic>{},
      isSent: (json["is_sent"] ?? 0) == 1,
      sentAt: json["sent_at"],
      isRead: (json["is_read"] ?? 0) == 1,
      readAt: json["read_at"],
      createdAt: json["created_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "module": module,
      "reference_id": referenceId,
      "notification_type": notificationType,
      "title": title,
      "message": message,
      "image_url": imageUrl,
      "click_screen": clickScreen,
      "click_data": clickData,
      "is_sent": isSent ? 1 : 0,
      "sent_at": sentAt,
      "is_read": isRead ? 1 : 0,
      "read_at": readAt,
      "created_at": createdAt,
    };
  }
}