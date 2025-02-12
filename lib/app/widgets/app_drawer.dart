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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Assets.images.daikoon.svg(),
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
              ].spacerBetween(height: AppSpacing.lg),
            ),
          ),
          _DrawerItemWidget(
            title: context.l10n.drawerListChallengeTitle,
            icon: Assets.icons.trophy,
            route: AppRoutes.listChallenges,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
      selected: isSelected,
      selectedColor: Colors.white,
      selectedTileColor: AppColors.primary,
      title: Text(title),
      leading: icon.svg(
        colorFilter: isSelected
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : null,
      ),
      onTap: () => context.go(route.route),
    );
  }
}
