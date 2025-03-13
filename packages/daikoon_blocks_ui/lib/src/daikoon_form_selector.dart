// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class DaikoonFormSelector<T> extends StatefulWidget {
  const DaikoonFormSelector({
    required this.hintText,
    required this.onChange,
    required this.onSelect,
    required this.getItemLabel,
    super.key,
  });

  final String hintText;
  final Future<List<T>> Function(String) onChange;
  final void Function(T) onSelect;
  final String Function(T) getItemLabel;

  @override
  State<DaikoonFormSelector<T>> createState() => _DaikoonFormSelectorState<T>();
}

class _DaikoonFormSelectorState<T> extends State<DaikoonFormSelector<T>> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;
  late final bool _isDropdownVisible;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _debouncer = Debouncer();
    _isDropdownVisible = true;
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSelect(T item) {
    widget.onSelect(item);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final listItems = ValueNotifier(<T>[]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.xlg,
          ),
          hintText: widget.hintText,
          filled: true,
          filledColor: AppColors.white,
          hintStyle: const TextStyle(
            color: AppColors.grey,
          ),
          textController: _controller,
          onChanged: (value) => _debouncer.run(() async {
            listItems.value = await widget.onChange(value);
          }),
        ),
        ValueListenableBuilder<List<T>>(
          valueListenable: listItems,
          builder: (context, items, _) {
            if (items.isEmpty || !_isDropdownVisible) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: items.length * 50.0 <= 200
                        ? items.length * 50.0
                        : 200, // Max height of 200px
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(widget.getItemLabel(item)),
                          onTap: () {
                            _onSelect(item);
                            listItems.value = [];
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
