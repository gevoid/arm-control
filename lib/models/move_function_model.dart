import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'move_function_model.freezed.dart';
part 'move_function_model.g.dart';

MoveFunction moveFunctionFromJson(String str) =>
    MoveFunction.fromJson(json.decode(str));

String moveFunctionToJson(MoveFunction data) => json.encode(data.toJson());

@unfreezed
abstract class MoveFunction with _$MoveFunction {
  factory MoveFunction({
    required String name,
    required List<List<int>> commands,
  }) = _MoveFunction;

  factory MoveFunction.fromJson(Map<String, dynamic> json) =>
      _$MoveFunctionFromJson(json);
}
