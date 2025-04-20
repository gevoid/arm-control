import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/general_provider_state_model.dart';
import '../models/move_function_model.dart';
import '../utils/api.dart';
import '../utils/local_utils.dart';

class GeneralProviderNotifier extends Notifier<GeneralState> {
  // Methods to update the state
  @override
  GeneralState build() {
    return GeneralState();
  }

  startFunctionCmdEdit(int index) {
    state = state.copyWith(
      functionCmdEditing: true,
      functionCmdEditIndex: index,
    );
  }

  saveFunctionCmdEdit(int index) {
    state = state.copyWith(
      functionCmdEditing: false,
      functionCmdEditIndex: null,
      functionCmdEditLastIndex: index,
    );
  }

  cancelFunctionCmdEdit() {
    print('state değişti');

    state = state.copyWith(
      functionCmdEditing: false,
      functionCmdEditIndex: null,
      functionCmdEditLastIndex: -1,
    );
  }

  checkConnection() async {
    bool connected = await Api().checkConnection();
    state = state.copyWith(isConnected: connected);
    return connected;
  }

  getTempValue() async {
    double temp = await Api().getTempValue() ?? 0;
    state = state.copyWith(tempValue: temp);
  }

  getDistanceValue() async {
    double distance = await Api().getDistanceValue() ?? 0;
    state = state.copyWith(distanceValue: distance);
  }

  getMoveFunctions() async {
    List<MoveFunction> functions = await LocalUtils().getMoveFunctions();
    state = state.copyWith(moveFunctions: functions);
  }

  Future<bool> addMoveFunction(String newFunctionName) async {
    if (!state.moveFunctions.any(
      (func) => func.name.toUpperCase() == newFunctionName.toUpperCase(),
    )) {
      List<MoveFunction> updatedFunctions = List.from(state.moveFunctions)
        ..add(MoveFunction(name: newFunctionName.toUpperCase(), commands: []));
      await LocalUtils().saveMoveFunctions(updatedFunctions);
      state = state.copyWith(moveFunctions: updatedFunctions);
      return true;
    }
    return false;
  }

  removeMoveFunction(MoveFunction mf) async {
    List<MoveFunction> updatedFunctions = List.from(state.moveFunctions)
      ..removeWhere((func) => func.name == mf.name);
    await LocalUtils().saveMoveFunctions(updatedFunctions);
    state = state.copyWith(moveFunctions: updatedFunctions);
  }

  functionMoveRecModeON(MoveFunction mf) {
    state = state.copyWith(moveRecMode: true, moveRecFunctionName: mf.name);
  }

  functionMoveRecModeOFF() {
    state = state.copyWith(moveRecMode: false, moveRecFunctionName: '');
  }

  Future<bool> addCommandToFunction() async {
    if (!state.moveRecMode || state.moveRecFunctionName == '') return false;
    List<int>? currentServoAngles = await Api().getCurrentServoAngles();
    if (currentServoAngles == null) return false;

    List<MoveFunction> updatedFunctions = List.from(state.moveFunctions);
    updatedFunctions
        .where((func) => func.name == state.moveRecFunctionName)
        .first
        .commands
        .add(currentServoAngles);

    await LocalUtils().saveMoveFunctions(updatedFunctions);
    state = state.copyWith(moveFunctions: updatedFunctions);
    return true;
  }

  Future<bool> editFunctionCommand(
    MoveFunction mf,
    int cmdIndex,
    List<int> newCommands,
  ) async {
    List<MoveFunction> updatedFunctions = List.from(state.moveFunctions);
    updatedFunctions
            .where((func) => func.name == mf.name)
            .first
            .commands[cmdIndex] =
        newCommands;

    await LocalUtils().saveMoveFunctions(updatedFunctions);
    state = state.copyWith(moveFunctions: updatedFunctions);
    return true;
  }

  Future<bool> removeCommandFromFunction(MoveFunction mf, int cmdIndex) async {
    List<MoveFunction> updatedFunctions = List.from(state.moveFunctions);
    updatedFunctions
        .where((func) => func.name == mf.name)
        .first
        .commands
        .removeAt(cmdIndex);

    await LocalUtils().saveMoveFunctions(updatedFunctions);
    state = state.copyWith(moveFunctions: updatedFunctions);
    return true;
  }
}

