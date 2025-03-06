import 'package:app_ui/app_ui.dart';
import 'package:challenge_repository/challenge_repository.dart';
import 'package:daikoon/app/app.dart';
import 'package:daikoon/challenge/details/challenge_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    final challengeStatus = context.select(
      (ChallengeDetailsCubit cubit) => cubit.state.status,
    );
    return AppScaffold(
      appBar: const HomeAppBar(),
      drawer: const AppDrawer(),
      body: Center(
        child: challengeStatus == ChallengeDetailsStatus.loading
            ? const CircularProgressIndicator()
            : const ChallengeDetails(),
      ),
    );
  }
}
