import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/cubit/auth_cubit.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackHomeButton extends StatelessWidget {
  const BackHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: AppSpacing.xlg,
            color: context.reversedAdaptiveColor,
          ),
          onPressed: () =>
              context.read<AuthCubit>().changeAuth(status: AuthStatus.home),
        ),
        const Gap.h(AppSpacing.sm),
        Text(
          context.l10n.backButtonLabel,
          style: UITextStyle.caption.copyWith(
            color: context.reversedAdaptiveColor,
          ),
        ),
      ],
    );
  }
}