// final generalProvider = NotifierProvider<GeneralProviderNotifier, GeneralState>(
//   (ref) => GeneralProviderNotifier(),
// );

final generalProvider = NotifierProvider<GeneralProviderNotifier, GeneralState>(
  () {
    return GeneralProviderNotifier();
  },
);
// import 'package:armcontrol/utils/api.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../models/move_function_model.dart';
// import '../utils/local_utils.dart';
//
// class GeneralProviderNotifier with ChangeNotifier {
//   bool isConnected = false;
//
//   double tempValue = 0;
//   double distanceValue = 0;
//
//   bool moveRecMode = false;
//   String moveRecFunctionName = '';
//   List<MoveFunction> moveFunctions = [];
//
//   bool functionCmdEditing = false;
//   int? functionCmdEditIndex;
//
//   startFunctionCmdEdit(int index) {
//     functionCmdEditing = true;
//     functionCmdEditIndex = index;
//     notifyListeners();
//   }
//
//   saveFunctionCmdEdit(int index) {
//     functionCmdEditing = false;
//     functionCmdEditIndex = null;
//     notifyListeners();
//   }
//
//   cancelFunctionCmdEdit() {
//     functionCmdEditing = false;
//     functionCmdEditIndex = null;
//     notifyListeners();
//   }
//
//   checkConnection() async {
//     isConnected = await Api().checkConnection();
//     notifyListeners();
//   }
//
//   getTempValue() async {
//     tempValue = await Api().getTempValue() ?? 0;
//     notifyListeners();
//   }
//
//   getDistanceValue() async {
//     distanceValue = await Api().getDistanceValue() ?? 0;
//     notifyListeners();
//   }
//
//   getMoveFunctions() async {
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//   }
//
//   Future<bool> addMoveFunction(String newFunctionName) async {
//     if (!moveFunctions.any(
//       (func) => func.name.toUpperCase() == newFunctionName.toUpperCase(),
//     )) {
//       moveFunctions.add(
//         MoveFunction(name: newFunctionName.toUpperCase(), commands: []),
//       );
//     } else {
//       print('${newFunctionName} zaten listede var.');
//       return false;
//     }
//     await LocalUtils().saveMoveFunctions(moveFunctions);
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//     return true;
//   }
//
//   removeMoveFunction(MoveFunction mf) async {
//     moveFunctions.removeWhere((func) => func.name == mf.name);
//     await LocalUtils().saveMoveFunctions(moveFunctions);
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//   }
//
//   functionMoveRecModeON(MoveFunction mf) {
//     moveRecMode = true;
//     moveRecFunctionName = mf.name;
//     notifyListeners();
//   }
//
//   functionMoveRecModeOFF() {
//     moveRecMode = false;
//     moveRecFunctionName = '';
//     notifyListeners();
//   }
//
//   Future<bool> addCommandToFunction() async {
//     bool status = false;
//     if (!moveRecMode || moveRecFunctionName == '') {
//       return false;
//     }
//     List<int>? currentServoAngles = await Api().getCurrentServoAngles();
//     if (currentServoAngles == null) {
//       return false;
//     }
//     moveFunctions
//         .where((func) => func.name == moveRecFunctionName)
//         .first
//         .commands
//         .add(currentServoAngles);
//     status = await LocalUtils().saveMoveFunctions(moveFunctions);
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//     return status;
//   }
//
//   Future<bool> editFunctionCommand(
//     MoveFunction mf,
//     int cmdIndex,
//     List<int> newCommands,
//   ) async {
//     bool status = false;
//     moveFunctions
//             .where((func) => func.name == mf.name)
//             .first
//             .commands[cmdIndex] =
//         newCommands;
//
//     status = await LocalUtils().saveMoveFunctions(moveFunctions);
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//     return status;
//   }
//
//   Future<bool> removeCommandFromFunction(MoveFunction mf, int cmdIndex) async {
//     bool status = false;
//     moveFunctions
//         .where((func) => func.name == mf.name)
//         .first
//         .commands
//         .removeAt(cmdIndex);
//
//     status = await LocalUtils().saveMoveFunctions(moveFunctions);
//     moveFunctions = await LocalUtils().getMoveFunctions();
//     notifyListeners();
//     return status;
//   }
// }
//
// final generalProvider = ChangeNotifierProvider(
//   (ref) => GeneralProviderNotifier(),
// );
