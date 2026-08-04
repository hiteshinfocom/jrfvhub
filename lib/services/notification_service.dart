import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../screens/planning/planning_screen.dart';
import '../screens/jobwork/JobWorkScreen.dart';
import '../screens/dispatch/dispatch_screen.dart';
import '../screens/ready_items/ready_stock_screen.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  //----------------------------------------------------------
  // INITIALIZE
  //----------------------------------------------------------

  Future<void> initialize() async {
    await _requestPermission();

    await _initializeLocalNotification();

    await _setupForeground();

    await _setupTapEvents();
  }
  

  //----------------------------------------------------------
  // PERMISSION
  //----------------------------------------------------------

  Future<void> _requestPermission() async {
    NotificationSettings settings =
        await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      "Notification Permission : ${settings.authorizationStatus}",
    );
  }

  //----------------------------------------------------------
  // LOCAL NOTIFICATION
  //----------------------------------------------------------

  Future<void> _initializeLocalNotification() async {

  const AndroidNotificationChannel channel =
      AndroidNotificationChannel(
    'vendor_notification_channel',
    'Vendor Notifications',
    description: 'Vendor Portal Notifications',
    importance: Importance.high,
  );

  await _local
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');

  const darwin = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const settings = InitializationSettings(
    android: android,
    iOS: darwin,
  );

  await _local.initialize(
    settings,
    onDidReceiveNotificationResponse: (response) {
      if (response.payload == null) return;

      final data = jsonDecode(response.payload!);

      _navigate(data);
    },
  );
}

  //----------------------------------------------------------
  // FOREGROUND
  //----------------------------------------------------------

  Future<void> _setupForeground() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        await _showLocalNotification(message);
      },
    );
  }

  //----------------------------------------------------------
  // TAP EVENTS
  //----------------------------------------------------------

  Future<void> _setupTapEvents() async {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        _navigate(message.data);
      },
    );

    final initial =
        await _messaging.getInitialMessage();

    if (initial != null) {
      _navigate(initial.data);
    }
  }

  //----------------------------------------------------------
  // SHOW LOCAL
  //----------------------------------------------------------

  Future<void> _showLocalNotification(
      RemoteMessage message) async {
    const android = AndroidNotificationDetails(
      "vendor_notification_channel",
      "Vendor Notifications",
      channelDescription:
          "Vendor Portal Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: android,
    );

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "",
      message.notification?.body ?? "",
      details,
      payload: jsonEncode(message.data),
    );
  }

  //----------------------------------------------------------
  // GET TOKEN
  //----------------------------------------------------------

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  //----------------------------------------------------------
  // TOKEN REFRESH
  //----------------------------------------------------------

  void onRefresh(
    Function(String token) callback,
  ) {
    FirebaseMessaging.instance.onTokenRefresh
        .listen(callback);
  }

  //----------------------------------------------------------
  // NAVIGATION
  //----------------------------------------------------------

  void _navigate(Map<String, dynamic> data) {
    final screen = data["screen"];

    switch (screen) {
      case "planning":
        Get.to(() => const PlanningScreen());
        break;

      case "jobwork":
        Get.to(() => const JobWorkScreen());
        break;

      case "dispatch":
        Get.to(() => const DispatchScreen());
        break;

      case "ready_stock":
        Get.to(() => const ReadyStockScreen());
        break;

      default:
        break;
    }
  }
}