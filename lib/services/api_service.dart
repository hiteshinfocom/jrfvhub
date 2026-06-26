import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/server_config.dart';

class ApiService {

  // ================= GET API =================

  static Future<dynamic> get(
    String endpoint,
  ) async {

    try {

      final response = await http.get(

        Uri.parse(
          "${ServerConfig.baseUrl}/$endpoint",
        ),

        headers: {

          "Accept": "application/json",

        },

      ).timeout(

        Duration(
          seconds: ServerConfig.timeout,
        ),

      );

      print("GET URL : ${ServerConfig.baseUrl}/$endpoint");
      print("GET RESPONSE : ${response.body}");

      return _handleResponse(response);

    } catch (e) {

      print("GET ERROR : $e");

      return {

        "status": false,
        "message": e.toString(),

      };
    }
  }

  // ================= POST API =================

  static Future<dynamic> post(

    String endpoint,
    Map<String, dynamic> data,

  ) async {

    try {

      final url = Uri.parse(
        "${ServerConfig.baseUrl}/$endpoint",
      );

      print("POST URL : $url");
      print("POST DATA : $data");

      final response = await http.post(

        url,

        headers: {

          "Accept": "application/json",

        },

        // FORM DATA
        body: data,

      ).timeout(

        Duration(
          seconds: ServerConfig.timeout,
        ),

      );

      print("STATUS CODE : ${response.statusCode}");
      print("RESPONSE : ${response.body}");

      return _handleResponse(response);

    } catch (e) {

      print("POST ERROR : $e");

      return {

        "status": false,
        "message": e.toString(),

      };
    }
  }

  // ================= HANDLE RESPONSE =================

  static dynamic _handleResponse(
    http.Response response,
  ) {

    try {

      return jsonDecode(response.body);

    } catch (e) {

      print("JSON ERROR : $e");

      return {

        "status": false,
        "message": "Invalid Response",

      };
    }
  }
}