// import 'package:bloc_test/bloc_test.dart';
// import 'package:test/test.dart';
// import 'package:flutter/material.dart';
// import 'package:chat_app/repository/shared_pref_app.dart';
//
// import 'package:chat_app/theme/theme_state.dart';
//
// void main() {
//   late ThemeCubit themeCubit;
//
//   setUp(() {
//     WidgetsFlutterBinding.ensureInitialized();
//     themeCubit = ThemeCubit();
//   });
//
//   group(
//     "Theme Cubit tests",
//     () {
//       blocTest<ThemeCubit, ThemeState>(
//         'Change Theme App',
//         seed: () => ThemeState(
//           isLightTheme: true,
//           textTheme: ThemeState.defaultTextTheme,
//           appThemes: ThemeData(),
//         ),
//         build: () => themeCubit,
//         act: (cubit) {
//           cubit.changeTheme();
//         },
//         expect: () => [
//           ThemeState(
//             isLightTheme: false,
//             textTheme: ThemeState.defaultTextTheme,
//             appThemes: ThemeData(),
//           ),
//         ],
//       );
//     },
//   );
// }
