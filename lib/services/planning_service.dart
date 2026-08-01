import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import 'api_service.dart';
import '../config/server_config.dart';
import '../models/planning_model.dart';

import 'package:intl/intl.dart';

class PlanningService {
  /// ===========================
  /// Get Vendor Planning
  /// ===========================

  static Future<List<PlanningModel>> getPlanning(
      String vendorCode) async {
    final response = await ApiService.get(
      "planning.php?pcode=$vendorCode",
    );

    if (response is List) {
      return response
          .map((e) => PlanningModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// ===========================
  /// Accept Planning
  /// ===========================

  static Future<Map<String, dynamic>> acceptPlanning({
    required int planningId,
    required String vendorCode,
    required String completionDate,
    required String reason,
    required bool isExtended,
  }) async {
    final response = await ApiService.post(
      "planning_accept.php",
      {
        "id": planningId.toString(),
        "pcode": vendorCode,
        "completion_date": completionDate,
        "reason": reason,
        "is_extended": isExtended ? "1" : "0",
      },
    );

    if (response == null) {
      return {
        "status": false,
        "message": "Unable to connect to server."
      };
    }

    return response;
  }

  /// ===========================
  /// Reject Planning
  /// ===========================

  static Future<Map<String, dynamic>> rejectPlanning({
    required int planningId,
    required String vendorCode,
  }) async {
    final response = await ApiService.post(
      "planning_reject.php",
      {
        "id": planningId.toString(),
        "pcode": vendorCode,
      },
    );

    if (response == null) {
      return {
        "status": false,
        "message": "Unable to connect to server."
      };
    }

    return response;
  }

  /// ===========================
  /// Download Planning Excel
  /// ===========================

  static Future<String> downloadExcel(String vendorCode) async {
    final dio = Dio();

    final url =
        "${ServerConfig.baseUrl}/planning_excel.php?pcode=$vendorCode";

    final tempDir = await getTemporaryDirectory();

    final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

    final fileName = "Planning_${vendorCode}_$now.xlsx";

    final tempFile = "${tempDir.path}/$fileName";

    await dio.download(url, tempFile);

    final savedPath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: tempFile,
        fileName: fileName,
      ),
    );

    if (savedPath == null) {
      throw Exception("Download cancelled.");
    }

    await OpenFilex.open(savedPath);

    return savedPath;
  }
}