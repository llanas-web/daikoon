import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class OfferItem extends StatelessWidget {
  const OfferItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: Container(
        width: context.screenWidth * 0.65,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg,
          vertical: AppSpacing.xlg,
        ),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xlg),
            bottomLeft: Radius.circular(AppRadius.xlg),
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '-20%',
                  style: UITextStyle.offerItemTitle.copyWith(
                    color: context.reversedAdaptiveColor,
                  ),
                ),
                Text(
                  'Maison Sophie',
                  style: UITextStyle.offerItemTitle.copyWith(
                    fontSize: 20,
                    color: context.reversedAdaptiveColor,
                  ),
                ),
                Text(
                  'Sur les cupcakes 🧁',
                  style: UITextStyle.offerItemTitle.copyWith(
                    fontSize: 12,
                    color: context.reversedAdaptiveColor,
                  ),
                ),
                Text(
                  '07:00 - 20:30',
                  style: UITextStyle.offerItemTitle.copyWith(
                    fontSize: 12,
                    fontWeight: AppFontWeight.regular,
                    color: context.reversedAdaptiveColor,
                  ),
                ),
              ],
            ),
            const VerticalDivider(
              color: AppColors.white,
            ),
          ].spacerBetween(width: AppSpacing.lg),
        ),
      ),
    );
  }
}

// Custom Clipper for the ticket shape
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height / 3)
      ..arcToPoint(
        Offset(size.width, size.height * 2 / 3),
        radius: Radius.circular(size.height / 6),
        clockwise: false,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
