// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class DaikoonHorizontalScroll extends StatelessWidget {
  const DaikoonHorizontalScroll({
    required this.children,
    required this.height,
    this.horizontalPadding = 0,
    super.key,
  });

  final List<Widget> children;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: children.length,
        itemBuilder: (context, index) {
          final lastIndex = children.length - 1;
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.only(left: horizontalPadding),
              child: Container(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  right: AppSpacing.md,
                ),
                child: children[index],
              ),
            );
          } else if (index == lastIndex) {
            return Padding(
              padding: EdgeInsets.only(right: horizontalPadding),
              child: Container(
                padding: const EdgeInsets.only(
                  top: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  left: AppSpacing.md,
                ),
                child: children[index],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.md,
              ),
              child: children[index],
            );
          }
        },
      ),
    );
  }
}
