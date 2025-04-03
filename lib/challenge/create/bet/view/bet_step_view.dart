import 'package:daikoon/challenge/create/bet/cubit/bet_step_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BetStepView extends StatelessWidget {
  const BetStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BetStepCubit(),
      child: const Column(
        children: [
          Spacer(),
          // Add your widgets here
          Spacer(),
        ],
      ),
    );
  }
}
