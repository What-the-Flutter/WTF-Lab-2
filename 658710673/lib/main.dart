import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'category_page/category_cubit.dart';
import 'create_category_page/create_category_cubit.dart';
import 'firebase_options.dart';
import 'home_page/home_cubit.dart';
import 'home_page/home_page.dart';
import 'services/anonymous_auth.dart';
import 'services/local_auth.dart';
import 'services/service_locator.dart';
import 'utils/theme/app_theme.dart';
import 'utils/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final _prefs = await SharedPreferences.getInstance();
  final _initTheme = await _prefs.getString('theme') ?? ThemeKeys.light.toString();
  final _user = await AuthService().authorize();

  setupLocator();
  locator<LocalAuthenticationService>().authenticate();
  runApp(ChatJournalApp(
    initTheme: _initTheme,
    user: _user,
  ));
}

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({
    Key? key,
    required String initTheme,
    required User? user,
  })  : _initTheme = initTheme,
        _user = user,
        super(key: key);

  final String _initTheme;
  final User? _user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(
        _initTheme == ThemeKeys.light.toString() ? AppTheme.lightTheme : AppTheme.darkTheme,
      ),
      child: BlocBuilder<ThemeCubit, ThemeData>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state,
          title: 'Chat journal',
          home: MultiBlocProvider(
            providers: [
              BlocProvider<HomeCubit>(create: (context) => HomeCubit(user: _user)),
              BlocProvider<CreateCategoryPageCubit>(create: (context) => CreateCategoryPageCubit()),
              BlocProvider<CategoryCubit>(create: (context) => CategoryCubit(user: _user)),
            ],
            child: HomePage(),
          ),
        );
      }),
    );
  }
}
