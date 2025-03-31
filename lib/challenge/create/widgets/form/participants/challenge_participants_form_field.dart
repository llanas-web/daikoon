import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ChallengeParticipantsFormField extends StatefulWidget {
  const ChallengeParticipantsFormField({super.key});

  @override
  State<ChallengeParticipantsFormField> createState() =>
      _ChallengeParticipantsFormFieldState();
}

class _ChallengeParticipantsFormFieldState
    extends State<ChallengeParticipantsFormField> {
  @override
  Widget build(BuildContext context) {
    return DaikoonFormSelector<User>(
      hintText: context.l10n.challengeCreationParticipantsFormFieldHint,
      onChange: (value) async {
        final users = await context.read<UserRepository>().searchFriends(
              query: value,
            );
        return users;
      },
      onSelect: (user) {
        context.read<CreateChallengeCubit>().onParticipantAdded(user);
      },
      getItemLabel: (user) => user.displayUsername,
    );
  }
}
