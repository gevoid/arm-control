import 'dart:async';

import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/settings_screen.dart';
import 'package:armcontrol/utils/snackbar.dart';
import 'package:armcontrol/widgets/custom_stick.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../consts.dart';
import '../../utils/api.dart';
import '../../widgets/runing_function_dialog_widget.dart';

part 'widgets/function_buttons_widget.dart';
part 'widgets/sensor_box_widget.dart';

class ControlScreen extends ConsumerStatefulWidget {
  const ControlScreen({super.key});
  @override
  ConsumerState<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends ConsumerState<ControlScreen> {
  Duration commandSendPeriod = Duration(milliseconds: 60);
  var buttonTextStyle = TextStyle(color: Colors.white);
  bool moveRecMode = false;

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    ref.read(generalProvider.notifier).getMoveFunctions();
    checkStatus();
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    _statusTimer?.cancel();
    super.dispose();
  }

  Future checkStatus() async {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) async {
      bool connectionStatus =
          await ref.read(generalProvider.notifier).checkConnection();
      if (connectionStatus) {
        await ref.read(generalProvider.notifier).getDistanceValue();
        await ref.read(generalProvider.notifier).getTempValue();
      }
    });
  }

  Timer? _s2Timer;
  Timer? _s3Timer;
  Timer? _s4Timer;
  Timer? _holdTimer;
  Timer? _statusTimer;

  void _startHoldMove() {
    _holdTimer = Timer.periodic(commandSendPeriod, (timer) {
      Api().moveServoStepIncrease(1);
    });
  }

  void _stopHoldMove() {
    _holdTimer?.cancel();
  }

  void _startServo2Move(bool increase) {
    _s2Timer = Timer.periodic(commandSendPeriod, (timer) {
      if (increase) {
        Api().moveServoStepIncrease(2);
        print('increase');
      } else {
        print('deacrease');
        Api().moveServoStepDecrease(2);
      }
    });
  }

  void _stopServo2() {
    _s2Timer?.cancel();
  }

  void _startServo3Move(bool increase) {
    _s3Timer = Timer.periodic(commandSendPeriod, (timer) {
      if (increase) {
        Api().moveServoStepIncrease(3);
        print('increase');
      } else {
        print('deacrease');
        Api().moveServoStepDecrease(3);
      }
    });
  }

  void _stopServo3() {
    _s3Timer?.cancel();
  }

  void _startServo4Move(bool increase) {
    _s4Timer = Timer.periodic(commandSendPeriod, (timer) {
      if (increase) {
        Api().moveServoStepIncrease(4);
        print('increase');
      } else {
        print('deacrease');
        Api().moveServoStepDecrease(4);
      }
    });
  }

  void _stopServo4() {
    _s4Timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('build control');
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Stack(
          children: [
            threeDViewer(),

            _SensorDataBox(),

            Align(
              alignment: Alignment.topRight,
              child: FunctionButtonsWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // diğer kontrol widgerları
                  SizedBox(
                    height: 150,
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                servo3Control(),
                                SizedBox(width: 30),
                                servo4Control(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spacer(),
                        GestureDetector(
                          onLongPressStart: (_) {
                            _startServo2Move(true);
                          },
                          onLongPressEnd: (_) {
                            _stopServo2();
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              Api().moveServoStepIncrease(2);
                            },
                            child: Icon(Icons.rotate_left_outlined),
                          ),
                        ),
                        Spacer(),
                        holdRelease(),
                        Spacer(),
                        GestureDetector(
                          onLongPressStart: (_) {
                            _startServo2Move(false);
                          },
                          onLongPressEnd: (_) {
                            _stopServo2();
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              Api().moveServoStepDecrease(2);
                            },
                            child: Icon(Icons.rotate_right_outlined),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  joystickWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Joystick joystickWidget() {
    return Joystick(
      stick: CustomJoystickStick(),
      base: CustomJoyStickBase(),
      mode: JoystickMode.horizontalAndVertical,
      period: commandSendPeriod,
      listener: (details) async {
        double x = details.x;
        double y = details.y;

        if (details.x > 0.30) {
          Api().moveServoStepIncrease(6);
        } else if (details.x < -0.30) {
          Api().moveServoStepDecrease(6);
        }

        if (details.y > 0.30) {
          Api().moveServoStepDecrease(5);
        } else if (details.y < -0.30) {
          Api().moveServoStepIncrease(5);
        }

        // print(details.x);
        // print(details.y);
      },
    );
  }

  Column servo4Control() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPressStart: (_) {
            _startServo4Move(true);
          },
          onLongPressEnd: (_) {
            _stopServo4();
          },
          child: ElevatedButton(
            onPressed: () {
              Api().moveServoStepIncrease(4);
            },
            child: Icon(Icons.arrow_upward),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onLongPressStart: (_) {
            _startServo4Move(false);
          },
          onLongPressEnd: (_) {
            _stopServo4();
          },
          child: ElevatedButton(
            onPressed: () {
              Api().moveServoStepDecrease(4);
            },
            child: Icon(Icons.arrow_downward),
          ),
        ),
      ],
    );
  }

  Column servo3Control() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onLongPressStart: (_) {
            _startServo3Move(false);
          },
          onLongPressEnd: (_) {
            _stopServo3();
          },
          child: ElevatedButton(
            onPressed: () {
              Api().moveServoStepDecrease(3);
            },
            child: Icon(Icons.arrow_upward),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onLongPressStart: (_) {
            _startServo3Move(true);
          },
          onLongPressEnd: (_) {
            _stopServo3();
          },
          child: ElevatedButton(
            onPressed: () {
              Api().moveServoStepIncrease(3);
            },
            child: Icon(Icons.arrow_downward),
          ),
        ),
      ],
    );
  }

  holdRelease() {
    var _buttonTextStyle = TextStyle(color: Colors.white, fontSize: 13);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () async {
                Api().moveServoToAngle(1, 120);
              },
              child: Text('Bırak', style: _buttonTextStyle),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            onLongPressStart: (_) {
              _startHoldMove();
            },
            onLongPressEnd: (_) {
              _stopHoldMove();
            },
            child: SizedBox(
              width: 70,
              child: ElevatedButton(
                onPressed: () async {
                  Api().moveServoStepIncrease(1);
                },
                child: Text('Tut', style: _buttonTextStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  threeDViewer() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: const ModelViewer(
        src: 'assets/arm_assembly.glb',
        alt: 'A 3D model 6-DOF robotic arm',
        ar: false,
        arModes: ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: true,
        exposure: 0.5,
      ),
    );
  }
}
