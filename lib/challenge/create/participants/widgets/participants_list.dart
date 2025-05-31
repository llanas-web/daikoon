import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/view/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParticipantsList extends StatelessWidget {
  const ParticipantsList({super.key});

  @override
  Widget build(BuildContext context) {
    final participantsNames = context
        .select(
          (ParticipantsStepCubit cubit) => cubit.state.participants,
        )
        .map((participant) => participant.displayUsername);
    if (participantsNames.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Text(
        participantsNames.join(', '),
        style: UITextStyle.subtitle.copyWith(
          fontStyle: FontStyle.italic,
          color: AppColors.darkGrey,
        ),
        textAlign: TextAlign.start,
      );
    }
  }
}
