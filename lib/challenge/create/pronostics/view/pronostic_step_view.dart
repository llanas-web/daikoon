import 'package:daikoon/challenge/create/pronostics/cubit/pronostic_step_cubit.dart';
import 'package:daikoon/challenge/create/pronostics/widgets/pronostic_step_form.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PronosticStepView extends StatelessWidget {
  const PronosticStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PronosticStepCubit(),
      child: const Column(
        children: [
          Spacer(),
          PronosticStepForm(),
          Spacer(),
        ],
      ),
    );
  }
}
