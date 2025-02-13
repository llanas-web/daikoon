import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/create/bloc/create_challenge_bloc.dart';
import 'package:daikoon/challenge/create/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengePage extends StatelessWidget {
  const CreateChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateChallengeBloc(),
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

  final List<Widget> stepsForm = [
    const ChallengeTitleForm(),
    const ChallengeQuestionForm(),
  ];

  int lastIndex = 0;

  @override
  Widget build(BuildContext context) {
    final formIndex =
        context.select((CreateChallengeBloc bloc) => bloc.state.formIndex);

    final reverse = lastIndex > formIndex;
    lastIndex = formIndex;

    return AppScaffold(
      appBar: const HomeAppBar(),
      body: Container(
        padding: const EdgeInsets.all(AppSpacing.xxlg),
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
                transitionType:
                    SharedAxisTransitionType.horizontal, // Left ↔ Right
                child: child,
              );
            },
            child: stepsForm[formIndex],
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
