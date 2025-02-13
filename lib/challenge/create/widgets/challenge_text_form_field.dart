import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ChallengeTextFormField extends StatelessWidget {
  const ChallengeTextFormField({
    required this.hintText,
    required this.textController,
    this.suffixIcon,
    super.key,
  });

  final String hintText;
  final TextEditingController textController;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xlg,
            ),
            hintText: hintText,
            textController: textController,
            filled: true,
            filledColor: AppColors.white,
            hintStyle: const TextStyle(
              color: AppColors.grey,
            ),
            suffixIcon: suffixIcon ?? const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
