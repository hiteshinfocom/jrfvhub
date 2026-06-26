class ChatMessage {
  final int id;
  final int roomId;
  final String senderType;
  final int senderId;
  final String message;
  final String? fileUrl;
  final String createdAt;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderType,
    required this.senderId,
    required this.message,
    this.fileUrl,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(
      Map<String, dynamic> json) {
    return ChatMessage(
      id: int.tryParse(
              json['id'].toString()) ??
          0,
      roomId: int.tryParse(
              json['room_id'].toString()) ??
          0,
      senderType:
          json['sender_type'] ?? '',
      senderId: int.tryParse(
              json['sender_id'].toString()) ??
          0,
      message: json['message'] ?? '',
      fileUrl: json['file_url'],
      createdAt:
          json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "room_id": roomId,
      "sender_type": senderType,
      "sender_id": senderId,
      "message": message,
      "file_url": fileUrl,
      "created_at": createdAt,
    };
  }
}