import 'package:flutter/material.dart';

class NotificationScreen
    extends StatefulWidget {

  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen>
      createState() =>
          _NotificationScreenState();
}

class _NotificationScreenState
    extends State<
        NotificationScreen> {

  bool enable = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Notifications"),
      ),

      body: SwitchListTile(
        title: const Text(
          "Enable Notifications",
        ),
        value: enable,
        onChanged: (v) {
          setState(() {
            enable = v;
          });
        },
      ),
    );
  }
}