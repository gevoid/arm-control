import 'package:armcontrol/consts.dart';
import 'package:armcontrol/utils/api.dart';
import 'package:armcontrol/utils/local_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/route_manager.dart';
import 'package:armcontrol/utils/snackbar.dart';

class ConnectionSettingsScreen extends ConsumerStatefulWidget {
  const ConnectionSettingsScreen({super.key});

  @override
  ConsumerState<ConnectionSettingsScreen> createState() =>
      _ConnectionSettingsScreenState();
}

class _ConnectionSettingsScreenState
    extends ConsumerState<ConnectionSettingsScreen> {
  TextEditingController ipController = TextEditingController(text: Api.ip);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Mikro kontrolcünün kullandığı ip adresini girmelisiniz.',
              style: TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ),
          Row(
            children: [
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: ipController,

                  cursorColor: Colors.blue,
                  cursorWidth: 2,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(height: 0, fontSize: 0),

                    hintText: 'örnek: 127.0.0.1',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
              SizedBox(width: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await LocalUtils().saveConnectionIp(ipController.text).then((
                    value,
                  ) {
                    if (value) {
                      Snackbar.show(
                        'Başarıyla ip kayıt edildi.',
                        success: true,
                      );
                      Api.ip = ipController.text;
                    } else {
                      Snackbar.show(
                        'İp kayıt edilirken sorun oluştu.',
                        success: false,
                      );
                    }
                  });
                },
                icon: Icon(Icons.save_rounded, color: Colors.white38),
                label: Text('Kaydet', style: TextStyle(color: Colors.white60)),
              ),
              Spacer(flex: 3),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      title: Text('Bağlantı Ayarları', style: TextStyle(color: Colors.white)),
    );
  }
}
