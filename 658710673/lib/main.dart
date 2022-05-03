import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/shared_preferences_provider.dart';
import 'firebase_options.dart';
import 'services/anonymous_auth.dart';
import 'services/local_auth.dart';
import 'services/service_locator.dart';
import 'splash_screen/splash_screen.dart';
import 'utils/theme/app_theme.dart';
import 'utils/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesProvider.initialize();
  final _prefsProvider = SharedPreferencesProvider();
  final _initTheme = await _prefsProvider.fetchTheme();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(
            _initTheme == ThemeKeys.light.toString() ? AppTheme.lightTheme : AppTheme.darkTheme,
          ),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state,
          title: 'Chat journal',
          home: SplashScreen(user: _user),
        );
      }),
    );
  }
}
