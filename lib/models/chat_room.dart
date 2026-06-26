class ChatRoom {
  final int id;
  final int vendorId;
  final String department;
  final String status;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.vendorId,
    required this.department,
    required this.status,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatRoom.fromJson(
      Map<String, dynamic> json) {
    return ChatRoom(
      id: int.tryParse(
              json['id'].toString()) ??
          0,
      vendorId: int.tryParse(
              json['vendor_id'].toString()) ??
          0,
      department:
          json['department'] ?? '',
      status: json['status'] ?? '',
      lastMessage:
          json['last_message'],
      lastMessageTime:
          json['last_message_time'],
      unreadCount: int.tryParse(
              json['unread_vendor']
                  .toString()) ??
          0,
    );
  }
}