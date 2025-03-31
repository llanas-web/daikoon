import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
        userId: userId,
      )..add(
          const UserProfileSubscriptionRequested(),
        ),
      child: const UserProfileView(),
    );
  }
}

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select(
      (UserProfileBloc bloc) => bloc.isOwner,
    );
    final user = context.select(
      (UserProfileBloc bloc) => bloc.state.user,
    );

    return AppScaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: AppSpacing.xxxlg * 4,
            pinned: true,
            shadowColor: AppColors.deepBlue,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(user.displayUsername),
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
        body: AppCustomScrollView(
          children: [
            SliverList(
              delegate: SliverChildListDelegate(
                isOwner
                    ? [
                        _UserProfileTileItem(
                          icon: const Icon(Icons.info_outline),
                          title: context.l10n.userProfileTileInformationLabel,
                          onTap: () => context.pushNamed(
                            AppRoutes.editProfile.name,
                          ),
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
                          onTap: () => context.pushNamed(
                            AppRoutes.daikoins.name,
                          ),
                        ),
                        _UserProfileTileItem(
                          icon: const Icon(Icons.lock_outline),
                          title:
                              context.l10n.userProfileTileChangePasswordLabel,
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
                          onTap: () => context.pushNamed(
                            AppRoutes.friends.name,
                          ),
                        ),
                        _UserProfileTileItem(
                          icon: const Icon(Icons.logout),
                          title: context.l10n.userProfileTileLogoutLabel,
                          onTap: () => context.confirmAction(
                            fn: () {
                              context.read<AppBloc>().add(
                                    const AppLogoutRequested(),
                                  );
                            },
                            title: context.l10n.logOutText,
                            content: context.l10n.logOutConfirmationText,
                            noText: context.l10n.cancelText,
                            yesText: context.l10n.logOutText,
                          ),
                          trailing: false,
                        ),
                      ]
                    : [],
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
      title: Text(title, style: UITextStyle.drawerLabel),
      trailing: trailing ? const Icon(Icons.arrow_forward_ios) : null,
      onTap: onTap,
      splashColor: AppColors.primary,
    );
  }
}
