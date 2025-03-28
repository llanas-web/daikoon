import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class OtpValidationForm extends StatefulWidget {
  const OtpValidationForm({super.key});

  @override
  State<OtpValidationForm> createState() => _OtpValidationFormState();
}

class _OtpValidationFormState extends State<OtpValidationForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpValidationCubit, OtpValidationState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          openSnackbar(
            SnackbarMessage.error(
              title: otpValidationSatusMessage[state.status]!.title,
              description: otpValidationSatusMessage[state.status]?.description,
            ),
            clearIfQueue: true,
          );
        }
      },
      listenWhen: (p, c) => p.status != c.status,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OtpFormField<OtpValidationCubit, OtpValidationState>(
            onOtpChanged: (cubit, otp) => cubit.onOtpChanged(otp),
            onOtpUnfocused: (cubit) => cubit.onOtpUnfocused(),
            otpError: context.select(
              (OtpValidationCubit cubit) => cubit.state.otp.errorMessage,
            ),
            isLoading: context.select(
              (OtpValidationCubit cubit) => cubit.state.status.isLoading,
            ),
          ),
        ].spacerBetween(height: AppSpacing.md),
      ),
    );
  }
}
