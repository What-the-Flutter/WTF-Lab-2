import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database_provider.dart';
import 'pages/event_page/event_page_cubit.dart';
import 'pages/home/home.dart';
import 'pages/home/home_cubit.dart';
import 'pages/new_category_page/new_category_page_cubit.dart';
import 'themes/inherited_theme.dart';

void main() async {
  await DatabaseProvider.db.initDB();
  DatabaseProvider.db.addValues();
  runApp(const ChatJournalApp());
}

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppThemeProvider(
      child: Builder(
        builder: ((context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HomeCubit(),
                ),
                BlocProvider(
                  create: (context) => NewCategoryPageCubit(),
                ),
                BlocProvider(
                  create: (context) => EventPageCubit(),
                ),
              ],
              child: MaterialApp(
                title: 'WTF Project',
                theme: Inherited.of(context).themeData,
                home: const HomePage(title: 'Home'),
              ),
            )),
      ),
    );
  }
}
