import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:daikoon/app/routes/app_routes.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileFriends extends StatelessWidget {
  const UserProfileFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const UserProfileFriendsView(),
    );
  }
}

class UserProfileFriendsView extends StatefulWidget {
  const UserProfileFriendsView({super.key});

  @override
  State<UserProfileFriendsView> createState() => _UserProfileFriendsViewState();
}

class _UserProfileFriendsViewState extends State<UserProfileFriendsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final friendsStream = context.read<UserProfileBloc>().friends;

    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          context.l10n.userProfileTileFriendsLabel,
          style: UITextStyle.navTitle,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: context.reversedAdaptiveColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.pushNamed(AppRoutes.addFriends.name),
          ),
        ],
      ),
      body: AppCustomScrollView(
        children: [
          BetterStreamBuilder(
            initialData: const <User>[],
            stream: friendsStream,
            comparator: const ListEquality<User>().equals,
            builder: (context, friends) {
              if (friends.isEmpty) {
                return const EmptyFriends();
              }
              return SliverList.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final user = friends[index];
                  return _FriendTile(
                    user: user,
                    onUnfriend: () {
                      context.read<UserProfileBloc>().add(
                            UserProfileUnfriendRequested(friendId: user.id),
                          );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  const _FriendTile({
    required this.user,
    required this.onUnfriend,
  });

  final User user;
  final VoidCallback onUnfriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxlg,
        vertical: AppSpacing.xlg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: UITextStyle.subtitleBold.copyWith(
                          color: AppColors.black,
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.displayUsername,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        user.displayFullName,
                        style: UITextStyle.subtitle.copyWith(
                          color: AppColors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Gap.h(AppSpacing.md),
              ],
            ),
          ),
          _UnfriendButton(onPressed: onUnfriend),
        ].spacerBetween(width: AppSpacing.md),
      ),
    );
  }
}

class _UnfriendButton extends StatelessWidget {
  const _UnfriendButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(context.reversedAdaptiveColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      side: const WidgetStatePropertyAll(
        BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      elevation: const WidgetStatePropertyAll(0),
    );
    return AppButton(
      text: 'Retirer',
      style: style,
      textStyle: const TextStyle(
        color: AppColors.primary,
      ),
      onPressed: onPressed,
    );
  }
}

class EmptyFriends extends StatelessWidget {
  const EmptyFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          children: [
            Text(
              "Pas d'amis encore ? 🫠",
              style: UITextStyle.subtitleBold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.primary,
                        ),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                            horizontal: AppSpacing.xxlg,
                          ),
                        ),
                      ),
                      textStyle: UITextStyle.buttonText.copyWith(
                        color: context.reversedAdaptiveColor,
                      ),
                      text: 'Trouver des amis',
                      onPressed: () =>
                          context.pushNamed(AppRoutes.addFriends.name),
                    ),
                  ),
                ],
              ),
            ),
          ].spacerBetween(
            height: AppSpacing.lg,
          ),
        ),
      ),
    );
  }
}
