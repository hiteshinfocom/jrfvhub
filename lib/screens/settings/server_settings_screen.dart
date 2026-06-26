import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerSettingsScreen extends StatefulWidget {
const ServerSettingsScreen({super.key});

@override
State<ServerSettingsScreen> createState() =>
_ServerSettingsScreenState();
}

class _ServerSettingsScreenState
extends State<ServerSettingsScreen> {

final TextEditingController
serverController =
TextEditingController();

@override
void initState() {
super.initState();
loadServerUrl();
}

Future<void> loadServerUrl() async {


final prefs =
    await SharedPreferences.getInstance();

serverController.text =
    prefs.getString("server_url") ?? "";


}

Future<void> saveServerUrl() async {


if (serverController.text
    .trim()
    .isEmpty) {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content:
          Text("Enter Server URL"),
    ),
  );
  return;
}

final prefs =
    await SharedPreferences.getInstance();

await prefs.setString(
  "server_url",
  serverController.text.trim(),
);

if (mounted) {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        "Server URL Saved Successfully",
      ),
    ),
  );
}

}

@override
void dispose() {
serverController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {


return Scaffold(
  backgroundColor:
      const Color(0xffF5F7FB),

  appBar: AppBar(
    title: const Text(
      "Server Settings",
    ),
    centerTitle: true,
  ),

  body: Padding(
    padding:
        const EdgeInsets.all(16),

    child: Column(
      children: [

        Card(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              15,
            ),
          ),

          child: Padding(
            padding:
                const EdgeInsets.all(
              16,
            ),

            child: Column(
              children: [

                const Icon(
                  Icons.dns,
                  size: 60,
                  color: Colors.blue,
                ),

                const SizedBox(
                    height: 10),

                const Text(
                  "API Server URL",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 20),

                TextField(
                  controller:
                      serverController,

                  decoration:
                      InputDecoration(
                    labelText:
                        "Server URL",

                    hintText:
                        "https://yourdomain.com/api",

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.link,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                SizedBox(
                  width:
                      double.infinity,

                  height: 50,

                  child:
                      ElevatedButton.icon(
                    onPressed:
                        saveServerUrl,

                    icon: const Icon(
                      Icons.save,
                    ),

                    label: const Text(
                      "Save Settings",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
);


}
}
