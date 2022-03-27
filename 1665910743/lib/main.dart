import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/categorylist_cubit.dart';
import 'ui/theme/inherited_widget.dart';
import 'ui/theme/theme_data.dart';
import 'ui/widgets/home_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final _themeIndex = prefs.getInt('theme') ?? 0;
  runApp(
    BlocProvider(
      create: (_) => CategorylistCubit(),
      child: CustomTheme(
        initialThemeKey: MyThemeKeys.values[_themeIndex],
        child: const Journal(),
      ),
    ),
  );
}

class Journal extends StatelessWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.of(context).theme,
      home: const Home(),
    );
  }
}
