import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfileView();
  }
}

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: AppSpacing.xxxlg * 4,
            pinned: true,
            shadowColor: AppColors.deepBlue,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('User Name'),
              centerTitle: true,
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Assets.images.profilePic.image(),
              ),
            ),
          ),
        ],
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _UserProfileTileItem(
                    icon: const Icon(Icons.info_outline),
                    title: context.l10n.userProfileTileInformationLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: Assets.icons.historic.svg(
                      width: AppSpacing.xlg,
                    ),
                    title: context.l10n.userProfileTileHistoricLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: Assets.icons.daikoon.svg(
                      colorFilter: ColorFilter.mode(
                        context.adaptiveColor,
                        BlendMode.srcIn,
                      ),
                      width: AppSpacing.xlg,
                    ),
                    title: context.l10n.userProfileTileDaikoinsLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: const Icon(Icons.lock_outline),
                    title: context.l10n.userProfileTileChangePasswordLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: const Icon(Icons.settings),
                    title: context.l10n.userProfileTileSettingsLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: Assets.icons.friends.svg(
                      width: AppSpacing.xlg,
                    ),
                    title: context.l10n.userProfileTileFriendsLabel,
                    onTap: () {},
                  ),
                  _UserProfileTileItem(
                    icon: const Icon(Icons.logout),
                    title: context.l10n.userProfileTileLogoutLabel,
                    onTap: () {},
                    trailing: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileTileItem extends StatelessWidget {
  const _UserProfileTileItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing = true,
  });

  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xlg,
        vertical: AppSpacing.sm,
      ),
      minLeadingWidth: AppSpacing.xxlg,
      leading: icon,
      title: Text(title),
      trailing: trailing ? const Icon(Icons.arrow_forward_ios) : null,
      onTap: onTap,
    );
  }
}
