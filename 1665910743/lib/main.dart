import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/category_list_cubit.dart';
import 'data/database_provider.dart';
import 'ui/theme/inherited_widget.dart';
import 'ui/theme/theme_data.dart';
import 'ui/widgets/home_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBase.db.initDB();
  final prefs = await SharedPreferences.getInstance();
  final _themeIndex = prefs.getInt('theme') ?? 0;
  runApp(
    BlocProvider(
      create: (_) => CategoryListCubit(),
      child: CustomTheme(
        initialThemeKey: MyThemeKeys.values[_themeIndex],
        child: const Journal(),
      ),
    ),
  );
}

class Journal extends StatefulWidget {
  const Journal({Key? key}) : super(key: key);

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  @override
  void initState() {
    final _cubit = BlocProvider.of<CategoryListCubit>(context);
    _cubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.of(context).theme,
      home: const Home(),
    );
  }
}
