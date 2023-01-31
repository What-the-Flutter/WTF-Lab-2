// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';
//
// class MainNavigationBar extends StatefulWidget {
//   const MainNavigationBar({Key? key}) : super(key: key);
//
//   @override
//   State<MainNavigationBar> createState() => _MainNavigationBarState();
// }
//
// class _MainNavigationBarState extends State<MainNavigationBar> {
//   StateMachineController getRiveController(Artboard artboard,
//       {required String stateMachineName}) {
//     final controller =
//         StateMachineController.fromArtboard(artboard, stateMachineName);
//     artboard.addController(controller!);
//     return controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     late SMIBool homeTrigger;
//     late SMIBool homeTriggerEnd;
//     return BottomNavigationBar(
//       onTap: (index) {
//         homeTrigger.change(true);
//         Future.delayed(Duration(seconds: 1)).then((value) => homeTrigger.change(false));
//       },
//       items: [
//         BottomNavigationBarItem(
//           icon: SizedBox(
//             height: 35,
//             child: RiveAnimation.asset(
//               'assets/icons.riv',
//               artboard: 'HOME',
//               fit: BoxFit.fitHeight,
//               onInit: (artboard) {
//                 final controller = getRiveController(artboard,
//                     stateMachineName: 'HOME_interactivity');
//                 homeTrigger = controller.findSMI('active') as SMIBool;
//               },
//             ),
//           ),
//           label: 'home',
//         ),
//         BottomNavigationBarItem(
//           icon: SizedBox(
//             height: 35,
//             child: RiveAnimation.asset(
//               'assets/animated_icon_set_-_1_color.riv',
//               artboard: 'HOME',
//               fit: BoxFit.fitHeight,
//               onInit: (artboard) {
//                 final controller = getRiveController(artboard,
//                     stateMachineName: 'HOME_interactivity');
//                 homeTrigger = controller.findSMI('active') as SMIBool;
//               },
//             ),
//           ),
//           label: 'timeline',
//         ),
//       ],
//     );
//   }
// }
