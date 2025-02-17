// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';

class DaikoonFormDateSelector extends StatelessWidget {
  const DaikoonFormDateSelector({
    required this.value,
    required this.hintText,
    required this.minDate,
    required this.maxDate,
    required this.onDateSelected,
    super.key,
  });

  final DateTime? value;
  final String hintText;
  final DateTime minDate;
  final DateTime maxDate;
  final void Function(DateTime) onDateSelected;

  Future<void> onTapDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? minDate,
      firstDate: minDate,
      lastDate: maxDate,
    );
    if (date != null) {
      onDateSelected(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: hintText,
      prefixIcon: const Icon(Icons.calendar_today),
      suffixIcon: const Icon(Icons.arrow_drop_down),
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
