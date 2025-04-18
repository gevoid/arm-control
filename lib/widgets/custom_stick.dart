import 'package:armcontrol/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class CustomJoystickStick extends StatelessWidget {
  final double size;
  final JoystickStickDecoration? decoration;

  const CustomJoystickStick({this.size = 50, this.decoration, super.key});

  @override
  Widget build(BuildContext context) {
    final decoration = this.decoration ?? JoystickStickDecoration();
    return Container(
      width: size,
      height: size,
      child: Opacity(opacity: 0.9, child: Image.asset('assets/bseu_logo.png')),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: decoration.shadowColor,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorUtils.darken(decoration.color),
            ColorUtils.lighten(decoration.color),
          ],
        ),
      ),
    );
  }
}

@immutable
class JoystickStickDecoration {
  final Color color;
  final Color shadowColor;

  const JoystickStickDecoration._internal({
    required this.color,
    required this.shadowColor,
  });

  factory JoystickStickDecoration({
    Color color = ColorUtils.defaultStickColor,
    Color? shadowColor,
  }) {
    return JoystickStickDecoration._internal(
      color: color,
      shadowColor: shadowColor ?? color.withOpacity(0.5),
    );
  }
}

class ColorUtils {
  static const Color defaultBaseColor = Colors.white12;
  static const Color defaultArrowsColor = Colors.white12;
  static const Color defaultStickColor = Colors.white10;

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }
}

class CustomJoyStickBase extends StatelessWidget {
  CustomJoyStickBase({super.key});
  var buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        JoystickBase(
          decoration: JoystickBaseDecoration(
            innerCircleColor: Colors.white10,

            color: Colors.white10,
            drawOuterCircle: false,
            boxShadows: [],
          ),
          arrowsDecoration: JoystickArrowsDecoration(color: Colors.black54),
        ),
        //ileri
        Positioned(
          width: 40,
          top: 13,
          left: 80,
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => Api().moveServoStepDecrease(5),
            child: Text(''),
          ),
        ),
        //geri
        Positioned(
          width: 40,
          bottom: 13,
          left: 80,
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => Api().moveServoStepIncrease(5),
            child: Text(''),
          ),
        ),
        //sol
        Positioned(
          width: 40,
          top: 75,
          left: 18,
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => Api().moveServoStepDecrease(6),
            child: Text(''),
          ),
        ),
        //sağ
        Positioned(
          width: 40,
          top: 75,
          right: 18,
          child: ElevatedButton(
            style: buttonStyle,
            onPressed: () => Api().moveServoStepIncrease(6),
            child: Text(''),
          ),
        ),
      ],
    );
  }
}
