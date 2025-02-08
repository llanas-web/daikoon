import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/auth/cubit/auth_cubit.dart';
import 'package:daikoon/auth/login/login.dart';
import 'package:daikoon/auth/sign_up/sign_up.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.select((AuthCubit b) => b.state);

    return PageTransitionSwitcher(
      reverse: authState == AuthStatus.home,
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
      child: switch (authState) {
        AuthStatus.home => const _HomePage(),
        AuthStatus.login => const LoginPage(),
        AuthStatus.signUp => const SignUpPage(),
      },
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColors.primary,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.authBackground.image().image,
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.only(top: 262),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.primary,
                AppColors.white.withValues(alpha: 0),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image(
                image: Assets.images.daikoonBlury.image().image,
                width: double.infinity,
                color: context.reversedAdaptiveColor,
              ),
              const SizedBox(
                height: AppSpacing.xlg,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: context.l10n.signUpLabel,
                      onPressed: () => context
                          .read<AuthCubit>()
                          .changeAuth(status: AuthStatus.signUp),
                      textStyle: UITextStyle.button.copyWith(
                        color: context.reversedAdaptiveColor,
                      ),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          context.reversedAdaptiveColor.withValues(alpha: 0.4),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: context.reversedAdaptiveColor
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.lg,
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton.outlined(
                      text: context.l10n.loginLabel,
                      onPressed: () => context
                          .read<AuthCubit>()
                          .changeAuth(status: AuthStatus.login),
                      textStyle: UITextStyle.button.copyWith(
                        color: context.reversedAdaptiveColor,
                      ),
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        side: WidgetStateProperty.all(
                          BorderSide(
                            color: context.reversedAdaptiveColor
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSpacing.xxlg * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
