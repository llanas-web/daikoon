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
          (element) => element.toString() == json['status'],
          orElse: () => ParticipantStatus.pending,
        ),
      );

  final ParticipantStatus _status;

  ParticipantStatus get status => _status;

  @override
  List<Object?> get props => [id, username, email, avatarUrl, _status];

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'avatarUrl': avatarUrl,
        'status': status.toString(),
      };
}
