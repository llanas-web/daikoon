import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:daikoon/auth/sign_up/sign_up.dart';
import 'package:daikoon/auth/sign_up/widgets/sign_up_form.dart';
import 'package:daikoon/auth/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        userRepository: context.read<UserRepository>(),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.deepBlue,
      releaseFocus: true,
      resizeToAvoidBottomInset: true,
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.only(
          top: AppSpacing.xlg,
          left: AppSpacing.xlg,
          right: AppSpacing.xlg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const BackHomeButton(),
            const Gap.v(AppSpacing.xxxlg),
            const AppLogo(
              height: AppSpacing.xxxlg,
              fit: BoxFit.fitHeight,
              width: double.infinity,
            ),
            const Gap.v(AppSpacing.sm),
            Text(
              context.l10n.signUpLabel,
              style: UITextStyle.screenLabel.copyWith(
                color: context.customReversedAdaptiveColor(
                  light: AppColors.primary,
                ),
                letterSpacing: AppSpacing.md,
              ),
            ),
            const Gap.v(AppSpacing.xxlg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '* ${context.l10n.requiredFieldLabel}',
                    style: UITextStyle.caption.copyWith(
                      color: context.reversedAdaptiveColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  const SignUpForm(),
                  const Align(
                    child: SignUpButton(),
                  ),
                  const AppDivider(),
                  Align(
                    child: AuthProviderSignInButton(
                      provider: AuthProvider.google,
                      isInProgress: context.select(
                        (SignUpCubit cubit) =>
                            cubit.state.submissionStatus.isGoogleAuthInProgress,
                      ),
                      onPressed: () =>
                          context.read<SignUpCubit>().loginWithGoogle(),
                    ),
                  ),
                ].spacerBetween(height: AppSpacing.xlg),
              ),
            ),
            const ConditionsInfos(),
          ],
        ),
      ),
    );
  }
}
