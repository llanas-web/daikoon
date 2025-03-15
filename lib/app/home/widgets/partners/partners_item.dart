import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class PartnersItem extends StatelessWidget {
  const PartnersItem({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.stars,
    required this.distance,
    required this.price,
    super.key,
  });

  final AssetGenImage image;
  final String title;
  final String subtitle;
  final String description;
  final double stars;
  final double distance;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth * 0.65,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xxlg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.2),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: image.image().image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.dark.withValues(alpha: 0),
                          AppColors.dark.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.xlg,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: AppColors.white,
                              size: AppSpacing.xlg,
                            ),
                          ],
                        ),
                        Text(
                          title,
                          style: UITextStyle.titleSmallBold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md,
                horizontal: AppSpacing.xlg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: UITextStyle.bodyText.copyWith(
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: UITextStyle.bodyText,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.stars_rounded,
                                      color: AppColors.primary,
                                      size: AppSpacing.lg,
                                    ),
                                    Text(
                                      stars.toString(),
                                      style: UITextStyle.partnerItemDistance
                                          .copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$distance km',
                                  style:
                                      UITextStyle.partnerItemDistance.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ].spacerBetween(width: AppSpacing.md),
                            ),
                            Text(
                              '$price €',
                              style: UITextStyle.partnerItemPrice.copyWith(
                                color: AppColors.secondary,
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
          ),
        ],
      ),
    );
  }
}
