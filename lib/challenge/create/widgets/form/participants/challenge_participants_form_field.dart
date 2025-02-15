import 'package:app_ui/app_ui.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class ChallengeParticipantsFormField extends StatefulWidget {
  const ChallengeParticipantsFormField({super.key});

  @override
  State<ChallengeParticipantsFormField> createState() =>
      _ChallengeParticipantsFormFieldState();
}

class _ChallengeParticipantsFormFieldState
    extends State<ChallengeParticipantsFormField> {
  late final Debouncer _debouncer;
  late final TextEditingController _friendsSearchController;

  @override
  void initState() {
    super.initState();
    _friendsSearchController = TextEditingController();
    _debouncer = Debouncer();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _friendsSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = ValueNotifier(<User>[]);
    return Column(
      children: [
        AppTextField(
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.xlg,
          ),
          hintText: context.l10n.challengeCreationParticipantsFormFieldHint,
          filled: true,
          filledColor: AppColors.white,
          hintStyle: const TextStyle(
            color: AppColors.grey,
          ),
          textController: _friendsSearchController,
          onChanged: (newTitle) => _debouncer.run(() async {
            users.value = await context
                .read<UserRepository>()
                .searchFriends(query: _friendsSearchController.text);
          }),
        ),
        ValueListenableBuilder(
          valueListenable: users,
          builder: (context, users, _) {
            return Column(
              children: [
                for (final user in users)
                  ListTile(
                    title: Text(user.username ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        context.read<CreateChallengeCubit>().onParticipantAdded(
                              user,
                            );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ].spacerBetween(height: AppSpacing.xxlg),
    );
  }
}
