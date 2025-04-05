import 'dart:async';

import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/settings_screen.dart';
import 'package:armcontrol/widgets/custom_stick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../utils/api.dart';

class ControlScreen extends ConsumerStatefulWidget {
  const ControlScreen({super.key});
  @override
  ConsumerState<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends ConsumerState<ControlScreen> {
  Duration commandSendPeriod = Duration(milliseconds: 60);
  var buttonTextStyle = TextStyle(color: Colors.white);
  bool _isInversed = false;

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    ref.read(generalProvider).getMoveFunctions();
    checkStatus();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _statusTimer?.cancel();
    super.dispose();
  }

  Future checkStatus() async {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) async {
      await ref.read(generalProvider).checkConnection();
      await ref.read(generalProvider).getDistanceValue();
      await ref.read(generalProvider).getTempValue();
    });
  }

  Timer? _s2Timer;
  Timer? _s3Timer;
  Timer? _s4Timer;
  Timer? _statusTimer;

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
    var providerW = ref.watch(generalProvider);
    var providerR = ref.read(generalProvider);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF292929), // Status bar arka plan rengi
        statusBarIconBrightness:
            Brightness.light, // Açık (light) veya koyu (dark) ikonlar
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF292929),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Stack(
            children: [
              threeDViewer(),
              sensorDataBox(),

              Align(alignment: Alignment.topRight, child: functionButtons()),
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

        if (details.x > 0.70) {
          Api().moveServoStepIncrease(6);
        } else if (details.x < -0.70) {
          Api().moveServoStepDecrease(6);
        }

        if (details.y > 0.70) {
          Api().moveServoStepIncrease(5);
        } else if (details.y < -0.70) {
          Api().moveServoStepDecrease(5);
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
    return ElevatedButton(
      onPressed: () async {
        if (ref.watch(generalProvider).holding) {
          await Api().moveServoToAngle(1, 120);
          ref.read(generalProvider).changeHolding(false);
        } else {
          await Api().moveServoToAngle(1, 180);
          ref.read(generalProvider).changeHolding(true);
        }
      },
      child: Text(
        !ref.watch(generalProvider).holding ? 'Tut' : 'Bırak',
        style: buttonTextStyle,
      ),
    );
  }

  Text connectionStatusText() {
    bool isConnected = ref.watch(generalProvider).isConnected;
    return Text(
      isConnected ? '◉ Wİ-Fİ Bağlı' : '◉ Wİ-Fİ Bağlı Değil',
      style: TextStyle(
        color: isConnected ? Colors.green : Colors.red,
        fontSize: 12,
      ),
    );
  }

  sensorDataBox() {
    var providerW = ref.watch(generalProvider);
    double tempValue = providerW.tempValue;
    double distanceValue = providerW.distanceValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                border:
                    tempValue > 25
                        ? tempValue < 50
                            ? Border.all(color: Colors.amber, width: 2)
                            : Border.all(color: Colors.red, width: 2)
                        : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text(
                          'Sıcaklık',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 3),
                        AnimatedRadialGauge(
                          /// The animation duration.
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,

                          /// Define the radius.
                          /// If you omit this value, the parent size will be used, if possible.
                          radius: 60,

                          builder: (context, child, value) {
                            return Center(
                              child: Text(
                                '$tempValue°',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          },

                          /// Gauge value.
                          value: tempValue,

                          /// Optionally, you can configure your gauge, providing additional
                          /// styles and transformers.
                          axis: GaugeAxis(
                            /// Provide the [min] and [max] value for the [value] argument.
                            min: 0,
                            max: 100,

                            /// Render the gauge as a 180-degree arc.
                            degrees: 180,

                            /// Set the background color and axis thickness.
                            style: const GaugeAxisStyle(
                              thickness: 10,
                              background: Colors.transparent,
                              segmentSpacing: 4,
                            ),

                            /// Define the pointer that will indicate the progress (optional).
                            pointer: GaugePointer.needle(
                              position: GaugePointerPosition.surface(
                                offset: Offset(1, 12),
                              ),
                              borderRadius: 16,
                              width: 15,
                              height: 20,
                              border: GaugePointerBorder(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              color: Colors.black,
                            ),

                            /// Define axis segments (optional).
                            segments: [
                              const GaugeSegment(
                                from: 0,
                                to: 25,
                                color: Colors.green,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 25,
                                to: 50,
                                color: Colors.amber,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 50,
                                to: 100,
                                color: Colors.red,
                                cornerRadius: Radius.zero,
                              ),
                            ],

                            progressBar: null,
                          ),
                        ),

                        //  Text('$tempValue°', style: TextStyle(color: Colors.green)),
                        // SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                border:
                    distanceValue < 12
                        ? distanceValue > 8
                            ? Border.all(color: Colors.amber, width: 2)
                            : Border.all(color: Colors.red, width: 2)
                        : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      children: [
                        Text(
                          'Uzaklık',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 3),
                        AnimatedRadialGauge(
                          /// The animation duration.
                          duration: const Duration(seconds: 1),
                          curve: Curves.linear,

                          /// Define the radius.
                          /// If you omit this value, the parent size will be used, if possible.
                          radius: 60,

                          builder: (context, child, value) {
                            return Center(
                              child: Text(
                                '${distanceValue}cm',
                                style: TextStyle(color: Colors.white70),
                              ),
                            );
                          },

                          /// Gauge value.
                          value: distanceValue,

                          /// Optionally, you can configure your gauge, providing additional
                          /// styles and transformers.
                          axis: GaugeAxis(
                            /// Provide the [min] and [max] value for the [value] argument.
                            min: 0,
                            max: 100,

                            /// Render the gauge as a 180-degree arc.
                            degrees: 180,

                            /// Set the background color and axis thickness.
                            style: const GaugeAxisStyle(
                              thickness: 10,
                              background: Colors.transparent,
                              segmentSpacing: 4,
                            ),

                            /// Define the pointer that will indicate the progress (optional).
                            pointer: GaugePointer.needle(
                              position: GaugePointerPosition.surface(
                                offset: Offset(1, 12),
                              ),
                              borderRadius: 16,
                              width: 15,
                              height: 20,
                              border: GaugePointerBorder(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              color: Colors.black,
                            ),

                            /// Define axis segments (optional).
                            segments: [
                              const GaugeSegment(
                                from: 0,
                                to: 8,
                                color: Colors.red,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 8,
                                to: 12,
                                color: Colors.amber,
                                cornerRadius: Radius.zero,
                              ),
                              const GaugeSegment(
                                from: 12,
                                to: 100,
                                color: Colors.green,
                                cornerRadius: Radius.zero,
                              ),
                            ],

                            progressBar: null,
                          ),
                        ),

                        //  Text('$tempValue°', style: TextStyle(color: Colors.green)),
                        // SizedBox(height: 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        connectionStatusText(),
      ],
    );
  }

  ModelViewer threeDViewer() {
    return const ModelViewer(
      src: 'assets/arm_assembly.glb',
      alt: 'A 3D model of an astronaut',
      arModes: ['scene-viewer', 'webxr', 'quick-look'],
      autoRotate: true,
    );
  }

  functionButtons() {
    List<Widget> fucntionsButtonsWidgetList = [];
    List<MoveFunction> mfl = ref.watch(generalProvider).moveFunctions ?? [];
    for (int i = 0; i < mfl.length; i++) {
      fucntionsButtonsWidgetList.add(
        ElevatedButton(
          onPressed: () {},
          child: Text(mfl[i].name ?? '', style: buttonTextStyle),
        ),
      );
    }
    fucntionsButtonsWidgetList.add(
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
        child: Icon(Icons.settings),
      ),
    );
    return Row(
      children: [
        Spacer(flex: 2),
        Expanded(
          flex: 3,
          child: Wrap(
            alignment: WrapAlignment.end,
            runSpacing: 10,
            spacing: 10,
            children: fucntionsButtonsWidgetList,
          ),
        ),
      ],
    );
  }
}
