// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_function_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MoveFunction _$MoveFunctionFromJson(Map<String, dynamic> json) =>
    _MoveFunction(
      name: json['name'] as String?,
      commands:
          (json['commands'] as List<dynamic>?)
              ?.map((e) => Command.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$MoveFunctionToJson(_MoveFunction instance) =>
    <String, dynamic>{'name': instance.name, 'commands': instance.commands};

_Command _$CommandFromJson(Map<String, dynamic> json) => _Command(
  type: json['type'] as String?,
  typeValue: json['typeValue'] as String?,
  servoNumber: (json['servoNumber'] as num?)?.toInt(),
  targetAngle: (json['targetAngle'] as num?)?.toInt(),
);

Map<String, dynamic> _$CommandToJson(_Command instance) => <String, dynamic>{
  'type': instance.type,
  'typeValue': instance.typeValue,
  'servoNumber': instance.servoNumber,
  'targetAngle': instance.targetAngle,
};
