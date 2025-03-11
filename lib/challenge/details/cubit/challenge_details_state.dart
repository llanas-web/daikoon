part of 'challenge_details_cubit.dart';

enum ChallengeDetailsStatus { loading, loaded, failed }

class ChallengeDetailsState extends Equatable {
  const ChallengeDetailsState._({
    required this.challenge,
    required this.status,
    required this.bets,
  });

  ChallengeDetailsState.initial()
      : this._(
          challenge: null,
          status: ChallengeDetailsStatus.loading,
          bets: [],
        );

  final Challenge? challenge;
  final ChallengeDetailsStatus status;
  final List<Bet> bets;

  ChallengeDetailsState copyWith({
    Challenge? challenge,
    ChallengeDetailsStatus? status,
    List<Bet>? bets,
  }) {
    return ChallengeDetailsState._(
      challenge: challenge ?? this.challenge,
      status: status ?? this.status,
      bets: bets ?? this.bets,
    );
  }

  @override
  List<Object> get props => [
        challenge ?? status.name,
        status,
        bets,
      ];
}
