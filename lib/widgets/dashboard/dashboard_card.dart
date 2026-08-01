import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool small = width < 360;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(
              small ? 14 : 16,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Container(
                      height: small ? 44 : 50,
                      width: small ? 44 : 50,
                      decoration: BoxDecoration(
                        color: color.withOpacity(.12),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: small ? 22 : 26,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        count,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        small ? 15 : 17,
                    color: const Color(
                      0xff1E293B,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        small ? 11 : 12,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [

                    Text(
                      "Open",
                      style: TextStyle(
                        color: color,
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: color,
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}