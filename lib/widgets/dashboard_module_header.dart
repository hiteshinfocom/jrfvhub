import 'package:flutter/material.dart';

class DashboardModuleHeader extends StatelessWidget {
  final List<DashboardModule> modules;

  const DashboardModuleHeader({
    super.key,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: modules.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = modules[index];

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: item.onTap,
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: item.color.withOpacity(.12),
                    child: Icon(
                      item.icon,
                      color: item.color,
                      size: 20,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    item.count.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: item.color,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DashboardModule {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  DashboardModule({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}