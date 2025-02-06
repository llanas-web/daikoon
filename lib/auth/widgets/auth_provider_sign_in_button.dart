import 'package:app_ui/app_ui.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class AuthProviderSignInButton extends StatelessWidget {
  const AuthProviderSignInButton({
    required this.provider,
    required this.onPressed,
    required this.isInProgress,
    super.key,
  });

  final AuthProvider provider;

  final VoidCallback onPressed;

  final bool isInProgress;

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = switch (provider) {
      AuthProvider.google => Assets.icons.google.svg(),
    };
    final icon = SizedBox.square(
      dimension: 24,
      child: effectiveIcon,
    );

    return Tappable.faded(
      throttle: true,
      throttleDuration: 650.ms,
      backgroundColor: context.theme.focusColor,
      borderRadius: BorderRadius.circular(4),
      onTap: isInProgress ? null : onPressed,
      child: isInProgress
          ? Center(child: AppCircularProgress(context.adaptiveColor))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: icon),
                  Flexible(
                    child: Text(
                      context.l10n.signInWithText(provider.value),
                      style: context.labelSmall?.copyWith(
                        overflow: TextOverflow.ellipsis,
                        color: context.reversedAdaptiveColor,
                      ),
                    ),
                  ),
                ].spacerBetween(width: AppSpacing.sm),
              ),
            ),
    );
  }
}

enum AuthProvider {
  google('Google');

  const AuthProvider(this.value);

  final String value;
}
