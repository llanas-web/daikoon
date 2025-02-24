// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';
import 'package:shared/shared.dart';

class Choice extends Equatable {
  Choice({
    String? id,
    this.value = '',
    this.isCorrect = false,
  }) : id = id ?? uuid.v4();

  final String? id;
  final String value;
  final bool isCorrect;

  @override
  List<Object?> get props => [id, value, isCorrect];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'value': value,
      'isCorrect': isCorrect,
    };
  }
}
