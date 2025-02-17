// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DaikoonFormDateSelector extends StatefulWidget {
  const DaikoonFormDateSelector({
    required this.hintText,
    required this.minDate,
    required this.maxDate,
    required this.onDateSelected,
    super.key,
  });

  final String hintText;
  final DateTime minDate;
  final DateTime maxDate;
  final void Function(DateTime) onDateSelected;

  @override
  State<DaikoonFormDateSelector> createState() =>
      _DaikoonFormDateSelectorState();
}

class _DaikoonFormDateSelectorState extends State<DaikoonFormDateSelector> {
  late final TextEditingController textEditing;

  @override
  void initState() {
    super.initState();
    textEditing = TextEditingController();
  }

  Future<void> onTapDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.minDate,
      lastDate: widget.maxDate,
    );
    if (date != null) {
      widget.onDateSelected(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.xlg,
      ),
      hintText: widget.hintText,
      prefixIcon: const Icon(Icons.calendar_today),
      suffixIcon: const Icon(Icons.arrow_drop_down),
      filled: true,
      filledColor: AppColors.white,
      hintStyle: const TextStyle(
        color: AppColors.grey,
      ),
      readOnly: true,
      textController: textEditing,
      onTap: () => onTapDate(context),
    );
  }
}
