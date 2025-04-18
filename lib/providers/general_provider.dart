import 'package:armcontrol/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/move_function_model.dart';
import '../utils/local_utils.dart';

class GeneralProviderNotifier with ChangeNotifier {
  bool isConnected = false;
  bool holding = false;

  double tempValue = 0;
  double distanceValue = 0;

  bool moveRecMode = false;
  String moveRecFunctionName = '';
  List<MoveFunction> moveFunctions = [];

  checkConnection() async {
    isConnected = await Api().checkConnection();
    notifyListeners();
  }

  getTempValue() async {
    tempValue = await Api().getTempValue() ?? 0;
    notifyListeners();
  }

  getDistanceValue() async {
    distanceValue = await Api().getDistanceValue() ?? 0;
    notifyListeners();
  }

  changeHolding(bool newValue) {
    holding = newValue;
    notifyListeners();
  }

  getMoveFunctions() async {
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
  }

  Future<bool> addMoveFunction(String newFunctionName) async {
    if (!moveFunctions.any(
      (func) => func.name.toUpperCase() == newFunctionName.toUpperCase(),
    )) {
      moveFunctions.add(
        MoveFunction(name: newFunctionName.toUpperCase(), commands: []),
      );
    } else {
      print('${newFunctionName} zaten listede var.');
      return false;
    }
    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return true;
  }

  removeMoveFunction(MoveFunction mf) async {
    moveFunctions.removeWhere((func) => func.name == mf.name);
    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
  }

  functionMoveRecModeON(MoveFunction mf) {
    moveRecMode = true;
    moveRecFunctionName = mf.name;
    notifyListeners();
  }

  functionMoveRecModeOFF() {
    moveRecMode = false;
    moveRecFunctionName = '';
    notifyListeners();
  }

  Future<bool> addCommandToFunction() async {
    bool status = false;
    if (!moveRecMode || moveRecFunctionName == '') {
      return false;
    }
    List<int>? currentServoAngles = await Api().getCurrentServoAngles();
    if (currentServoAngles == null) {
      return false;
    }
    moveFunctions
        .where((func) => func.name == moveRecFunctionName)
        .first
        .commands
        .add(currentServoAngles);
    status = await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return status;
  }

  Future<bool> editFunctionCommand(
    MoveFunction mf,
    int cmdIndex,
    List<int> newCommands,
  ) async {
    bool status = false;
    moveFunctions
            .where((func) => func.name == mf.name)
            .first
            .commands[cmdIndex] =
        newCommands;

    status = await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return status;
  }

  // updateCommandFromFunction(
  //   MoveFunction mf,
  //   int cmdIndex,
  //   Command newCmd,
  // ) async {
  //   print(newCmd.typeValue);
  //   moveFunctions
  //           .where((func) => func.name == mf.name)
  //           .first
  //           .commands?[cmdIndex] =
  //       newCmd;
  //
  //   await LocalUtils().saveMoveFunctions(moveFunctions);
  //   moveFunctions = await LocalUtils().getMoveFunctions();
  //   notifyListeners();
  //   return true;
  // }

  Future<bool> removeCommandFromFunction(MoveFunction mf, int cmdIndex) async {
    bool status = false;
    moveFunctions
        .where((func) => func.name == mf.name)
        .first
        .commands
        .removeAt(cmdIndex);

    status = await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return status;
  }
}

final generalProvider = ChangeNotifierProvider(
  (ref) => GeneralProviderNotifier(),
);
