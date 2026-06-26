import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'config/routes.dart';
import 'config/app_theme.dart';

import 'screens/web/web_pair_screen.dart';
// અથવા જો સીધું web dashboard ખોલવું હોય
// import 'screens/web/web_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VendorPortalApp());
}

class VendorPortalApp extends StatelessWidget {
  const VendorPortalApp({super.key});

  @override
  Widget build(BuildContext context) {

    // WEB
    if (kIsWeb) {
      return GetMaterialApp(
        title: 'JRFVHub Web',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // QR Pairing Screen
        home: const WebPairScreen(),

        // અથવા સીધું Dashboard
        // home: const WebDashboardScreen(),
      );
    }

    // MOBILE
    return GetMaterialApp(
      title: 'Jupiter Vendor Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: Routes.splash,
      getPages: AppRoutes.pages,
    );
  }
}