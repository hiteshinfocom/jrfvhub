import 'package:flutter/material.dart';
import 'admin_chat_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IT Support Admin"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            dashboardCard(
              context,
              Icons.chat,
              "Open Chats",
              Colors.blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminChatListScreen(),
                  ),
                );
              },
            ),

            dashboardCard(
              context,
              Icons.done_all,
              "Closed Tickets",
              Colors.green,
              () {
                // Closed Tickets
              },
            ),

            dashboardCard(
              context,
              Icons.people,
              "Vendors",
              Colors.orange,
              () {
                // Vendor List
              },
            ),

            dashboardCard(
              context,
              Icons.logout,
              "Logout",
              Colors.red,
              () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(.15),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

          ],
        ),
      ),
    );
  }
}