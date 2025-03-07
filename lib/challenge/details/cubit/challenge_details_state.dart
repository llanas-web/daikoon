part of 'challenge_details_cubit.dart';

enum ChallengeDetailsStatus { loading, loaded, failed }

class ChallengeDetailsState extends Equatable {
  const ChallengeDetailsState._({
    required this.challenge,
    required this.status,
    required this.bets,
    required this.userBet,
  });

  ChallengeDetailsState.initial(String userId)
      : this._(
          challenge: null,
          status: ChallengeDetailsStatus.loading,
          bets: [],
          userBet: Bet(userId: userId),
        );

  final Challenge? challenge;
  final ChallengeDetailsStatus status;
  final List<Bet> bets;
  final Bet userBet;

  ChallengeDetailsState copyWith({
    Challenge? challenge,
    ChallengeDetailsStatus? status,
    List<Bet>? bets,
    Bet? userBet,
  }) {
    return ChallengeDetailsState._(
      challenge: challenge ?? this.challenge,
      status: status ?? this.status,
      bets: bets ?? this.bets,
      userBet: userBet ?? this.userBet,
    );
  }

  @override
  List<Object> get props => [
        challenge ?? status.name,
        status,
        bets,
        userBet,
      ];
}
