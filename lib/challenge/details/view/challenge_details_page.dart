import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/details/challenge_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeDetailsPage extends StatelessWidget {
  const ChallengeDetailsPage({
    required this.challengeId,
    super.key,
  });

  final String challengeId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChallengeDetailsCubit(
        userId: context.read<AppBloc>().state.user.id,
        challengeId: challengeId,
        challengeRepository: context.read<ChallengeRepository>(),
      )..fetchChallengeDetails(),
      child: const ChallengeDetailsView(),
    );
  }
}

class ChallengeDetailsView extends StatelessWidget {
  const ChallengeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        constraints: const BoxConstraints.expand(),
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
        child: BlocBuilder<ChallengeDetailsCubit, ChallengeDetailsState>(
          builder: (context, state) {
            if (state.status == ChallengeDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ChallengeDetailsStatus.failed) {
              return const Center(child: Text('Error'));
            } else {
              return const AppConstrainedScrollView(
                child: ChallengeDetails(),
              );
            }
          },
        ),
      ),
    );
  }
}
