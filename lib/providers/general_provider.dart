import 'package:armcontrol/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/move_function_model.dart';
import '../utils/local_utils.dart';

class GeneralProviderNotifier with ChangeNotifier {
  bool isConnected = false;

  double tempValue = 0;
  double distanceValue = 0;

  bool moveRecMode = false;
  String moveRecFunctionName = '';
  List<MoveFunction> moveFunctions = [];

  bool functionCmdEditing = false;
  int? functionCmdEditIndex;
  int? functionCmdLastEditIndex;

  startFunctionCmdEdit(int index) {
    functionCmdEditing = true;
    functionCmdEditIndex = index;
    notifyListeners();
  }

  saveFunctionCmdEdit(int index) {
    functionCmdEditing = false;
    functionCmdEditIndex = null;
    functionCmdLastEditIndex = index;
    notifyListeners();
  }

  cancelFunctionCmdEdit() {
    functionCmdEditing = false;
    functionCmdEditIndex = null;
    functionCmdLastEditIndex = -1;
    notifyListeners();
  }

  checkConnection() async {
    isConnected = await Api().checkConnection();
    notifyListeners();
    return isConnected;
  }

  getTempValue() async {
    tempValue = await Api().getTempValue() ?? 0;
    notifyListeners();
  }

  getDistanceValue() async {
    distanceValue = await Api().getDistanceValue() ?? 0;
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
      return false;
    }
    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return true;
  }

  removeMoveFunction(MoveFunction mf) async {
    moveFunctions.removeWhere((func) => func.name == mf.name);
    if (moveRecMode && mf.name == moveRecFunctionName) {
      moveRecMode = false;
      moveRecFunctionName = '';
    }
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
