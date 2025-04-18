import 'package:armcontrol/models/move_function_model.dart';
import 'package:armcontrol/providers/general_provider.dart';
import 'package:armcontrol/screens/control_screen.dart';
import 'package:armcontrol/utils/api.dart';
import 'package:armcontrol/widgets/runing_function_dialog_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController s1Controller = TextEditingController();
  TextEditingController s2Controller = TextEditingController();
  TextEditingController s3Controller = TextEditingController();
  TextEditingController s4Controller = TextEditingController();
  TextEditingController s5Controller = TextEditingController();
  TextEditingController s6Controller = TextEditingController();

  bool editing = false;
  int? editIndex;

  void edit(int index) {
    var list =
        ref
            .watch(generalProvider)
            .moveFunctions
            .where((func) => func.name == widget.moveFunction.name)
            .first
            .commands[index];

    setState(() {
      editing = true;
      editIndex = index;
      s1Controller.text = list[0].toString();
      s2Controller.text = list[1].toString();
      s3Controller.text = list[2].toString();
      s4Controller.text = list[3].toString();
      s5Controller.text = list[4].toString();
      s6Controller.text = list[5].toString();
    });
  }

  void saveEdit(int cmdIndex, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      await ref
          .read(generalProvider)
          .editFunctionCommand(widget.moveFunction, cmdIndex, [
            int.parse(s1Controller.text),
            int.parse(s2Controller.text),
            int.parse(s3Controller.text),
            int.parse(s4Controller.text),
            int.parse(s5Controller.text),
            int.parse(s6Controller.text),
          ])
          .then((value) {
            if (value) {
              setState(() {
                editing = false;
                editIndex = null;
              });
            }
          });
    } else {}
  }

  void cancelEdit(int index) {
    setState(() {
      editing = false;
      editIndex = null;
    });
  }

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
                    itemCount:
                        ref
                            .watch(generalProvider)
                            .moveFunctions
                            .where(
                              (func) => func.name == widget.moveFunction.name,
                            )
                            .first
                            .commands
                            .length ??
                        0,
                    itemBuilder: (context, index) {
                      var formKey = GlobalKey<FormState>();
                      if (ref
                          .watch(generalProvider)
                          .moveFunctions
                          .where(
                            (func) => func.name == widget.moveFunction.name,
                          )
                          .first
                          .commands
                          .isNotEmpty) {
                        var cmd =
                            ref
                                .watch(generalProvider)
                                .moveFunctions
                                .where(
                                  (func) =>
                                      func.name == widget.moveFunction.name,
                                )
                                .first
                                .commands[index];

                        return Container(
                          color:
                              index.isEven
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
                                  editing && editIndex == index
                                      ? textFieldColumn(s1Controller)
                                      : column('${cmd[0]}'),

                                  editing && editIndex == index
                                      ? textFieldColumn(s2Controller)
                                      : column('${cmd[1]}'),

                                  editing && editIndex == index
                                      ? textFieldColumn(s3Controller)
                                      : column('${cmd[2]}'),

                                  editing && editIndex == index
                                      ? textFieldColumn(s4Controller)
                                      : column('${cmd[3]}'),

                                  editing && editIndex == index
                                      ? textFieldColumn(s5Controller)
                                      : column('${cmd[4]}'),

                                  editing && editIndex == index
                                      ? textFieldColumn(s6Controller)
                                      : column('${cmd[5]}'),
                                  editing && editIndex == index
                                      ? GestureDetector(
                                        onTap: () {
                                          cancelEdit(index);
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
                                              name: widget.moveFunction.name,
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
                                              .read(generalProvider)
                                              .removeCommandFromFunction(
                                                widget.moveFunction,
                                                index,
                                              );
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
  }

  column(String value) {
    return Expanded(
      child: Center(
        child: Text(value, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  textFieldColumn(TextEditingController controller) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            height: 28,
            child: TextFormField(
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
        ref.read(generalProvider).functionMoveRecModeON(widget.moveFunction);
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
