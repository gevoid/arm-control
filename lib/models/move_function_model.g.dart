// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_function_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoveFunction _$MoveFunctionFromJson(
  Map<String, dynamic> json,
) => _MoveFunction(
  name: json['name'] as String,
  commands:
      (json['commands'] as List<dynamic>)
          .map(
            (e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList(),
          )
          .toList(),
);

Map<String, dynamic> _$MoveFunctionToJson(_MoveFunction instance) =>
    <String, dynamic>{'name': instance.name, 'commands': instance.commands};
