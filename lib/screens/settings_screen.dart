import 'package:armcontrol/screens/functions_screen.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextStyle buttonTextStyle = TextStyle(color: Colors.blueGrey);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            button(
              'Fonksiyon Ayarları',
              Icon(Icons.functions, color: Colors.white),
              FunctionsScreen(),
              context,
            ),
            button(
              'Bağlantı Ayarları',
              Icon(Icons.wifi_tethering_outlined, color: Colors.white),
              FunctionsScreen(),
              context,
            ),

            button(
              'Veri İletim Ayarları',
              Icon(Icons.data_object, color: Colors.white),
              FunctionsScreen(),
              context,
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Ayarlar', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
  }
}

button(String text, Icon icon, Widget pushScreen, BuildContext context) {
  return GestureDetector(
    onTap:
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pushScreen),
        ),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            icon,
            SizedBox(height: 10),
            Text(text, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    ),
  );
}
