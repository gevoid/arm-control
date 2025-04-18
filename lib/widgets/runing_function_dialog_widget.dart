import 'dart:async';

import 'package:armcontrol/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotatingBoxDialog extends StatefulWidget {
  @override
  _RotatingBoxDialogState createState() => _RotatingBoxDialogState();
}

class _RotatingBoxDialogState extends State<RotatingBoxDialog>
    with SingleTickerProviderStateMixin {
  Timer? _statusTimer;
  late AnimationController _animationController;

  Future checkStatus() async {
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1000), (
      timer,
    ) async {
      await Api().checkMoveFunctionStatus().then((value) {
        print('$value');
        if (value == true) {
          Get.back();
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(); // Sürekli döner
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _animationController.dispose(); // Bellek sızıntısı olmaması için
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Transform.rotate(
              angle: _animationController.value * 2 * 3.14159,
              child: child,
            );
          },
          child: SizedBox(
            height: 80,
            width: 80,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset('assets/bseu_logo.png'),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Acil bir durumda hemen durdurmak için!",
          style: TextStyle(color: Colors.redAccent, fontSize: 12),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            await Api().stopMoveFunction().then((value) {
              if (value) {
                _statusTimer?.cancel();
                _animationController
                    .dispose(); // Bellek sızıntısı olmaması için
                Get.back();
              }
            });
          },
          icon: Icon(Icons.warning_amber_rounded, color: Colors.white),
          label: Text(
            "ACİL STOP",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.shade700, // Güncel kullanım
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 10,
            shadowColor: Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

// Dialogu açmak için:
void showRunningBoxDialog() {
  Get.defaultDialog(
    title: "Fonksiyon Çalışıyor",
    content: RotatingBoxDialog(),
    barrierDismissible: false,
  );
}
