import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return BlocListener<CreateChallengeCubit, CreateChallengeState>(
      listener: (context, state) {
        switch (state.status) {
          case CreateChallengeStatus.success:
            context.go('/challenge/${state.challengeId}');
          case CreateChallengeStatus.error:
            openSnackbar(
              SnackbarMessage.error(
                title: context.l10n.challengeCreationErrorTitle,
                description: state.errorMessage ?? '',
              ),
              clearIfQueue: true,
            );
          case CreateChallengeStatus.initial:
          case CreateChallengeStatus.loading:
        }
      },
      child: Padding(
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
                onPressed: () {
                  context.read<CreateChallengeCubit>().submit(
                        creator: user,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
