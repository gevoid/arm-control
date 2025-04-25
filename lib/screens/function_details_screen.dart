import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/screens/control_screen/control_screen.dart';
import 'package:armcontrol/utils/api.dart';
import 'package:armcontrol/utils/snackbar.dart';
import 'package:armcontrol/widgets/runing_function_dialog_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../consts.dart';
import '../providers/general_provider.dart';

class FunctionDetailsScreen extends ConsumerStatefulWidget {
  final MoveFunction moveFunction;
  const FunctionDetailsScreen({required this.moveFunction, super.key});

  @override
  ConsumerState<FunctionDetailsScreen> createState() =>
      _FunctionDetailsScreenConsumerState();
}

class _FunctionDetailsScreenConsumerState
    extends ConsumerState<FunctionDetailsScreen> {
  late List<GlobalKey<FormState>> formKeys;
  late List<TextEditingController> controllers;

  bool editing = false;
  int? lastEditIndex;
  int? editIndex;

  @override
  void initState() {
    super.initState();
    formKeys = List.generate(
      ref
          .read(generalProvider)
          .moveFunctions
          .where((func) => func.name == widget.moveFunction.name)
          .first
          .commands
          .length,
      (_) => GlobalKey<FormState>(),
    );

    controllers = List.generate(6, (_) => TextEditingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cancelEdit();
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void edit(int index) {
    var list =
        ref
            .read(generalProvider)
            .moveFunctions
            .firstWhereOrNull((func) => func.name == widget.moveFunction.name)
            ?.commands[index] ??
        [];

    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = list[i].toString();
    }
    ref.read(generalProvider.notifier).startFunctionCmdEdit(index);
  }

  void saveEdit(int cmdIndex, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      final command = controllers.map((c) => int.parse(c.text)).toList();
      await ref
          .read(generalProvider.notifier)
          .editFunctionCommand(widget.moveFunction, cmdIndex, command)
          .then((value) {
            if (value) {
              ref.read(generalProvider.notifier).saveFunctionCmdEdit(cmdIndex);
            }
          });
    } else {}
  }

  void cancelEdit() {
    ref.read(generalProvider.notifier).cancelFunctionCmdEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        editing = ref.watch(
          generalProvider.select((g) => g.functionCmdEditing),
        );
        lastEditIndex = ref.watch(
          generalProvider.select((g) => g.functionCmdLastEditIndex),
        );
        editIndex = ref.watch(
          generalProvider.select((g) => g.functionCmdEditIndex),
        );
        // print('build func details : last edit index $lastEditIndex');
        // print(widget.moveFunction.name);

        var cmds = ref.read(
          generalProvider.select(
            (g) =>
                g.moveFunctions
                    .firstWhereOrNull(
                      (func) => func.name == widget.moveFunction.name,
                    )
                    ?.commands ??
                [],
          ),
        );
        formKeys = List.generate(cmds.length, (_) => GlobalKey<FormState>());
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
                      column('S1'),
                      column('S2'),
                      column('S3'),
                      column('S4'),
                      column('S5'),
                      column('S6'),
                      Icon(Icons.play_arrow_rounded, color: Colors.transparent),
                      SizedBox(width: 16),
                      Icon(Icons.edit, color: Colors.transparent),
                      SizedBox(width: 16),
                      Icon(Icons.delete_forever, color: Colors.transparent),
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
                        itemCount: cmds.length,
                        itemBuilder: (context, index) {
                          var formKey = formKeys[index];
                          if (cmds.isNotEmpty) {
                            var cmd = cmds[index];

                            return Container(
                              key: ValueKey(index),
                              color:
                                  (lastEditIndex == index)
                                      ? Colors.blue.shade900
                                      : index.isEven
                                      ? Colors.transparent
                                      : Colors.black45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Form(
                                  key: formKey,
                                  child: Row(
                                    children: [
                                      Text(
                                        '#$index',
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                      SizedBox(width: 15),
                                      ...buildCmdRow(cmd, index, formKey),
                                      editing && editIndex == index
                                          ? GestureDetector(
                                            onTap: () {
                                              cancelEdit();
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.white60,
                                            ),
                                          )
                                          : GestureDetector(
                                            onTap: () async {
                                              showRunningBoxDialog();
                                              await Api().runMoveFunction(
                                                MoveFunction(
                                                  name:
                                                      widget.moveFunction.name,
                                                  commands: [
                                                    ref
                                                        .watch(generalProvider)
                                                        .moveFunctions
                                                        .where(
                                                          (func) =>
                                                              func.name ==
                                                              widget
                                                                  .moveFunction
                                                                  .name,
                                                        )
                                                        .first
                                                        .commands[index],
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white60,
                                            ),
                                          ),
                                      SizedBox(width: 16),
                                      editing && editIndex == index
                                          ? GestureDetector(
                                            onTap: () {
                                              saveEdit(index, formKey);
                                            },
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white60,
                                            ),
                                          )
                                          : GestureDetector(
                                            onTap: () {
                                              edit(index);
                                            },
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white60,
                                            ),
                                          ),

                                      SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          AwesomeDialog(
                                            context: context,
                                            width: 400,
                                            dialogType: DialogType.warning,

                                            animType: AnimType.rightSlide,
                                            title: 'Uyarı',
                                            desc:
                                                '${widget.moveFunction.name} adlı fonksiyondaki $index numaralı indeksi silmek istediğinize emin misiniz?',
                                            btnOkText: 'Sil',
                                            btnOkOnPress: () {
                                              ref
                                                  .read(
                                                    generalProvider.notifier,
                                                  )
                                                  .removeCommandFromFunction(
                                                    widget.moveFunction,
                                                    index,
                                                  )
                                                  .then((value) {
                                                    if (value) {
                                                      setState(() {});
                                                      // bug olduğu için setstate kullanıldı
                                                    } else {
                                                      Snackbar.show(
                                                        'Fonksiyondaki $index numaralı indeks silinirken hata oluştu. ',
                                                        success: false,
                                                      );
                                                    }
                                                  });
                                            },
                                            btnCancelText: 'İptal',
                                            btnCancelOnPress: () {},
                                          ).show();
                                        },
                                        child: Icon(
                                          Icons.delete_forever,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  column(String value) {
    return Expanded(
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  List<Widget> buildCmdRow(
    List<int> cmd,
    int index,
    GlobalKey<FormState> formKey,
  ) {
    return List.generate(6, (i) {
      return editing && editIndex == index
          ? textFieldColumn(controllers[i])
          : column('${cmd[i]}');
    });
  }

  textFieldColumn(TextEditingController controller) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 28,
            child: TextFormField(
              key: ValueKey('edit-$editIndex-${controller.hashCode}'),
              keyboardType: TextInputType.number,
              controller: controller,

              cursorColor: Colors.blue,
              cursorWidth: 2,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0, fontSize: 0),

                hintText: 'Yaz...',
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

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'boş olamaz';
                }
                final intValue = int.tryParse(value);
                if (intValue == null) {
                  return 'tam sayı girin';
                }
                return null;
              },
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.moveFunction.name,
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      actions: [
        recButton(),
        SizedBox(width: 20),
        runButton(),
        SizedBox(width: 20),
      ],
      backgroundColor: backgroundColor,
    );
  }

  GestureDetector runButton() {
    return GestureDetector(
      onTap: () async {
        showRunningBoxDialog();
        await Api().runMoveFunction(
          ref
              .watch(generalProvider)
              .moveFunctions
              .where((func) => func.name == widget.moveFunction.name)
              .first,
        );
      },
      child: Column(
        children: [
          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
          SizedBox(height: 2),
          Text('Çalıştır', style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  GestureDetector recButton() {
    return GestureDetector(
      onTap: () {
        ref
            .read(generalProvider.notifier)
            .functionMoveRecModeON(widget.moveFunction);
        Get.to(() => ControlScreen());
      },
      child: Column(
        children: [
          Icon(CupertinoIcons.recordingtape, color: Colors.white, size: 30),
          SizedBox(height: 2),
          Text(
            'Kayıt Modu Aç',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
