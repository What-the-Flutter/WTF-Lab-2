import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/components/auth/user_auth.dart';
import 'ui/screens/home/home_screen.dart';
import 'ui/screens/settings/settings_cubit.dart';

class NotikApp extends StatelessWidget {
  final String _appTitle = 'Notik';
  final SettingsState settings;

  const NotikApp({
    super.key,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return UserAuth(
      child: BlocProvider(
        create: (context) => SettingsCubit(settings),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: _appTitle,
              theme: context.read<SettingsCubit>().fetchTheme(),
              home: HomeScreen(
                settingsCubit: context.read<SettingsCubit>(),
              ),
            );
          },
        ),
      ),
    );
  }
}
