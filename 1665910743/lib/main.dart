import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cubit/category_cubit/category_list_cubit.dart';
import 'cubit/theme_cubit/theme_cubit.dart';
import 'data/firebase_provider.dart';
import 'firebase_options.dart';
import 'services/anon_auth.dart';
import 'ui/theme/theme_data.dart';
import 'ui/widgets/journal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final _initTheme = await prefs.getString('theme') ?? 'light';
  final _user = await AuthService().singIn();
  await FirebaseDatabase.instance
      .ref()
      .child(_user!.uid)
      .child('auth')
      .set(false);

  runApp(
    BlocInit(user: _user, initTheme: _initTheme),
  );
}

class BlocInit extends StatelessWidget {
  const BlocInit({
    Key? key,
    required User? user,
    required String initTheme,
  })  : _user = user,
        _initTheme = initTheme,
        super(key: key);

  final User? _user;
  final String _initTheme;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CategoryListCubit(dataBaseRepository: FireBaseRTDB(user: _user)),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(
              _initTheme == 'light' ? MyThemes.lightTheme : MyThemes.darkTheme),
        ),
      ],
      child: Journal(),
    );
  }
}
