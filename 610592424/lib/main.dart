import 'package:diploma/leading_page.dart';
import 'package:diploma/theme/theme_cubit.dart';
import 'package:flutter/material.dart';

import 'package:diploma/data_base/shared_preferences_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page/settings_screen/settings_cubit.dart';
import 'home_page/settings_screen/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DiplomaApp());
}

class DiplomaApp extends StatelessWidget {
  const DiplomaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SettingsCubit(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(SharedPreferencesProvider()),
        ),
      ],
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


