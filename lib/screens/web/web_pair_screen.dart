import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'web_dashboard_screen.dart';

class WebPairScreen extends StatefulWidget {
  const WebPairScreen({super.key});

  @override
  State<WebPairScreen> createState() =>
      _WebPairScreenState();
}

class _WebPairScreenState
    extends State<WebPairScreen> {

  String qrToken = "";
  bool loading = true;
  String errorMessage = "";

  Timer? pairTimer;

  @override
  void initState() {
    super.initState();

    loadQrToken();

    pairTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        if (qrToken.isNotEmpty) {
          checkStatus();
        }
      },
    );
}

@override
void dispose() {
  pairTimer?.cancel();
  super.dispose();
}

  Future<void> loadQrToken() async {
    try {

      final response = await http.get(
        Uri.parse(
          "https://dcr.jupiterrollforming.com/project2/api/generate_qr.php",
        ),
      );

      debugPrint(
        "API RESPONSE => ${response.body}",
      );

      final data =
          jsonDecode(response.body);

      if (data["status"] == true) {

        qrToken = data["token"];

        debugPrint(
          "QR TOKEN => $qrToken",
        );

        setState(() {
          loading = false;
        });

      } else {

        setState(() {
          loading = false;
          errorMessage =
              "Invalid API Response";
        });
      }

    } catch (e) {

      debugPrint("ERROR => $e");

      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> checkStatus() async {

  try {

    final response = await http.get(
      Uri.parse(
        "https://dcr.jupiterrollforming.com/project2/api/check_pair_status.php?token=$qrToken",
      ),
    );

    debugPrint(
      "CHECK STATUS => ${response.body}",
    );

    final data =
        jsonDecode(response.body);

    if (data["status"] == "paired") {

  final prefs =
      await SharedPreferences.getInstance();

  await prefs.setBool(
    "logged_in",
    true,
  );

  await prefs.setInt(
    "vendorid",
    int.tryParse(
      data["vendorid"].toString(),
    ) ?? 0,
  );

  await prefs.setString(
    "partycode",
    data["partycode"] ?? "",
  );

  pairTimer?.cancel();

  Get.offAll(
    () => const WebDashboardScreen(),
  );
}

  } catch (e) {

    debugPrint(
      "CHECK ERROR => $e",
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xfff4f7fc),

      body: Center(

        child: Container(

          width: 500,

          padding:
              const EdgeInsets.all(30),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
          ),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            children: [

              const Icon(
                Icons.qr_code_2,
                size: 120,
                color: Colors.indigo,
              ),

              const SizedBox(height: 20),

              const Text(
                "Link Device",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Open JRFVHub Mobile App and scan QR code",
                textAlign:
                    TextAlign.center,
              ),

              const SizedBox(height: 25),

              if (loading)

                const CircularProgressIndicator()

              else if (qrToken.isNotEmpty)

              Column(
                children: [

                  Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),

                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    child: PrettyQrView.data(
                      data: qrToken,
                    ),
                  ),

                  const SizedBox(height: 20),

                  SelectableText(
                    qrToken,
                    textAlign: TextAlign.center,
                  ),
                ],
              )

              else

                Text(
                  errorMessage.isEmpty
                      ? "Unable to load QR"
                      : errorMessage,
                  style:
                      const TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
