import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:daikoon/app/bloc/app_bloc.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// {@template main_bottom_navigation_bar}
/// Bottom navigation bar of the application. It contains the [navigationShell]
/// that will handle the navigation between the different bottom navigation
/// bars.
/// {@endtemplate}
class BottomNavBar extends StatelessWidget {
  /// {@macro bottom_nav_bar}
  const BottomNavBar({
    required this.navigationShell,
    super.key,
  });

  /// Navigation shell that will handle the navigation between the different
  /// bottom navigation bars.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final hasNotification =
        context.select((AppBloc bloc) => bloc.state.hasNotification);
    final navigationBarItems = mainNavigationBarItems(
      homeLabel: context.l10n.homeNavBarItemLabel,
      searchLabel: context.l10n.searchNavBarItemLabel,
      favoriteLabel: context.l10n.favoriteNavBarItemLabel,
      notificationLabel: context.l10n.notificationNavBarItemLabel,
      userProfileLabel: context.l10n.profileNavBarItemLabel,
      hasNotification: hasNotification,
    );

    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      iconSize: AppSize.iconSize,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: navigationBarItems.mapIndexed(
        (index, navBarItem) {
          final isSelected = index == navigationShell.currentIndex;
          final bellColor = isSelected
              ? AppColors.secondary
              : AppColors.primary.withValues(alpha: 0.5);
          final iconWidget = (navBarItem.label ==
                  context.l10n.notificationNavBarItemLabel)
              ? _NotificationIcon(
                  isSelected: isSelected,
                ) // <- subscribes & rebuilds on change
              : navBarItem.icon.svg(theme: SvgTheme(currentColor: bellColor));
          return BottomNavigationBarItem(
            icon: iconWidget,
            label: navBarItem.label,
            tooltip: navBarItem.tooltip,
          );
        },
      ).toList(),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final hasNotification =
        context.select((AppBloc bloc) => bloc.state.hasNotification);

    final icon = hasNotification
        ? Assets.icons.notificationActif
        : Assets.icons.notification;

    return icon.svg(
      theme: isSelected
          ? const SvgTheme(currentColor: AppColors.secondary)
          : SvgTheme(currentColor: AppColors.primary.withValues(alpha: 0.5)),
    );
  }
}
