import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/function_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../consts.dart';

class FunctionsScreen extends ConsumerStatefulWidget {
  const FunctionsScreen({super.key});

  @override
  ConsumerState<FunctionsScreen> createState() => _FunctionsScreenState();
}

class _FunctionsScreenState extends ConsumerState<FunctionsScreen> {
  TextEditingController functionNameController = TextEditingController();
  bool addFunction = false;
  @override
  Widget build(BuildContext context) {
    var providerW = ref.watch(generalProvider);
    var providerR = ref.read(generalProvider);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: backgroundColor,

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: providerW.moveFunctions.length,
              itemBuilder: (context, index) {
                var function = providerW.moveFunctions[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onLongPress: () {
                      Get.defaultDialog(
                        title: "Uyarı",
                        content: Text(
                          '${function.name} isimli fonksiyonu gerçekten silmek istiyor musunuz?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              providerR.removeMoveFunction(function);
                              Get.back();
                            },
                            child: Text(
                              'Sil',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'İptal',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              function.name ?? '',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.edit, color: Colors.white70),
                              onPressed:
                                  () => Get.to(
                                    () => FunctionDetailsScreen(
                                      moveFunction: function,
                                    ),
                                  ),
                              label: Text(
                                'Düzenle',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('Fonksiyonlar', style: TextStyle(color: Colors.white)),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        addFunction
            ? SizedBox(
              width: 200,
              child: TextField(
                controller: functionNameController,
                style: TextStyle(color: Colors.white70),
                cursorColor: Colors.white70,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue.shade800,
                      width: 2,
                    ), // Normal çizgi
                  ),

                  labelText: 'Fonksiyon Adını Giriniz',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            )
            : SizedBox(),
        SizedBox(width: 10),
        !addFunction
            ? IconButton(
              onPressed: () {
                setState(() {
                  addFunction = true;
                });
              },
              icon: Icon(Icons.add, color: Colors.white),
            )
            : ElevatedButton(
              onPressed: () {
                ref
                    .read(generalProvider)
                    .addMoveFunction(functionNameController.text)
                    .then((value) {
                      if (!value) {
                        Get.defaultDialog(
                          title: 'Hata',
                          content: Text(
                            'Bu isimde bir fonksiyon zaten mevcut.',
                          ),
                        );
                      } else {
                        setState(() {
                          addFunction = false;
                        });
                      }
                    });
              },
              child: Text('Kaydet', style: TextStyle(color: Colors.white)),
            ),
      ],
      backgroundColor: backgroundColor,
    );
  }
}
