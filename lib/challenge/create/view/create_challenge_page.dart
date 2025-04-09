import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateChallengePage extends StatelessWidget {
  const CreateChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateChallengeCubit(
            challengeRepository: context.read<ChallengeRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => FormStepperCubit(),
        ),
      ],
      child: const CreateChallengeView(),
    );
  }
}

class CreateChallengeView extends StatefulWidget {
  const CreateChallengeView({super.key});

  @override
  State<CreateChallengeView> createState() => _CreateChallengeViewState();
}

class _CreateChallengeViewState extends State<CreateChallengeView> {
  late AnimationController animationController;

  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasBet =
        context.select((CreateChallengeCubit cubit) => cubit.state.hasBet);

    final stepsForm = <Widget>[
      const TitleStepView(),
      const PronosticStepView(),
      const BetStepView(),
      if (hasBet) const BetAmountStepView(),
      const ParticipantsStepView(),
      const DatesStepView(),
      const ChallengeResume(),
    ];

    final formIndex = context.select((FormStepperCubit bloc) => bloc.state);

    final reverse = lastIndex > formIndex;
    lastIndex = formIndex;

    return BackButtonListener(
      onBackButtonPressed: () async {
        formIndex == 0
            ? GoRouter.of(context).go('/home')
            : context.read<FormStepperCubit>().previousStep();
        return true;
      },
      child: AppScaffold(
        appBar: const HomeAppBar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.images.bluryBackground.provider(),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0),
                AppColors.primary.withValues(alpha: 0.5),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxlg),
          child: Center(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 1000),
              reverse: reverse,
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  fillColor: Colors.transparent,
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        AppConstrainedScrollView(child: child),
                  ),
                );
              },
              child: stepsForm[formIndex],
            ),
          ),
        ),
        drawer: const AppDrawer(),
      ),
    );
  }
}
