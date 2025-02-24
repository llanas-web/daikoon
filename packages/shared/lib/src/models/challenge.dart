import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';
import 'package:user_repository/user_repository.dart';

/// {@template message}
/// The representation of the challenge.
/// {@endtemplate}
class Challenge extends Equatable {
  /// {@macro message}
  Challenge({
    String? id,
    DateTime? createdAt,
    this.title = '',
    this.question = '',
    this.starting,
    this.limitDate,
    this.ending,
    this.minBet,
    this.maxBet,
    this.hasBet = false,
    this.creator,
    this.choices = const [],
    this.participants = const [],
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  /// The challenge's generated uuid.
  final String id;

  /// The challenge's creation date.
  final DateTime createdAt;

  /// The challenge's title.
  final String? title;

  /// The challenge's question.
  final String? question;

  /// The challenge's starting date.
  final DateTime? starting;

  /// The challenge's limit date.
  final DateTime? ending;

  /// The challenge's ending date.
  final DateTime? limitDate;

  /// The challenge's minimum bet.
  final int? minBet;

  /// The challenge's maximum bet.
  final int? maxBet;

  /// The challenge's bet status.
  final bool hasBet;

  /// The challenge's creator.
  final User? creator;

  /// The challenge's options.
  final List<Choice> choices;

  /// The challenge's participants.
  final List<Participant> participants;

  @override
  List<Object?> get props => [
        id,
        createdAt,
        title,
        question,
        starting,
        limitDate,
        ending,
        minBet,
        maxBet,
        hasBet,
        creator,
        choices,
        participants,
      ];

  /// An empty challenge.
  static Challenge empty = Challenge();

  /// Creates a challenge from a json object.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'question': question,
      'starting': starting!.microsecondsSinceEpoch,
      'limitDate': limitDate!.microsecondsSinceEpoch,
      'ending': ending!.microsecondsSinceEpoch,
      'minBet': minBet,
      'maxBet': maxBet,
      'hasBet': hasBet,
      'creator': creator!.toJson(),
      'choices': choices.map((choice) => choice.toJson()).toList(),
      'participants':
          participants.map((participant) => participant.toJson()).toList(),
    };
  }
}
