// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:armcontrol/screens/control_screen/control_screen.dart';
import 'package:armcontrol/utils/api.dart';
import 'package:armcontrol/utils/local_utils.dart';
import 'package:armcontrol/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: backgroundColor,
      statusBarColor: backgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  Api.ip = await LocalUtils().getConnectionIp();
  runApp(
    ProviderScope(
      child: GetMaterialApp(
        scaffoldMessengerKey: Snackbar.key,
        debugShowCheckedModeBanner: false,
        color: Colors.lightBlue,
        home: ControlScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white12,
              iconColor: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}
