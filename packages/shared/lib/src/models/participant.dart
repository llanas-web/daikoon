// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

enum ParticipantStatus {
  accepted,
  declined,
  pending,
}

class ListParticipantConverter
    extends JsonConverter<List<Participant>, String> {
  const ListParticipantConverter();

  @override
  List<Participant> fromJson(String json) => List<Participant>.from(
        (jsonDecode(json) as List<dynamic>)
            .map((dynamic e) => Participant.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  String toJson(List<Participant> object) =>
      jsonEncode(object.map((Participant e) => e.toJson()).toList());
}

@immutable
class Participant extends User implements Equatable {
  Participant({
    required User user,
    this.challengeId,
    ParticipantStatus? status,
  })  : _status = status ?? ParticipantStatus.pending,
        super(
          id: user.id,
          username: user.username,
          email: user.email,
          avatarUrl: user.avatarUrl,
        );

  @override
  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        user: User.fromJson(json),
        status: ParticipantStatus.values.firstWhere(
          (element) => element.name == json['status'],
          orElse: () => ParticipantStatus.pending,
        ),
        challengeId: json['challenge_id'] as String?,
      );

  final ParticipantStatus _status;
  final String? challengeId;

  ParticipantStatus get status => _status;

  /// Anonymous user which represents an unauthenticated user.
  static Participant anonymousParticipant = Participant(user: User.anonymous);

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatarUrl,
        _status,
        challengeId,
      ];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'status': status.toString(),
        'challenge_id': challengeId,
      };

  Participant copyWith({required ParticipantStatus status}) {
    return Participant(
      user: this,
      status: status,
      challengeId: challengeId,
    );
  }
}
