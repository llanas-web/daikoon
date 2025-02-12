import 'package:app_ui/app_ui.dart';
import 'package:daikoon/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class UserProfileAddFriend extends StatelessWidget {
  const UserProfileAddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const UserProfileAddFriendsView(),
    );
  }
}

class UserProfileAddFriendsView extends StatefulWidget {
  const UserProfileAddFriendsView({super.key});

  @override
  State<UserProfileAddFriendsView> createState() =>
      _UserProfileAddFriendsViewState();
}

class _UserProfileAddFriendsViewState extends State<UserProfileAddFriendsView> {
  late TextEditingController searchQueryController;
  @override
  void initState() {
    super.initState();
    searchQueryController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final users = ValueNotifier(<User>[]);

    return AppScaffold(
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Ajouter un ami'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: context.reversedAdaptiveColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: AppSpacing.xxxlg,
            backgroundColor: Colors.white,
            elevation: 1,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ), // Adjust padding
              child: AppTextField(
                hintText: 'Search friends...',
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs,
                  ),
                  child: AppButton(
                    textStyle: UITextStyle.button.copyWith(
                      color: context.reversedAdaptiveColor,
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.primary.withValues(alpha: 0.7),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    text: 'OK',
                    onPressed: () async {
                      users.value =
                          await context.read<UserRepository>().searchUsers(
                                query: searchQueryController.text,
                              );
                    },
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1), // Height of the border
              child: Container(
                color: Colors.grey[300], // Light grey border color
                height: 1, // Border thickness
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: users,
            builder: (context, users, _) {
              return SliverList.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return _FriendTile(
                    user: user,
                    onAddFriend: () async {
                      logD('AddFriend');
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
    required this.onAddFriend,
  });

  final User user;
  final Future<void> Function() onAddFriend;

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
                        style: context.bodyLarge!.copyWith(
                          fontWeight: AppFontWeight.semiBold,
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
                        style: context.labelLarge?.copyWith(
                          fontWeight: AppFontWeight.medium,
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
          _AddFriendButton(onPressed: onAddFriend),
        ].spacerBetween(width: AppSpacing.md),
      ),
    );
  }
}

class _AddFriendButton extends StatefulWidget {
  const _AddFriendButton({
    required this.onPressed,
  });

  final Future<void> Function() onPressed;

  @override
  State<_AddFriendButton> createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends State<_AddFriendButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(context.reversedAdaptiveColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
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
      text: 'Ajouter',
      style: style,
      textStyle: TextStyle(
        color: context.adaptiveColor,
      ),
      onPressed: () async {
        isLoading = true;
        await widget.onPressed.call();
        isLoading = false;
      },
      loading: isLoading,
    );
  }
}
