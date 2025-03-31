import 'package:flutter/material.dart';

/// {@template app_constrained_scroll_view}
/// The [AppCustomScrollView] is a scroll view that has a list of [Widget]
/// as its child and constrains the width and height of the scroll view
/// to the width and height of its parent.
/// {@endtemplate}
class AppCustomScrollView extends StatelessWidget {
  /// {@macro app_constrained_scroll_view}
  const AppCustomScrollView({
    required this.children,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.withScrollBar = false,
    this.controller,
    this.refreshCallback,
    super.key,
  });

  /// The widget inside a scroll view.
  final List<Widget> children;

  /// The padding to apply to the scroll view.
  final EdgeInsetsGeometry? padding;

  /// The [MainAxisAlignment] to apply to the [Column] inside a scroll view.
  final MainAxisAlignment mainAxisAlignment;

  /// Whether to wrap a scroll view with a [Scrollbar].
  final bool withScrollBar;

  /// Optional [ScrollController] to use for the scroll view.
  final ScrollController? controller;

  /// Optional callback to refresh the scroll view.
  final Future<void> Function()? refreshCallback;

  @override
  Widget build(BuildContext context) {
    final effectiveController = controller ?? ScrollController();

    final scrollView = CustomScrollView(
      controller: effectiveController,
      slivers: children,
    );

    final customScrollView = refreshCallback != null
        ? RefreshIndicator(
            onRefresh: refreshCallback!,
            child: scrollView,
          )
        : scrollView;

    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (withScrollBar) {
          true => Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              controller: effectiveController,
              child: customScrollView,
            ),
          false => customScrollView,
        };
      },
    );
  }
}
