import 'package:flutter/material.dart';

class HeroHeader extends StatelessWidget {
  final String companyName;
  final String vendorCode;

  final int pendingPlanning;
  final int runningJobs;
  final int readyStock;
  final int dispatchToday;

  const HeroHeader({
    super.key,
    required this.companyName,
    required this.vendorCode,
    required this.pendingPlanning,
    required this.runningJobs,
    required this.readyStock,
    required this.dispatchToday,
  });

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff2563EB),
            Color(0xff1D4ED8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(.20),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 64,
                height: 64,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: const Icon(
                  Icons.factory,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      _greeting(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      companyName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          child: Text(
                            "Vendor : $vendorCode",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 14,
                              ),

                              SizedBox(width: 4),

                              Text(
                                "Verified",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [

              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white70,
                size: 16,
              ),

              const SizedBox(width: 8),

              Text(
                "${today.day}/${today.month}/${today.year}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // KPI Cards Part-2 માં આવશે...
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 420;

              if (isMobile) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _kpiCard(
                            icon: Icons.event_note_rounded,
                            title: "Planning",
                            value: pendingPlanning.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _kpiCard(
                            icon: Icons.precision_manufacturing,
                            title: "Running",
                            value: runningJobs.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _kpiCard(
                            icon: Icons.inventory_2_outlined,
                            title: "Ready",
                            value: readyStock.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _kpiCard(
                            icon: Icons.local_shipping_outlined,
                            title: "Dispatch",
                            value: dispatchToday.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _kpiCard(
                      icon: Icons.event_note_rounded,
                      title: "Planning",
                      value: pendingPlanning.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kpiCard(
                      icon: Icons.precision_manufacturing,
                      title: "Running",
                      value: runningJobs.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kpiCard(
                      icon: Icons.inventory_2_outlined,
                      title: "Ready",
                      value: readyStock.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _kpiCard(
                      icon: Icons.local_shipping_outlined,
                      title: "Dispatch",
                      value: dispatchToday.toString(),
                    ),
                  ),
                ],
              );
            },
          ),
          ],
      ),
    );
  }

  //==================================================
  // KPI CARD
  //==================================================

  Widget _kpiCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 26,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}