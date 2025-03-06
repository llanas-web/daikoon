part of 'challenge_details_cubit.dart';

enum ChallengeDetailsStatus { loading, loaded, failed }

class ChallengeDetailsState extends Equatable {
  const ChallengeDetailsState._(
      {required this.challenge, required this.status});

  const ChallengeDetailsState.initial()
      : this._(challenge: null, status: ChallengeDetailsStatus.loading);

  final Challenge? challenge;
  final ChallengeDetailsStatus status;

  ChallengeDetailsState copyWith({
    Challenge? challenge,
    ChallengeDetailsStatus? status,
  }) {
    return ChallengeDetailsState._(
      challenge: challenge ?? this.challenge,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        challenge ?? status.name,
        status,
      ];
}
