import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../screens/auth_screen.dart';
import 'home_widget.dart';

class Journal extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  Journal({
    Key? key,
  }) : super(key: key);

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CategoryListCubit>(context).getAuthKey();
  }

  @override
  Widget build(BuildContext context) {
    final authKey = context.watch<CategoryListCubit>().state.authKey;
    return BlocBuilder<ThemeCubit, ThemeData>(
      bloc: context.watch<ThemeCubit>(),
      builder: ((context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state,
          home: (authKey ?? false) ? const BioAuth() : const Home(),
        );
      }),
    );
  }
}
