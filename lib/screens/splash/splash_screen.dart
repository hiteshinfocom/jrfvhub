import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController orbitController;
  late AnimationController glowController;

  @override
  void initState() {
    super.initState();

    orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.7,
      upperBound: 1,
    )..repeat(reverse: true);

    startApp();
  }

  @override
  void dispose() {
    orbitController.dispose();
    glowController.dispose();
    super.dispose();
  }

  // ================= START APP =================

  Future<void> startApp() async {

    await Future.delayed(
      const Duration(seconds: 4),
    );

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    bool isLogin =
        prefs.getBool("isLogin") ?? false;

    if (!mounted) return;

    if (isLogin) {

      Get.offAllNamed(
        Routes.dashboard,
      );

    } else {

      Get.offAllNamed(
        Routes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              Color(0xFFD7EBFF),
              Color(0xFF0A49C9),
              Color(0xFF001A66),
            ],
          ),
        ),

        child: Stack(
          children: [

            // ================= TOP GLOW =================

            Positioned(
              top: -120,
              left: -80,

              child: Container(
                width: 280,
                height: 280,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.white.withValues(
                    alpha: 0.15,
                  ),
                ),
              ),
            ),

            // ================= BOTTOM GLOW =================

            Positioned(
              bottom: -100,
              right: -100,

              child: Container(
                width: 250,
                height: 250,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.blueAccent.withValues(
                    alpha: 0.18,
                  ),
                ),
              ),
            ),

            // ================= BACKGROUND ICON =================

            Positioned(
              top: 70,
              left: 0,
              right: 0,

              child: Opacity(
                opacity: 0.06,

                child: const Icon(
                  Icons.factory,
                  size: 240,
                  color: Colors.white,
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [

                  const SizedBox(height: 40),

                  // ================= LOGO =================

                  ScaleTransition(

                    scale: glowController,

                    child: Container(

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(25),

                        color: Colors.white.withValues(
                          alpha: 0.12,
                        ),

                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),

                      child: Image.asset(
                        'assets/images/logo1.png',
                        height: 110,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= TITLE =================

                  const Text(
                    "Jupiter",

                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),

                  ShaderMask(

                    shaderCallback: (bounds) {

                      return const LinearGradient(
                        colors: [
                          Color(0xFFFFC107),
                          Color(0xFFFF8F00),
                        ],
                      ).createShader(bounds);
                    },

                    child: const Text(
                      "VendorHub",

                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(

                    width: 220,
                    height: 4,

                    decoration: BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(20),

                      gradient: const LinearGradient(
                        colors: [
                          Colors.orange,
                          Colors.white,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // ================= ANIMATION =================

                  Expanded(

                    child: Center(

                      child: AnimatedBuilder(

                        animation: orbitController,

                        builder: (context, child) {

                          return Transform.rotate(

                            angle:
                                orbitController.value *
                                    2 *
                                    pi,

                            child: Stack(

                              alignment: Alignment.center,

                              children: [

                                // ================= OUTER CIRCLE =================

                                Container(

                                  width: 300,
                                  height: 300,

                                  decoration: BoxDecoration(

                                    shape: BoxShape.circle,

                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                ),

                                // ================= INNER GLOW =================

                                Container(

                                  width: 220,
                                  height: 220,

                                  decoration: BoxDecoration(

                                    shape: BoxShape.circle,

                                    gradient: RadialGradient(
                                      colors: [

                                        Colors.white.withValues(
                                          alpha: 0.10,
                                        ),

                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // ================= ORBIT DOTS =================

                                ...List.generate(
                                  8,
                                  (index) {

                                    double angle =
                                        (2 * pi / 8) *
                                            index;

                                    return Positioned(

                                      left:
                                          150 +
                                              120 *
                                                  cos(angle) -
                                              6,

                                      top:
                                          150 +
                                              120 *
                                                  sin(angle) -
                                              6,

                                      child: Container(

                                        width: 12,
                                        height: 12,

                                        decoration:
                                            const BoxDecoration(
                                          color:
                                              Colors.orange,
                                          shape:
                                              BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // ================= FEATURE ICONS =================

                                Positioned(
                                  top: 10,

                                  child: buildFeatureIcon(
                                    Icons.assignment,
                                    "PO",
                                  ),
                                ),

                                Positioned(
                                  left: 10,
                                  bottom: 70,

                                  child: buildFeatureIcon(
                                    Icons.local_shipping,
                                    "Dispatch",
                                  ),
                                ),

                                Positioned(
                                  right: 10,
                                  bottom: 70,

                                  child: buildFeatureIcon(
                                    Icons.handshake,
                                    "Vendor",
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ================= TAGLINE =================

                  const Padding(

                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    child: Text(

                      "Smart Vendor Management Platform",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= LOADING DOTS =================

                  Row(

                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      buildDot(true),
                      buildDot(false),
                      buildDot(false),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= FEATURE ICON =================

  Widget buildFeatureIcon(
    IconData icon,
    String label,
  ) {

    return Container(

      width: 95,
      height: 95,

      decoration: BoxDecoration(

        shape: BoxShape.circle,

        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFE8F0FF),
          ],
        ),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withValues(
              alpha: 0.25,
            ),

            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 38,
            color: const Color(0xFF0A49C9),
          ),

          const SizedBox(height: 5),

          Text(

            label,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF0A49C9),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOADING DOT =================

  Widget buildDot(bool active) {

    return AnimatedContainer(

      duration: const Duration(
        milliseconds: 300,
      ),

      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),

      width: active ? 14 : 10,
      height: active ? 14 : 10,

      decoration: BoxDecoration(

        color:
            active
                ? Colors.white
                : Colors.white54,

        shape: BoxShape.circle,
      ),
    );
  }
}