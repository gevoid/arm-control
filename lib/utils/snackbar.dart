import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Snackbar {
  static final GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();

  static show(String msg, {required bool success}) {
    final snackBar =
        success
            ? SnackBar(
              action: SnackBarAction(
                label: 'Tamam',
                textColor: Colors.white,
                onPressed: () {
                  key.currentState?.removeCurrentSnackBar();
                },
              ),
              content: Text(msg),
              backgroundColor: Colors.blue.shade800,
            )
            : SnackBar(
              action: SnackBarAction(
                label: 'Tamam',
                textColor: Colors.white,
                onPressed: () {
                  key.currentState?.removeCurrentSnackBar();
                },
              ),
              content: Text(msg),
              backgroundColor: Colors.red,
            );
    key.currentState?.removeCurrentSnackBar();
    key.currentState?.showSnackBar(snackBar);
  }
}

String prettyException(String prefix, DioException e) {
  return "$prefix ${e.message}";
}
