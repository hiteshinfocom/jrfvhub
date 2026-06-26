import 'dart:convert';
import 'package:http/http.dart'
    as http;

class ChatService {
  static const String baseUrl =
      "https://dcr.jupiterrollforming.com/project2/api";

  Future<int> createRoom({
    required int vendorId,
    required String department,
  }) async {
    final response =
        await http.post(
      Uri.parse(
          "$baseUrl/create_room.php"),
      body: {
        "vendor_id":
            vendorId.toString(),
        "department":
            department,
      },
    );

    final data =
        jsonDecode(response.body);

    return int.parse(
        data["room_id"].toString());
  }

  Future<List<dynamic>>
      getMessages(int roomId) async {
    final response =
        await http.get(
      Uri.parse(
          "$baseUrl/get_messages.php?room_id=$roomId"),
    );

    return jsonDecode(
        response.body);
  }

  Future<List<dynamic>>
      getRooms(int vendorId) async {
    final response =
        await http.get(
      Uri.parse(
          "$baseUrl/get_rooms.php?vendor_id=$vendorId"),
    );

    return jsonDecode(
        response.body);
  }
}