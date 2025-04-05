import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'move_function_model.freezed.dart';
part 'move_function_model.g.dart';

MoveFunction moveFunctionFromJson(String str) =>
    MoveFunction.fromJson(json.decode(str));

String moveFunctionToJson(MoveFunction data) => json.encode(data.toJson());

@unfreezed
abstract class MoveFunction with _$MoveFunction {
  factory MoveFunction({String? name, List<Command>? commands}) = _MoveFunction;

  factory MoveFunction.fromJson(Map<String, dynamic> json) =>
      _$MoveFunctionFromJson(json);
}

@freezed
abstract class Command with _$Command {
  const factory Command({
    String? type,
    String? typeValue,
    int? servoNumber,
    int? targetAngle,
  }) = _Command;

  factory Command.fromJson(Map<String, dynamic> json) =>
      _$CommandFromJson(json);
}
