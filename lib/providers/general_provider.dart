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

  double controlSlider1Value = 4.0;
  double controlSlider2Value = 3.0;

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
      (func) => func.name?.toUpperCase() == newFunctionName.toUpperCase(),
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

  Future<bool> addCommandToFunction(MoveFunction mf, Command cmd) async {
    moveFunctions
        .where((func) => func.name == mf.name)
        .first
        .commands
        ?.add(cmd);
    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return true;
  }

  updateCommandFromFunction(
    MoveFunction mf,
    int cmdIndex,
    Command newCmd,
  ) async {
    print(newCmd.typeValue);
    moveFunctions
            .where((func) => func.name == mf.name)
            .first
            .commands?[cmdIndex] =
        newCmd;

    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return true;
  }

  removeCommandFromFunction(MoveFunction mf, int cmdIndex) async {
    moveFunctions
        .where((func) => func.name == mf.name)
        .first
        .commands
        ?.removeAt(cmdIndex);
    ;
    ;
    await LocalUtils().saveMoveFunctions(moveFunctions);
    moveFunctions = await LocalUtils().getMoveFunctions();
    notifyListeners();
    return true;
  }
}

final generalProvider = ChangeNotifierProvider(
  (ref) => GeneralProviderNotifier(),
);
