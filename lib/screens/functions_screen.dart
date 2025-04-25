import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/function_details_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
    var moveFunctions = ref.watch(
      generalProvider.select((g) => g.moveFunctions),
    );
    return Scaffold(
      appBar: appBar(),
      backgroundColor: backgroundColor,

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: moveFunctions.length,
              itemBuilder: (context, index) {
                var function = moveFunctions[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        width: 400,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Uyarı',
                        desc:
                            '${function.name} isimli fonksiyonu gerçekten silmek istiyor musunuz?',
                        btnOkText: 'Sil',
                        btnOkOnPress: () {
                          ref
                              .read(generalProvider.notifier)
                              .removeMoveFunction(function);
                        },
                        btnCancelText: 'İptal',
                        btnCancelOnPress: () {},
                      ).show();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Text(
                              function.name,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            Spacer(),
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
                    .read(generalProvider.notifier)
                    .addMoveFunction(functionNameController.text)
                    .then((value) {
                      if (!value) {
                        if (mounted) {
                          AwesomeDialog(
                            context: context,
                            width: 400,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Hata',
                            desc:
                                '${functionNameController.text.toUpperCase()} adında bir fonksiyon zaten mevcut.',
                            btnOkText: 'Tamam',
                            btnOkOnPress: () {},
                          ).show();
                        }
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
