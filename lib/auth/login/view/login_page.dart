import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/login/login.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.deepBlue,
        title: Text(
          context.l10n.backButtonLabel,
          style: TextStyle(
            color: context.reversedAdaptiveColor,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: context.reversedAdaptiveColor,
          ),
          onPressed: () =>
              context.read<AuthCubit>().changeAuth(status: AuthStatus.home),
        ),
      ),
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
            const Gap.v(AppSpacing.xxxlg),
            const AppLogo(
              fit: BoxFit.fitWidth,
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
                  const ForgotPasswordButton(),
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
