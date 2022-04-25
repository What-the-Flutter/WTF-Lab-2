import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/firebase_provider.dart';
import '../../theme/font_cubit/font_cubit.dart';
import '../../theme/theme_cubit/theme_cubit.dart';
import '../../theme/theme_data.dart';
import '../Category_Screen/cubit/category_cubit.dart';
import '../chat_screen/cubit/event_cubit.dart';
import '../settings/cubit/settings_cubit.dart';
import '../splash_&_auth/cubit/auth_cubit.dart';
import '../timeline_screen/cubit/filter_cubit.dart';
import 'cubit/home_cubit.dart';
import 'journal.dart';

class BlocsProvider extends StatelessWidget {
  final User user;
  final String initTheme;
  final String initFontSize;
  final String backgroundImagePath;
  final bool isChatBubblesToRight;

  const BlocsProvider({
    Key? key,
    required this.backgroundImagePath,
    required this.isChatBubblesToRight,
    required this.user,
    required this.initTheme,
    required this.initFontSize,
  }) : super(key: key);

  TextTheme getFontSize(String size) {
    final TextTheme fontSize;
    if (size == 'small') {
      fontSize = FontSize.small;
    } else if (size == 'medium') {
      fontSize = FontSize.medium;
    } else {
      fontSize = FontSize.large;
    }

    return fontSize;
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = getFontSize(initFontSize);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (_) => CategoryCubit(
            dataBaseRepository: FireBaseRTDB(user: user),
          )..getCat(),
        ),
        BlocProvider(
          create: (_) => HomeCubit(
            dataBaseRepository: FireBaseRTDB(user: user),
          )..getAuthKey(),
        ),
        BlocProvider(
          create: (_) => EventCubit(
            dataBaseRepository: FireBaseRTDB(user: user),
          )..getEvents(),
        ),
        BlocProvider(
          create: (_) => SettingsCubit(
            alignRight: isChatBubblesToRight,
            image: backgroundImagePath,
          ),
        ),
        BlocProvider(
          create: (_) => AuthCubit(),
        ),
        BlocProvider(
          create: (_) => ThemeCubit(
            initTheme == 'light' ? MyThemes.lightTheme : MyThemes.darkTheme,
          ),
        ),
        BlocProvider(
          create: (_) => FontCubit(initSize: fontSize),
        ),
        BlocProvider(
          create: (_) => FilterCubit(),
        ),
      ],
      child: Journal(),
    );
  }
}
