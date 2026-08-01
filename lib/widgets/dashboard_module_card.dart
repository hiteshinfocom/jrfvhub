import 'package:flutter/material.dart';

class DashboardModuleCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardModuleCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(.12),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}