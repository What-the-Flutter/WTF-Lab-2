import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../../data/firebase_provider.dart';
import '../theme/theme_data.dart';
import 'journal.dart';

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
          create: (_) => CategoryListCubit(
            dataBaseRepository: FireBaseRTDB(user: _user),
          ),
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
