import 'package:get/get.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class Routes {

  static const splash = "/";
  static const login = "/login";
  static const dashboard = "/dashboard";

}

class AppRoutes {

  static final pages = [

    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
    ),

  ];
}