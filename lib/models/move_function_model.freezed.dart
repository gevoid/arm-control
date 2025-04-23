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

 String get name; set name(String value); List<List<int>> get commands; set commands(List<List<int>> value);
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
 String name, List<List<int>> commands
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
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? commands = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,commands: null == commands ? _self.commands : commands // ignore: cast_nullable_to_non_nullable
as List<List<int>>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MoveFunction implements MoveFunction {
   _MoveFunction({required this.name, required this.commands});
  factory _MoveFunction.fromJson(Map<String, dynamic> json) => _$MoveFunctionFromJson(json);

@override  String name;
@override  List<List<int>> commands;

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
 String name, List<List<int>> commands
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
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? commands = null,}) {
  return _then(_MoveFunction(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,commands: null == commands ? _self.commands : commands // ignore: cast_nullable_to_non_nullable
as List<List<int>>,
  ));
}


}

// dart format on
