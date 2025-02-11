import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:daikoon/user_profile/bloc/user_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileEditSaveButton extends StatelessWidget {
  const UserProfileEditSaveButton({
    required this.onPressed,
    super.key,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        switch (state.status) {
          case UserProfileStatus.initial:
            break;
          case UserProfileStatus.userUpdateFailed:
            openSnackbar(
              SnackbarMessage.error(
                title: userProfileStatusMessage[state.status]!.title,
                description:
                    userProfileStatusMessage[state.status]?.description,
              ),
              clearIfQueue: true,
            );
          case UserProfileStatus.userUpdated:
            context.pop();
            openSnackbar(
              SnackbarMessage.success(
                title: context.l10n.profileUpdatedTitle,
              ),
              clearIfQueue: true,
            );
        }
      },
      child: AppButton(
        textStyle: UITextStyle.button.copyWith(
          color: context.reversedAdaptiveColor,
        ),
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(
              vertical: AppSpacing.md * 1.5,
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            AppColors.secondary,
          ),
        ),
        onPressed: onPressed,
        text: context.l10n.saveText,
      ),
    );
  }
}
