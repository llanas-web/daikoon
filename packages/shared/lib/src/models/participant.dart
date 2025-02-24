// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

enum ParticipantStatus {
  accepted,
  declined,
  pending,
}

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

  final ParticipantStatus _status;

  ParticipantStatus get status => _status;

  @override
  List<Object?> get props => [id, username, email, avatarUrl, _status];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...super.toJson(),
      'status': _status.name,
    };
  }
}
