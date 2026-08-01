import 'package:flutter/material.dart';

class DashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String companyName;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  const DashboardAppBar({
    super.key,
    required this.companyName,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;

    String greeting = "Good Evening";

    if (hour < 12) {
      greeting = "Good Morning";
    } else if (hour < 17) {
      greeting = "Good Afternoon";
    }

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,

      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xff1E293B),
              size: 28,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),

      titleSpacing: 4,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            greeting,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            companyName.isEmpty
                ? "Supplier Dashboard"
                : companyName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xff0F172A),
            ),
          ),
        ],
      ),

      actions: [

        /// Search

        IconButton(
          splashRadius: 22,
          onPressed: () {
            // TODO Search Screen
          },
          icon: const Icon(
            Icons.search_rounded,
            color: Color(0xff334155),
          ),
        ),

        /// Notification

        Stack(
          clipBehavior: Clip.none,
          children: [

            IconButton(
              splashRadius: 22,
              onPressed: onNotificationTap,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xff334155),
              ),
            ),

            if (notificationCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    notificationCount > 99
                        ? "99+"
                        : notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 8),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}