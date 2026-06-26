import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';

class QrLoginScreen extends StatefulWidget {
  const QrLoginScreen({super.key});

  @override
  State<QrLoginScreen> createState() =>
      _QrLoginScreenState();
}

class _QrLoginScreenState
    extends State<QrLoginScreen> {

  final MobileScannerController controller =
      MobileScannerController();

  bool scanned = false;

  Future<void> pairDevice(
    String token,
  ) async {

    try {

      final user =
          await AuthService.getUser();

      final vendorId =
          user["vendorid"].toString();

      debugPrint(
        "TOKEN => $token",
      );

      debugPrint(
        "VENDOR ID => $vendorId",
      );

      final response =
          await http.post(

        Uri.parse(
          "https://dcr.jupiterrollforming.com/project2/api/pair_device.php",
        ),

        body: {

          "token": token,

          "vendorid": vendorId,
        },
      );

      debugPrint(
        "PAIR RESPONSE => ${response.body}",
      );

    } catch (e) {

      debugPrint(
        "PAIR ERROR => $e",
      );
    }
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text(
          "Scan Web QR",
        ),

        backgroundColor:
            Colors.black,

        foregroundColor:
            Colors.white,
      ),

      body: Stack(

        children: [

          MobileScanner(

            controller: controller,

            onDetect:
                (capture) async {

              if (scanned) return;

              final barcode =
                  capture.barcodes.first;

              final token =
                  barcode.rawValue;

              if (token == null ||
                  token.isEmpty) {
                return;
              }

              scanned = true;

              await controller.stop();

              await pairDevice(
                token,
              );

              if (mounted) {

                ScaffoldMessenger.of(
                        context)
                    .showSnackBar(

                  const SnackBar(

                    backgroundColor:
                        Colors.green,

                    content: Text(
                      "Device Paired Successfully",
                    ),
                  ),
                );

                Future.delayed(
                  const Duration(
                    seconds: 1,
                  ),
                  () {

                    if (mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                );
              }
            },
          ),

          Center(

            child: Container(

              width: 280,
              height: 280,

              decoration:
                  BoxDecoration(

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: Stack(

                children: [

                  // TOP LEFT

                  Positioned(
                    top: 0,
                    left: 0,

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration:
                          const BoxDecoration(

                        border: Border(

                          top: BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),

                          left: BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // TOP RIGHT

                  Positioned(
                    top: 0,
                    right: 0,

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration:
                          const BoxDecoration(

                        border: Border(

                          top: BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),

                          right:
                              BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BOTTOM LEFT

                  Positioned(
                    bottom: 0,
                    left: 0,

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration:
                          const BoxDecoration(

                        border: Border(

                          left: BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),

                          bottom:
                              BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BOTTOM RIGHT

                  Positioned(
                    bottom: 0,
                    right: 0,

                    child: Container(
                      width: 50,
                      height: 50,

                      decoration:
                          const BoxDecoration(

                        border: Border(

                          right:
                              BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),

                          bottom:
                              BorderSide(
                            color:
                                Colors.green,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Positioned(

            bottom: 120,
            left: 0,
            right: 0,

            child: Text(

              "Scan QR Code from JRFVHub Web",

              textAlign:
                  TextAlign.center,

              style: TextStyle(

                color: Colors.white,

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}