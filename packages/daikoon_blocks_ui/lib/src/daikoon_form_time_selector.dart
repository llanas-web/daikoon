// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';

class DaikoonFormTimeSelector extends StatelessWidget {
  const DaikoonFormTimeSelector({
    required this.value,
    this.hintText,
    this.readOnly = false,
    this.onTimeSelected,
    super.key,
  });

  final DateTime? value;
  final String? hintText;
  final bool readOnly;
  final void Function(TimeOfDay)? onTimeSelected;

  Future<void> onTapDate(BuildContext context) async {
    if (readOnly || onTimeSelected == null) return;
    final defaultTimeOfDay = value != null
        ? TimeOfDay(
            hour: value!.day,
            minute: value!.minute,
          )
        : TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: defaultTimeOfDay,
    );
    if (time != null) {
      onTimeSelected!(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
        ),
      ),
      hintText: hintText,
      prefixIcon: const Icon(Icons.access_time),
      suffixIcon: !readOnly ? const Icon(Icons.arrow_drop_down) : null,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: UITextStyle.hintText,
      readOnly: true,
      textController: TextEditingController(
        text: value != null
            ? value!.format(
                context,
                dateFormat: DateFormat.Hm,
              )
            : hintText,
      ),
      onTap: () => onTapDate(context),
      style: UITextStyle.hintText.copyWith(
        fontSize: 12,
      ),
    );
  }
}
