import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/bloc_observer.dart';
import 'cubit/categorylist_cubit.dart';
import 'ui/theme/inherited_widget.dart';
import 'ui/theme/theme_data.dart';
import 'ui/widgets/home_widget.dart';

void main() {
  BlocOverrides.runZoned(
      () => runApp(
            BlocProvider(
              create: (_) => CategorylistCubit(),
              child: const CustomTheme(
                initialThemeKey: MyThemeKeys.light,
                child: Journal(),
              ),
            ),
          ),
      blocObserver: MyBlocObserver());
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
