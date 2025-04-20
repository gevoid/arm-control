import 'dart:io';

import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/utils/snackbar.dart';
import 'package:dio/dio.dart';

class Api {
  final dio = Dio();
  String ip = "192.168.1.184";
  String get basePath => 'http://$ip';

  moveServoToAngle(int servoNumber, int desiredAngle) async {
    try {
      await dio.get('$basePath/servo?number=$servoNumber&angle=$desiredAngle');
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      // if (e.response != null) {
      //   print(e.response!.data);
      //   print(e.response!.headers);
      //   print(e.response!.requestOptions);
      // } else {
      //   // Something happened in setting up or sending the request that triggered an Error
      //   print(e.requestOptions);
      //   print(e.message);
      // }
    }
  }

  moveServoStepIncrease(int servoNumber) async {
    try {
      await dio.get('$basePath/servoStep?number=$servoNumber&desired=increase');
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
    }
  }

  moveServoStepDecrease(int servoNumber) async {
    try {
      await dio.get('$basePath/servoStep?number=$servoNumber&desired=decrease');
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
    }
  }

  Future<bool> checkConnection() async {
    try {
      final socket = await Socket.connect(
        ip,
        80,
        timeout: Duration(milliseconds: 1500),
      );
      socket.destroy();
      return true; // Bağlantı başarılı
    } catch (e) {
      return false; // Bağlantı başarısız
    }
  }

  Future<double?> getTempValue() async {
    try {
      Response response = await dio.get('$basePath/temp');
      return double.parse(response.data.toString());
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }

  Future<double?> getDistanceValue() async {
    try {
      Response response = await dio.get('$basePath/distance');
      return double.parse(response.data.toString());
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }

  Future<List<int>?> getCurrentServoAngles() async {
    try {
      Response response = await dio.get('$basePath/getCurrentServoAngles');
      return response.data
          .toString()
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }

  Future<bool> runMoveFunction(MoveFunction mf) async {
    print(mf.toJson());
    try {
      Response response = await dio.post(
        '$basePath/runMoveFunction',
        data: mf.toJson(),
      );

      if (response.data == 'Hareket başladı.') {
        return true;
      }
      return false;
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return false;
    }
  }

  Future<bool> stopMoveFunction() async {
    try {
      Response response = await dio.get('$basePath/stop');
      if (response.data == 'OK') {
        return true;
      }
      return false;
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return false;
    }
  }

  Future<bool?> checkMoveFunctionStatus() async {
    try {
      Response response = await dio.get('$basePath/moveFunctionStatus');
      if (response.data == 'RUNNING') {
        return false; // işlem devam ediyor demek
      } else if (response.data == 'DONE') {
        return true;
      }

      return null;
    } on DioException catch (e) {
      Snackbar.show(prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }
}
