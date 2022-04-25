import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/font_cubit/font_cubit.dart';
import '../../theme/theme_cubit/theme_cubit.dart';
import '../splash_&_auth/auth_screen.dart';
import '../splash_&_auth/cubit/auth_cubit.dart';
import 'cubit/home_cubit.dart';
import 'home_widget.dart';

class Journal extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  Journal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textTheme = context.watch<FontCubit>().state;
    final authKey = context.watch<HomeCubit>().state.authKey;
    return BlocBuilder<ThemeCubit, ThemeData>(
      bloc: context.watch<ThemeCubit>(),
      builder: ((context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.copyWith(textTheme: _textTheme, useMaterial3: true),
          home: (authKey)
              ? BioAuth(
                  authCubit: context.watch<AuthCubit>(),
                )
              : Home(
                  homeCubit: context.read<HomeCubit>(),
                  themeCubit: context.read<ThemeCubit>(),
                ),
        );
      }),
    );
  }
}
