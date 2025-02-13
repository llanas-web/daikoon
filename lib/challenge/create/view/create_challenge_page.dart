import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/create/create_challenge.dart';
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
    const ChallengeBetForm(),
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bluryBackground.provider(),
          ),
        ),
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
                fillColor: Colors.transparent,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              child,
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
