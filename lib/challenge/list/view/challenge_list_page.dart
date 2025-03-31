import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/list/challenge_list.dart';
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
    final challengeListCubit = context.read<ChallengesCubit>();

    Future<void> refreshChallenges() async {
      challengeListCubit.fetchChallenges();
    }

    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.bluryBackground.provider(),
          ),
        ),
        child: AppCustomScrollView(
          withScrollBar: true,
          refreshCallback: refreshChallenges,
          children: [
            BetterStreamBuilder<List<Challenge>>(
              initialData: const <Challenge>[],
              stream: challengeListCubit.fetchChallenges(),
              builder: (context, challenges) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) => Column(
                      children: [
                        ChallengeItem(challenge: challenges[index]),
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
