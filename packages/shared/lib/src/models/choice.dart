// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:shared/shared.dart';

part 'choice.g.dart';

class ListChoicesConverter extends JsonConverter<List<Choice>, String> {
  const ListChoicesConverter();

  @override
  List<Choice> fromJson(String json) => List<Choice>.from(
        (jsonDecode(json) as List<dynamic>)
            .map((dynamic e) => Choice.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  String toJson(List<Choice> object) =>
      jsonEncode(object.map((Choice e) => e.toJson()).toList());
}

@immutable
@JsonSerializable()
class Choice extends Equatable {
  Choice({
    String? id,
    DateTime? createdAt,
    this.value = '',
    this.isCorrect = false,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

  final String? id;
  final DateTime? createdAt;
  final String value;
  final bool isCorrect;

  @override
  List<Object?> get props => [id, createdAt, value, isCorrect];

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
