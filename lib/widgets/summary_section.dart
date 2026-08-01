import 'package:flutter/material.dart';
import 'expand_icon.dart';

class SummarySection extends StatefulWidget {
  final String title;
  final int totalCount;
  final bool initiallyExpanded;
  final List<Widget> children;

  const SummarySection({
    super.key,
    required this.title,
    required this.totalCount,
    required this.children,
    this.initiallyExpanded = false,
  });

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection>
    with SingleTickerProviderStateMixin {

  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: const [

          BoxShadow(

            color: Colors.black12,

            blurRadius: 6,

            offset: Offset(0,2),

          ),

        ],

      ),

      child: Column(

        children: [

          InkWell(

            borderRadius: BorderRadius.circular(18),

            onTap: () {

              setState(() {

                expanded = !expanded;

              });

            },

            child: Padding(

              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              child: Row(

                children: [

                  Expanded(

                    child: Text(

                      widget.title,

                      style: const TextStyle(

                        fontSize: 16,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ),

                  Container(

                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(

                      color: Colors.blue.shade50,

                      borderRadius:
                          BorderRadius.circular(20),

                    ),

                    child: Text(

                      widget.totalCount.toString(),

                      style: TextStyle(

                        color: Colors.blue.shade700,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                  ),

                  const SizedBox(width: 8),

                  ExpandIconWidget(
                    expanded: expanded,
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(

            duration:
                const Duration(milliseconds: 250),

            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            firstChild: const SizedBox(),

            secondChild: Column(
              children: widget.children,
            ),

          ),
        ],
      ),
    );
  }
}