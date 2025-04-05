import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/add_command_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../consts.dart';

class FunctionDetailsScreen extends ConsumerStatefulWidget {
  final MoveFunction moveFunction;
  const FunctionDetailsScreen({required this.moveFunction, super.key});

  @override
  ConsumerState<FunctionDetailsScreen> createState() =>
      _FunctionDetailsScreenConsumerState();
}

class _FunctionDetailsScreenConsumerState
    extends ConsumerState<FunctionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: backgroundColor,

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Index', style: TextStyle(color: Colors.white70)),

                  column('Type'),
                  column('Type Value'),
                  column('Servo Number'),
                  column('Target Angle'),
                  Icon(Icons.edit, color: Colors.transparent),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        ref
                            .watch(generalProvider)
                            .moveFunctions
                            .where(
                              (func) => func.name == widget.moveFunction.name,
                            )
                            .first
                            .commands
                            ?.length ??
                        0,
                    itemBuilder: (context, index) {
                      var cmd = widget.moveFunction.commands?[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onLongPress: () {
                            Get.defaultDialog(
                              title: "Uyarı",
                              content: Text(
                                '#${index} sıralı komutu gerçekten silmek istiyor musunuz?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(generalProvider)
                                        .removeCommandFromFunction(
                                          widget.moveFunction,
                                          index,
                                        );
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '#$index',
                                    style: TextStyle(color: Colors.white60),
                                  ),
                                  SizedBox(width: 15),
                                  column(cmd?.type ?? ''),
                                  column(cmd?.typeValue ?? ''),
                                  column(cmd?.servoNumber.toString() ?? ''),
                                  column(cmd?.targetAngle.toString() ?? ''),
                                  GestureDetector(
                                    onTap:
                                        () => Get.to(
                                          () => AddCommandScreen(
                                            moveFunction: widget.moveFunction,
                                            cmdIndex: index,
                                            command: cmd,
                                          ),
                                        ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white60,
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        onPressed:
                            () => Get.to(
                              () => AddCommandScreen(
                                moveFunction: widget.moveFunction,
                              ),
                            ),
                        label: Text(
                          'Komut Ekle',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  column(String value) {
    return Expanded(
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.moveFunction.name ?? '',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.play_arrow_rounded, color: Colors.white),
        ),
      ],
      backgroundColor: backgroundColor,
    );
  }
}
