// import 'package:armcontrol/consts.dart';
// import 'package:armcontrol/models/move_function_model.dart';
// import 'package:armcontrol/providers/general_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
//
// class AddCommandScreen extends ConsumerStatefulWidget {
//   MoveFunction moveFunction;
//   Command? command;
//   int? cmdIndex;
//   AddCommandScreen({
//     this.command,
//     this.cmdIndex,
//     required this.moveFunction,
//     super.key,
//   });
//
//   @override
//   ConsumerState<AddCommandScreen> createState() =>
//       _AddCommandScreenConsumerState();
// }
//
// class _AddCommandScreenConsumerState extends ConsumerState<AddCommandScreen> {
//   TextEditingController typeController = TextEditingController();
//   TextEditingController typeValueController = TextEditingController();
//   TextEditingController servoNumberController = TextEditingController();
//   TextEditingController targetAngleController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.command != null) {
//       setState(() {
//         typeController.text = widget.command?.type ?? '';
//         typeValueController.text = widget.command?.typeValue ?? '';
//         servoNumberController.text =
//             widget.command?.servoNumber.toString() ?? '';
//         targetAngleController.text =
//             widget.command?.targetAngle.toString() ?? '';
//       });
//     }
//     // SystemChrome.setPreferredOrientations([
//     //   DeviceOrientation.portraitUp,
//     //   DeviceOrientation.portraitDown,
//     // ]);
//   }
//
//   @override
//   void dispose() {
//     // SystemChrome.setPreferredOrientations([
//     //   DeviceOrientation.landscapeLeft,
//     //   DeviceOrientation.landscapeRight,
//     // ]);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: appBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               textField(
//                 typeController,
//                 'Komutun tipini giriniz',
//                 'Move, Wait, WaitAndMove olabilir.',
//               ),
//               SizedBox(height: 30),
//               textField(
//                 typeValueController,
//                 'Komutun tipinin değerini giriniz',
//                 'Wait için milisaniye değeri girilmelidir.',
//               ),
//               SizedBox(height: 30),
//               textField(
//                 servoNumberController,
//                 'Çalıştırılacak servo numarası giriniz.',
//                 '1 ile 6 arasında olmalıdır.',
//               ),
//
//               SizedBox(height: 30),
//               textField(
//                 targetAngleController,
//                 'Çalıştırılacak servonun ulaşması gereken açıyı giriniz.',
//                 '0 ile 180 arasında olmalıdır.',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   textField(
//     TextEditingController controller,
//     String labelText,
//     String helperText,
//   ) {
//     return TextField(
//       controller: controller,
//       style: TextStyle(color: Colors.white70),
//       cursorColor: Colors.white70,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blueGrey,
//             width: 2,
//           ), // Normal çizgi
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.blue.shade800,
//             width: 2,
//           ), // Normal çizgi
//         ),
//         helperText: helperText,
//         helperStyle: TextStyle(color: Colors.white60),
//         labelText: labelText,
//         labelStyle: TextStyle(color: Colors.white70, fontSize: 12),
//       ),
//     );
//   }
//
//   AppBar appBar() => AppBar(
//     backgroundColor: backgroundColor,
//     leading: IconButton(
//       onPressed: () => Get.back(),
//       icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
//     ),
//     title: Text('Komut Ekle', style: TextStyle(color: Colors.white)),
//     actions: [
//       TextButton(
//         onPressed: () {
//           if (widget.command == null) {
//             ref
//                 .read(generalProvider)
//                 .addCommandToFunction(
//                   widget.moveFunction,
//                   Command(
//                     type: typeController.text,
//                     typeValue: typeValueController.text,
//                     servoNumber: int.tryParse(servoNumberController.text),
//                     targetAngle: int.tryParse(targetAngleController.text),
//                   ),
//                 )
//                 .then((value) => Get.back());
//           } else if (widget.command != null && widget.cmdIndex != null) {
//             ref
//                 .read(generalProvider)
//                 .updateCommandFromFunction(
//                   widget.moveFunction,
//                   widget.cmdIndex!,
//                   Command(
//                     type: typeController.text,
//                     typeValue: typeValueController.text,
//                     servoNumber: int.tryParse(servoNumberController.text),
//                     targetAngle: int.tryParse(targetAngleController.text),
//                   ),
//                 )
//                 .then((value) => Get.back());
//           }
//         },
//         child: Text('Kaydet', style: TextStyle(color: Colors.white)),
//       ),
//     ],
//   );
// }
