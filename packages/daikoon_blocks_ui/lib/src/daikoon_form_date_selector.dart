// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';

class DaikoonFormDateSelector extends StatelessWidget {
  const DaikoonFormDateSelector({
    required this.value,
    this.hintText,
    this.readOnly = false,
    this.minDate,
    this.maxDate,
    this.onDateSelected,
    super.key,
  });

  final DateTime? value;
  final bool readOnly;
  final String? hintText;
  final DateTime? minDate;
  final DateTime? maxDate;
  final void Function(DateTime)? onDateSelected;

  Future<void> onTapDate(BuildContext context) async {
    if (readOnly || onDateSelected == null) return;
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? minDate,
      firstDate: minDate ?? DateTime.now(),
      lastDate: maxDate ?? DateTime.now().add(365.days),
    );
    if (date != null) {
      onDateSelected!(date);
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
      prefixIcon: const Icon(Icons.calendar_today),
      suffixIcon: !readOnly ? const Icon(Icons.arrow_drop_down) : null,
      filled: true,
      filledColor: AppColors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      readOnly: true,
      textController: TextEditingController(
        text: value != null
            ? value!.format(
                context,
                dateFormat: DateFormat.yMMMd,
              )
            : hintText,
      ),
      onTap: () => onTapDate(context),
    );
  }
}
