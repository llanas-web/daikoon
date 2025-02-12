import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Drawer(
      width: MediaQuery.of(context).size.width,
      // Make drawer wit no rounded border
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.xxlg,
            ),
            // adding bottom border
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primary,
                ),
              ),
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Assets.images.daikoon.svg(
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.drawerHeadline(user.displayUsername),
                      style: context.headlineMedium,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxlg,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.drawerWelcomeText,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ].spacerBetween(height: AppSpacing.xlg),
            ),
          ),
          _DrawerItemWidget(
            title: context.l10n.drawerListChallengeLabel,
            icon: Assets.icons.challenge,
            route: AppRoutes.createChallenge,
          ),
          _DrawerItemWidget(
            title: context.l10n.drawerListChallengeLabel,
            icon: Assets.icons.trophy,
            route: AppRoutes.listChallenges,
          ),
          _DrawerItemWidget(
            title: context.l10n.drawerFriendsLabel,
            icon: Assets.icons.friends,
            route: AppRoutes.friends,
          ),
          _DrawerItemWidget(
            title: context.l10n.drawerDaikoinsLabel,
            icon: Assets.icons.daikoon,
            route: AppRoutes.daikoins,
          ),
        ],
      ),
    );
  }
}

class _DrawerItemWidget extends StatelessWidget {
  const _DrawerItemWidget({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final SvgGenImage icon;
  final AppRoutes route;

  @override
  Widget build(
    BuildContext context,
  ) {
    final isSelected = GoRouter.of(context).state.name == route.name;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xxlg,
      ),
      selected: isSelected,
      selectedColor: Colors.white,
      selectedTileColor: AppColors.primary,
      title: Text(
        title,
        style: context.labelMedium!.copyWith(
          fontWeight: AppFontWeight.bold,
          color: isSelected
              ? context.reversedAdaptiveColor
              : context.adaptiveColor,
        ),
      ),
      leading: icon.svg(
        colorFilter: isSelected
            ? ColorFilter.mode(context.reversedAdaptiveColor, BlendMode.srcIn)
            : ColorFilter.mode(context.adaptiveColor, BlendMode.srcIn),
      ),
      onTap: () => context.go(route.route),
    );
  }
}
