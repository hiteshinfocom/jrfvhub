import 'package:flutter/material.dart';

class SummaryItem {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  const SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class SummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<SummaryItem> items;
  final VoidCallback? onViewAll;

  const SummarySection({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //--------------------------------------------------
          // Header
          //--------------------------------------------------

          Row(
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

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text("View All"),
                ),
            ],
          ),

          const SizedBox(height: 14),

          //--------------------------------------------------
          // Empty State
          //--------------------------------------------------

          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18),
              ),

              child: const Center(
                child: Text(
                  "No Data Available",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          //--------------------------------------------------
          // Summary Grid
          //--------------------------------------------------

          if (items.isNotEmpty)
            LayoutBuilder(
              builder: (context, constraints) {

                final crossAxisCount =
                    constraints.maxWidth > 700 ? 4 : 2;

                return GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount: items.length,

                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: crossAxisCount,

                    crossAxisSpacing: 12,

                    mainAxisSpacing: 12,

                    childAspectRatio: 1.45,
                  ),

                  itemBuilder: (context, index) {

                    final item = items[index];

                    return _summaryCard(
                      item,
                    );
                  },
                );
              },
            ),
            ],
      ),
    );
  }

  //==================================================
  // SUMMARY CARD
  //==================================================

  Widget _summaryCard(SummaryItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.color.withOpacity(.15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(.12),
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 22,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      Icons.trending_up,
                      color: item.color,
                      size: 18,
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  item.value.toString(),
                  style: TextStyle(
                    color: item.color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
