import 'dart:io';

import 'package:armcontrol/utils/snackbar.dart';
import 'package:dio/dio.dart';

class Api {
  final dio = Dio();
  String basePath = 'http://192.168.21.246';

  moveServoToAngle(int servoNumber, int desiredAngle) async {
    try {
      await dio.get('$basePath/servo?number=$servoNumber&angle=$desiredAngle');
    } on DioException catch (e) {
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
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
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
    }
  }

  moveServoStepDecrease(int servoNumber) async {
    try {
      await dio.get('$basePath/servoStep?number=$servoNumber&desired=decrease');
    } on DioException catch (e) {
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
    }
  }

  sendControl(int controlNumber, double value) async {
    try {
      await dio.get(
        '$basePath/control?number=$controlNumber&value=${value.toStringAsFixed(3)}',
      );
    } on DioException catch (e) {
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
    }
  }

  Future<bool> checkConnection() async {
    try {
      final socket = await Socket.connect(
        '192.168.21.246',
        80,
        timeout: Duration(milliseconds: 1500),
      );
      socket.destroy();
      return true; // Bağlantı başarılı
    } catch (e) {
      return false; // Bağlantı başarısız
    }
  }

  // Future<bool> checkConnection() async {
  //   try {
  //     await dio.get(
  //       '$basePath/status',
  //       options: Options(
  //         sendTimeout: Duration(
  //           milliseconds: 100,
  //         ), // Sunucuya bağlanma süresi sınırı
  //         receiveTimeout: Duration(
  //           milliseconds: 100,
  //         ), // Yanıt alma süresi sınırı
  //       ),
  //     );
  //     return true;
  //   } on DioException catch (e) {
  //     Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
  //     return false;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<double?> getTempValue() async {
    try {
      Response response = await dio.get('$basePath/temp');
      return double.parse(response.data.toString());
    } on DioException catch (e) {
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }

  Future<double?> getDistanceValue() async {
    try {
      Response response = await dio.get('$basePath/distance');
      return double.parse(response.data.toString());
    } on DioException catch (e) {
      Snackbar.show(ABC.c, prettyException("Hata Oluştu:", e), success: false);
      return null;
    }
  }
}
