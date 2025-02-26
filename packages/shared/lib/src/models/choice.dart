// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

class Choice extends Equatable {
  Choice({
    String? id,
    DateTime? createdAt,
    this.value = '',
    this.isCorrect = false,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? Jiffy.now().dateTime;

  final String? id;
  final DateTime? createdAt;
  final String value;
  final bool isCorrect;

  @override
  List<Object?> get props => [id, createdAt, value, isCorrect];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'value': value,
      'isCorrect': isCorrect,
    };
  }
}
