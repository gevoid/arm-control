part of '../control_screen.dart';

class FunctionButtonsWidget extends ConsumerWidget {
  FunctionButtonsWidget({super.key});
  var buttonTextStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build Function Buttons');
    bool moveRecMode = ref.watch(generalProvider.select((g) => g.moveRecMode));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        functionButtons(ref),
        SizedBox(height: 10),
        moveRecMode ? recordButtons(ref, context) : SizedBox(),
      ],
    );
  }

  functionButtons(WidgetRef ref) {
    List<Widget> fucntionsButtonsWidgetList = [];
    List<MoveFunction> mfl =
        ref.watch(generalProvider.select((g) => g.moveFunctions)) ?? [];
    String moveRecFunctionName = ref.watch(
      generalProvider.select((g) => g.moveRecFunctionName),
    );
    for (int i = 0; i < mfl.length; i++) {
      fucntionsButtonsWidgetList.add(
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ElevatedButton(
              onPressed: () async {
                showRunningBoxDialog();
                await Api().runMoveFunction(mfl[i]);
              },
              child: Text(mfl[i].name ?? '', style: buttonTextStyle),
            ),
            moveRecFunctionName == mfl[i].name
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '◉ Kayıt',
                    style: TextStyle(color: Colors.green, fontSize: 9),
                  ),
                )
                : SizedBox(),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Spacer(flex: 4),
          Flexible(
            fit: FlexFit.tight,
            flex: 6,
            child: Stack(
              alignment: Alignment.centerRight,
              clipBehavior: Clip.none,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 20,
                      top: -16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 3.0,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Fonksiyonlar',
                            style: TextStyle(color: Colors.black, fontSize: 9),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadiusDirectional.circular(20),
                      ),
                      child: SizedBox(
                        height: 45,
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: mfl.length,

                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                right: 4.0,
                              ),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Snackbar.show(
                                        'Fonksiyonu başlatmak için basılı tutmalısınız.',
                                        success: true,
                                      );
                                    },
                                    onLongPress: () async {
                                      await Api().runMoveFunction(mfl[i]).then((
                                        value,
                                      ) {
                                        if (value) {
                                          showRunningBoxDialog();
                                        }
                                      });
                                    },
                                    child: Text(
                                      mfl[i].name ?? '',
                                      style: buttonTextStyle,
                                    ),
                                  ),
                                  moveRecFunctionName == mfl[i].name
                                      ? Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 4.0,
                                        ),
                                        child: Text(
                                          '◉ Kayıt',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 9,
                                          ),
                                        ),
                                      )
                                      : SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
            child: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  IntrinsicHeight recordButtons(WidgetRef ref, context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () async {
              bool status =
                  await ref
                      .read(generalProvider.notifier)
                      .addCommandToFunction();
              if (status) {
                AwesomeDialog(
                  context: context,
                  width: 400,
                  dialogType: DialogType.success,
                  animType: AnimType.rightSlide,
                  title: 'Başarılı',
                  desc:
                      'Mevcut konum ${ref.read(generalProvider).moveRecFunctionName} adlı fonksiyona eklendi.',
                  btnOkText: 'Tamam',
                  btnOkOnPress: () {},
                ).show();
              } else {
                AwesomeDialog(
                  context: context,
                  width: 400,
                  dialogType: DialogType.error,
                  animType: AnimType.rightSlide,
                  title: 'Başarısız',
                  desc:
                      'Mevcut konum ${ref.read(generalProvider).moveRecFunctionName} adlı fonksiyona kaydedilirken hata oluştu.',
                  btnOkText: 'Tamam',
                  btnOkOnPress: () {},
                ).show();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(100),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Icon(Icons.save, size: 28, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      textAlign: TextAlign.center,
                      'Konumu\nKaydet',
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap:
                () =>
                    ref.read(generalProvider.notifier).functionMoveRecModeOFF(),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(100),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Icon(Icons.stop_rounded, size: 28, color: Colors.red),
                    Text(
                      textAlign: TextAlign.center,
                      'Kayıt Modu\nKapat',
                      style: TextStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
