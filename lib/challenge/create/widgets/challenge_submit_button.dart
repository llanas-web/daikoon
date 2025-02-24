import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeSubmitButton extends StatelessWidget {
  const ChallengeSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AppBloc>().state.user;
    const style = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        AppColors.secondary,
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.xxlg,
        ),
      ),
    );
    final textStyle =
        UITextStyle.button.copyWith(color: context.reversedAdaptiveColor);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              style: style,
              textStyle: textStyle,
              text: context.l10n.challengeCreationSubmitButtonLabel,
              onPressed: () => context.read<CreateChallengeCubit>().submit(
                    creator: user,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
