// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class DaikoonFormRadioItem extends StatelessWidget {
  const DaikoonFormRadioItem({
    required this.title,
    required this.onTap,
    required this.isSelected,
    this.child,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: isSelected
                    ? Border.all(
                        color: AppColors.primary,
                        width: AppSpacing.xxs,
                      )
                    : Border.all(
                        color: AppColors.white,
                        width: AppSpacing.xxs,
                      ),
                color: AppColors.white,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.xlg,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (child != null)
                    Expanded(child: child!)
                  else
                    Text(
                      title,
                      style: context.bodyLarge,
                    ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: AppSpacing.xlg,
                        height: AppSpacing.xlg,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                          border: Border.all(
                            color: AppColors.primary,
                            width: AppSpacing.xxs,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: AppSpacing.lg,
                          height: AppSpacing.lg,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
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
