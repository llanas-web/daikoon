import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/login/cubit/login_cubit.dart';
import 'package:daikoon/auth/login/widgets/widgets.dart';
import 'package:daikoon/auth/widgets/widgets.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        userRepository: context.read<UserRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
              context.l10n.loginLabel,
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
                  const LoginForm(),
                  Tappable(
                    child: Text(
                      context.l10n.forgotPasswordButtonLabel,
                      style: UITextStyle.caption.copyWith(
                        color: context.reversedAdaptiveColor,
                        decoration: TextDecoration.underline,
                        decorationColor: context.reversedAdaptiveColor,
                      ),
                    ),
                  ),
                  const Align(
                    child: SignInButton(),
                  ),
                  const AppDivider(),
                  Align(
                    child: AuthProviderSignInButton(
                      provider: AuthProvider.google,
                      isInProgress: context.select(
                        (LoginCubit cubit) =>
                            cubit.state.status.isGoogleAuthInProgress,
                      ),
                      onPressed: () =>
                          context.read<LoginCubit>().loginWithGoogle(),
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
