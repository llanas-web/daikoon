import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() => PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignUpPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpCubit(
            userRepository: context.read<UserRepository>(),
            notificationsRepository: context.read<NotificationsRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => ShowOtpCubit(),
        ),
        BlocProvider(
          create: (context) => OtpValidationCubit(
            userRepository: context.read<UserRepository>(),
          ),
        ),
      ],
      child: const SignUpTransitionSwitchView(),
    );
  }
}

class SignUpTransitionSwitchView extends StatelessWidget {
  const SignUpTransitionSwitchView({super.key});

  @override
  Widget build(BuildContext context) {
    final showOtp = context.select((ShowOtpCubit b) => b.state);

    return PageTransitionSwitcher(
      reverse: showOtp,
      transitionBuilder: (
        child,
        animation,
        secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: showOtp ? const OtpValidationView() : const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({
    super.key,
  });

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
              height: AppSpacing.xxxlg,
              fit: BoxFit.fitWidth,
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
                  const AppDivider(),
                  Align(
                    child: AuthProviderSignInButton(
                      provider: AuthProvider.apple,
                      isInProgress: context.select(
                        (SignUpCubit cubit) =>
                            cubit.state.submissionStatus.isAppleAuthInProgress,
                      ),
                      onPressed: () =>
                          context.read<SignUpCubit>().loginWithApple(),
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
