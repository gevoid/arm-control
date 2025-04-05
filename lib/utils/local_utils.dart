import 'dart:convert';

import 'package:armcontrol/models/move_function_model.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class LocalUtils {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  saveMoveFunctions(List<MoveFunction> mfl) async {
    final String jsonString = jsonEncode(
      mfl.map((user) => user.toJson()).toList(),
    ); // Listeyi JSON'a çevir

    await encryptedSharedPreferences
        .setString('moveFunctions', jsonString)
        .then((bool success) {
          if (success) {
            print('success');
          } else {
            print('fail');
          }
        });
  }

  Future<List<MoveFunction>> getMoveFunctions() async {
    String data = '';
    await encryptedSharedPreferences.getString('moveFunctions').then((
      String value,
    ) {
      print('++++++++++++++++okuma değeri:  ' + value);
      data = (value == '' ? '[]' : value);
    });

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => MoveFunction.fromJson(json)).toList();
  }
}
