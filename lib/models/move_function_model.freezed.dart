// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'move_function_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MoveFunction {

 String? get name; set name(String? value); List<Command>? get commands; set commands(List<Command>? value);
/// Create a copy of MoveFunction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoveFunctionCopyWith<MoveFunction> get copyWith => _$MoveFunctionCopyWithImpl<MoveFunction>(this as MoveFunction, _$identity);

  /// Serializes this MoveFunction to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'MoveFunction(name: $name, commands: $commands)';
}


}

/// @nodoc
abstract mixin class $MoveFunctionCopyWith<$Res>  {
  factory $MoveFunctionCopyWith(MoveFunction value, $Res Function(MoveFunction) _then) = _$MoveFunctionCopyWithImpl;
@useResult
$Res call({
 String? name, List<Command>? commands
});




}
/// @nodoc
class _$MoveFunctionCopyWithImpl<$Res>
    implements $MoveFunctionCopyWith<$Res> {
  _$MoveFunctionCopyWithImpl(this._self, this._then);

  final MoveFunction _self;
  final $Res Function(MoveFunction) _then;

/// Create a copy of MoveFunction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? commands = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,commands: freezed == commands ? _self.commands : commands // ignore: cast_nullable_to_non_nullable
as List<Command>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MoveFunction implements MoveFunction {
   _MoveFunction({this.name, this.commands});
  factory _MoveFunction.fromJson(Map<String, dynamic> json) => _$MoveFunctionFromJson(json);

@override  String? name;
@override  List<Command>? commands;

/// Create a copy of MoveFunction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoveFunctionCopyWith<_MoveFunction> get copyWith => __$MoveFunctionCopyWithImpl<_MoveFunction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoveFunctionToJson(this, );
}



@override
String toString() {
  return 'MoveFunction(name: $name, commands: $commands)';
}


}

/// @nodoc
abstract mixin class _$MoveFunctionCopyWith<$Res> implements $MoveFunctionCopyWith<$Res> {
  factory _$MoveFunctionCopyWith(_MoveFunction value, $Res Function(_MoveFunction) _then) = __$MoveFunctionCopyWithImpl;
@override @useResult
$Res call({
 String? name, List<Command>? commands
});




}
/// @nodoc
class __$MoveFunctionCopyWithImpl<$Res>
    implements _$MoveFunctionCopyWith<$Res> {
  __$MoveFunctionCopyWithImpl(this._self, this._then);

  final _MoveFunction _self;
  final $Res Function(_MoveFunction) _then;

/// Create a copy of MoveFunction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? commands = freezed,}) {
  return _then(_MoveFunction(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,commands: freezed == commands ? _self.commands : commands // ignore: cast_nullable_to_non_nullable
as List<Command>?,
  ));
}


}


/// @nodoc
mixin _$Command {

 String? get type; String? get typeValue; int? get servoNumber; int? get targetAngle;
/// Create a copy of Command
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommandCopyWith<Command> get copyWith => _$CommandCopyWithImpl<Command>(this as Command, _$identity);

  /// Serializes this Command to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Command&&(identical(other.type, type) || other.type == type)&&(identical(other.typeValue, typeValue) || other.typeValue == typeValue)&&(identical(other.servoNumber, servoNumber) || other.servoNumber == servoNumber)&&(identical(other.targetAngle, targetAngle) || other.targetAngle == targetAngle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,typeValue,servoNumber,targetAngle);

@override
String toString() {
  return 'Command(type: $type, typeValue: $typeValue, servoNumber: $servoNumber, targetAngle: $targetAngle)';
}


}

/// @nodoc
abstract mixin class $CommandCopyWith<$Res>  {
  factory $CommandCopyWith(Command value, $Res Function(Command) _then) = _$CommandCopyWithImpl;
@useResult
$Res call({
 String? type, String? typeValue, int? servoNumber, int? targetAngle
});




}
/// @nodoc
class _$CommandCopyWithImpl<$Res>
    implements $CommandCopyWith<$Res> {
  _$CommandCopyWithImpl(this._self, this._then);

  final Command _self;
  final $Res Function(Command) _then;

/// Create a copy of Command
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = freezed,Object? typeValue = freezed,Object? servoNumber = freezed,Object? targetAngle = freezed,}) {
  return _then(_self.copyWith(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,typeValue: freezed == typeValue ? _self.typeValue : typeValue // ignore: cast_nullable_to_non_nullable
as String?,servoNumber: freezed == servoNumber ? _self.servoNumber : servoNumber // ignore: cast_nullable_to_non_nullable
as int?,targetAngle: freezed == targetAngle ? _self.targetAngle : targetAngle // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Command implements Command {
  const _Command({this.type, this.typeValue, this.servoNumber, this.targetAngle});
  factory _Command.fromJson(Map<String, dynamic> json) => _$CommandFromJson(json);

@override final  String? type;
@override final  String? typeValue;
@override final  int? servoNumber;
@override final  int? targetAngle;

/// Create a copy of Command
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommandCopyWith<_Command> get copyWith => __$CommandCopyWithImpl<_Command>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Command&&(identical(other.type, type) || other.type == type)&&(identical(other.typeValue, typeValue) || other.typeValue == typeValue)&&(identical(other.servoNumber, servoNumber) || other.servoNumber == servoNumber)&&(identical(other.targetAngle, targetAngle) || other.targetAngle == targetAngle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,typeValue,servoNumber,targetAngle);

@override
String toString() {
  return 'Command(type: $type, typeValue: $typeValue, servoNumber: $servoNumber, targetAngle: $targetAngle)';
}


}

/// @nodoc
abstract mixin class _$CommandCopyWith<$Res> implements $CommandCopyWith<$Res> {
  factory _$CommandCopyWith(_Command value, $Res Function(_Command) _then) = __$CommandCopyWithImpl;
@override @useResult
$Res call({
 String? type, String? typeValue, int? servoNumber, int? targetAngle
});




}
/// @nodoc
class __$CommandCopyWithImpl<$Res>
    implements _$CommandCopyWith<$Res> {
  __$CommandCopyWithImpl(this._self, this._then);

  final _Command _self;
  final $Res Function(_Command) _then;

/// Create a copy of Command
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = freezed,Object? typeValue = freezed,Object? servoNumber = freezed,Object? targetAngle = freezed,}) {
  return _then(_Command(
type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,typeValue: freezed == typeValue ? _self.typeValue : typeValue // ignore: cast_nullable_to_non_nullable
as String?,servoNumber: freezed == servoNumber ? _self.servoNumber : servoNumber // ignore: cast_nullable_to_non_nullable
as int?,targetAngle: freezed == targetAngle ? _self.targetAngle : targetAngle // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
