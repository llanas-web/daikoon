import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/list/cubit/challenges_cubit.dart';
import 'package:daikoon_blocks_ui/daikoon_blocks_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

class ChallengeListPage extends StatelessWidget {
  const ChallengeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChallengesCubit(
        challengeRepository: context.read<ChallengeRepository>(),
        userId: context.read<AppBloc>().state.user.id,
      ),
      child: const ChallengeListView(),
    );
  }
}

class ChallengeListView extends StatelessWidget {
  const ChallengeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final listChallenges =
        context.select((ChallengesCubit cubit) => cubit.challenges);
    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bluryBackground.provider(),
          ),
        ),
        child: CustomScrollView(
          slivers: [
            BetterStreamBuilder<List<Challenge>>(
              initialData: const <Challenge>[],
              stream: listChallenges,
              builder: (context, challenges) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(challenges[index].title ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                    itemCount: challenges.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
