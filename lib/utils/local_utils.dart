import 'dart:convert';

import 'package:armcontrol/models/move_function_model.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class LocalUtils {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  Future<bool> saveMoveFunctions(List<MoveFunction> mfl) async {
    final String jsonString = jsonEncode(
      mfl.map((user) => user.toJson()).toList(),
    );

    return await encryptedSharedPreferences.setString(
      'moveFunctions',
      jsonString,
    );
  }

  Future<List<MoveFunction>> getMoveFunctions() async {
    String data = '';
    await encryptedSharedPreferences.getString('moveFunctions').then((
      String value,
    ) {
      data = (value == '' ? '[]' : value);
    });

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => MoveFunction.fromJson(json)).toList();
  }

  Future<bool> saveConnectionIp(String ip) async {
    return await encryptedSharedPreferences.setString('connectionIp', ip);
  }

  Future<String> getConnectionIp() async {
    return await encryptedSharedPreferences.getString('connectionIp');
  }
}
