import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7fc),

      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: const EdgeInsets.all(15),
        children: const [

          NotificationTile(
            title: "New Purchase Order",
            message: "PO-10025 has been assigned.",
            time: "5 min ago",
            color: Colors.blue,
            icon: Icons.shopping_cart,
          ),

          NotificationTile(
            title: "Job Work Updated",
            message: "Job Work #JW102 completed.",
            time: "20 min ago",
            color: Colors.orange,
            icon: Icons.precision_manufacturing,
          ),

          NotificationTile(
            title: "Dispatch Ready",
            message: "Dispatch #D201 is ready.",
            time: "1 hour ago",
            color: Colors.green,
            icon: Icons.local_shipping,
          ),

          NotificationTile(
            title: "Payment Received",
            message: "₹25,000 payment received.",
            time: "2 hours ago",
            color: Colors.purple,
            icon: Icons.account_balance_wallet,
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 5),

            Text(message),

            const SizedBox(height: 5),

            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}