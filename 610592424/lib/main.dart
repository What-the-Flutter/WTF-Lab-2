import 'package:diploma/theme/theme_cubit.dart';
import 'package:diploma/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:diploma/data_base/shared_preferences_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'homePage/eventHolderScreen/eventholder_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesProvider.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    final userCredential =
    await FirebaseAuth.instance.signInAnonymously();
    assert(userCredential.user != null, 'user was null');
    runApp(DiplomaApp(userCredential.user!));
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

class DiplomaApp extends StatelessWidget {
  final User _user;
  const DiplomaApp(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(SharedPreferencesProvider()),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: "Diploma project",
            theme: state.theme,
            home: EventHolderPage(_user),
          );
        },
      ),
    );
  }
}


