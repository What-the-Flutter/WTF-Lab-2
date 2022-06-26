import 'package:diploma/leading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_page/settings_cubit.dart';
import 'settings_page/settings_state.dart';

class DiplomaApp extends StatelessWidget {
  const DiplomaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: "Diploma project",
            theme: state.currentTheme,
            home: const LeadingPage(),
          );
        },
      ),
    );
  }
}
