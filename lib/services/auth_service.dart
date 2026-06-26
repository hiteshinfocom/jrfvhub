import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'api_service.dart';

class AuthService {
  // ================= LOGIN =================

  static Future<Map<String, dynamic>> getLocationData() async {
  try {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return {};
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      return {};
    }

    Position position =
        await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks =
        await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    return {
      "latitude":
          position.latitude.toString(),
      "longitude":
          position.longitude.toString(),
      "city": place.locality ?? "",
      "state":
          place.administrativeArea ?? "",
      "country": place.country ?? "",
    };
  } catch (e) {
    debugPrint("LOCATION ERROR : $e");
    return {};
  }
}

  static Future<dynamic> login({
    required String vendorCode,
    required String password,
  }) async {
    try {
      String firebaseToken = "";

      try {
        firebaseToken =
            await FirebaseMessaging.instance.getToken() ?? "";
      } catch (e) {
        debugPrint("FCM TOKEN ERROR : $e");
      }

      final deviceInfo = DeviceInfoPlugin();

      String deviceType = "";
      String deviceName = "";
      String androidVersion = "";
      String appVersion = "";

      try {
        if (Platform.isAndroid) {
          final androidInfo =
              await deviceInfo.androidInfo;

          deviceType = "Android";

          deviceName =
              "${androidInfo.brand} ${androidInfo.model}";

          androidVersion =
              androidInfo.version.release;
        }

        final packageInfo =
            await PackageInfo.fromPlatform();

        appVersion = packageInfo.version;

      } catch (e) {
        debugPrint(
            "DEVICE INFO ERROR : $e");
      }

      final locationData =
          await getLocationData();

      final response =
          await ApiService.post(
        "vlogin.php",
        {
          "partycode":
              vendorCode.trim(),

          "password":
              password.trim(),

          "firebase_token":
              firebaseToken,

          "device_type":
              deviceType,

          "device_name":
              deviceName,

          "app_version":
              appVersion,

          "android_version":
              androidVersion,

          "latitude":
              locationData["latitude"] ?? "",

          "longitude":
              locationData["longitude"] ?? "",

          "city":
              locationData["city"] ?? "",

          "state":
              locationData["state"] ?? "",

          "country":
              locationData["country"] ?? "",
        },
      );

      debugPrint("LOGIN RESPONSE : $response");

      if (response != null &&
          response["status"] == true &&
          response["data"] != null) {
        final prefs =
            await SharedPreferences.getInstance();

        final data =
            response["data"] as Map<String, dynamic>;

        await prefs.setBool(
          "logged_in",
          true,
        );

        await prefs.setInt(
          "vendorid",
          data["vendorid"] ?? 0,
        );

        await prefs.setInt(
          "partyid",
          data["partyid"] ?? 0,
        );

        await prefs.setString(
          "partycode",
          data["partycode"] ?? "",
        );

        await prefs.setString(
          "company_name",
          data["company_name"] ?? "",
        );

        await prefs.setString(
          "username",
          data["username"] ?? "",
        );

        await prefs.setString(
          "mobileno",
          data["mobileno"] ?? "",
        );

        await prefs.setString(
          "contact_person",
          data["contact_person"] ?? "",
        );

        await prefs.setString(
          "email",
          data["email"] ?? "",
        );

        await prefs.setString(
          "gst_no",
          data["gst_no"] ?? "",
        );

        await prefs.setString(
          "last_login",
          data["last_login"] ?? "",
        );

        await prefs.setString(
          "token",
          response["token"] ?? "",
        );

        await prefs.setInt(
          "login_history_id",
          response["login_history_id"] ?? 0,
        );
      }

      return response;
    } catch (e) {
      debugPrint("LOGIN ERROR : $e");

      return {
        "status": false,
        "message": e.toString(),
      };
    }
  }

  // ================= CHECK LOGIN =================

  static Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool("logged_in") ?? false;
  }

  // ================= LOGOUT =================

  static Future<void> logout() async {

  final prefs =
      await SharedPreferences.getInstance();

  final loginHistoryId =
      prefs.getInt(
        "login_history_id",
      ) ??
      0;

  try {

    await ApiService.post(
      "logout.php",
      {
        "login_history_id":
            loginHistoryId.toString(),
      },
    );

  } catch (_) {}

  await prefs.clear();
}

// ================= GET Vendor =================

static Future<Map<String, dynamic>>
getVendor() async {

  final prefs =
      await SharedPreferences.getInstance();

  return {
    'partycode':
        prefs.getString('partycode') ?? '',
    'usertype':
        prefs.getString('usertype') ?? 'Vendor',
  };
}

  // ================= GET USER =================

  static Future<Map<String, dynamic>> getUser() async {
    final prefs =
        await SharedPreferences.getInstance();

    return {
      "vendorid":
          prefs.getInt("vendorid") ?? 0,

      "partyid":
          prefs.getInt("partyid") ?? 0,

      "partycode":
          prefs.getString("partycode") ?? "",

      "company_name":
          prefs.getString("company_name") ?? "",

      "contact_person":
          prefs.getString("contact_person") ?? "",

      "address":
          prefs.getString("address") ?? "",

      "gst_no":
          prefs.getString("gst_no") ?? "",

      "pan_no":
          prefs.getString("pan_no") ?? "",

      "username":
          prefs.getString("username") ?? "",

      "mobileno":
          prefs.getString("mobileno") ?? "",

      "email":
          prefs.getString("email") ?? "",

      "last_login":
          prefs.getString("last_login") ?? "",

      "token":
          prefs.getString("token") ?? "",

      "login_history_id":
          prefs.getInt("login_history_id",) ??0,
    };
  }

    static Future<Map<String, dynamic>> changePassword({
      required String oldPassword,
      required String newPassword,
    }) async {

      final user = await AuthService.getUser();

      final response = await ApiService.post(
        "change_password.php",
        {
          "partycode": user["partycode"],
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      return response ?? {};
    }

  // ================= GET TOKEN =================

  static Future<String> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString("token") ?? "";
  }

  // ================= GET USERNAME =================

  static Future<String> getUsername() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString("username") ?? "";
  }

  // ================= GET VENDOR ID =================

  static Future<int> getVendorId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt("vendorid") ?? 0;
  }
}