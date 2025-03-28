// ignore_for_file: deprecated_member_use

import 'package:app_ui/app_ui.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:daikoon/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class OtpValidationView extends StatelessWidget {
  const OtpValidationView({super.key});

  void _confirmGoBack(BuildContext context) => context.confirmAction(
        fn: () => context.read<ShowOtpCubit>().changeScreen(showOtp: false),
        title: context.l10n.goBackConfirmationText,
        content: context.l10n.loseAllEditsText,
        noText: context.l10n.cancelText,
        yesText: context.l10n.goBackText,
        yesTextStyle: context.labelLarge?.apply(color: AppColors.blue),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _confirmGoBack(context);
        return Future.value(false);
      },
      child: AppScaffold(
        backgroundColor: AppColors.deepBlue,
        appBar: AppBar(
          title: Text(
            context.l10n.signUpOtpValidationLabel,
            style: TextStyle(
              color: context.reversedAdaptiveColor,
            ),
          ),
          backgroundColor: AppColors.deepBlue,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.adaptive.arrow_back,
              color: context.reversedAdaptiveColor,
            ),
            onPressed: () => _confirmGoBack(context),
          ),
        ),
        releaseFocus: true,
        resizeToAvoidBottomInset: true,
        body: AppConstrainedScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            children: [
              const Gap.v(AppSpacing.xxxlg * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const OtpValidationForm(),
                    const Align(child: OtpValidationButton()),
                  ].spacerBetween(height: AppSpacing.md),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
