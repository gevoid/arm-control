// Durum Modeli (State)
import 'move_function_model.dart';

class GeneralState {
  bool isConnected;
  double tempValue;
  double distanceValue;
  bool moveRecMode;
  String moveRecFunctionName;
  List<MoveFunction> moveFunctions;
  bool functionCmdEditing;
  int? functionCmdEditIndex;
  int? functionCmdEditLastIndex;
  GeneralState({
    this.isConnected = false,
    this.tempValue = 0,
    this.distanceValue = 0,
    this.moveRecMode = false,
    this.moveRecFunctionName = '',
    this.moveFunctions = const [],
    this.functionCmdEditing = false,
    this.functionCmdEditIndex,
    this.functionCmdEditLastIndex,
  });

  GeneralState copyWith({
    bool? isConnected,
    double? tempValue,
    double? distanceValue,
    bool? moveRecMode,
    String? moveRecFunctionName,
    List<MoveFunction>? moveFunctions,
    bool? functionCmdEditing,
    int? functionCmdEditIndex,
    int? functionCmdEditLastIndex,
  }) {
    return GeneralState(
      isConnected: isConnected ?? this.isConnected,
      tempValue: tempValue ?? this.tempValue,
      distanceValue: distanceValue ?? this.distanceValue,
      moveRecMode: moveRecMode ?? this.moveRecMode,
      moveRecFunctionName: moveRecFunctionName ?? this.moveRecFunctionName,
      moveFunctions: moveFunctions ?? this.moveFunctions,
      functionCmdEditing: functionCmdEditing ?? this.functionCmdEditing,
      functionCmdEditIndex: functionCmdEditIndex ?? this.functionCmdEditIndex,
      functionCmdEditLastIndex:
          functionCmdEditLastIndex ?? this.functionCmdEditLastIndex,
    );
  }
}
