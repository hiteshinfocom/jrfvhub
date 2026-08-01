import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;
  final Color? badgeColor;

  const SummaryRow({
    super.key,
    required this.title,
    required this.count,
    required this.onTap,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = badgeColor ?? _getColor(count);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffeeeeee),
            ),
          ),
        ),
        child: Row(
          children: [

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 10),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(int value) {
    if (value == 0) return Colors.grey;
    if (value <= 5) return Colors.orange;
    if (value <= 20) return Colors.blue;
    return Colors.green;
  }
}