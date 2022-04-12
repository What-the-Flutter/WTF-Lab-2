import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_page/category_cubit.dart';
import 'create_category_page/create_category_cubit.dart';
import 'home_page/home_cubit.dart';
import 'home_page/home_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(
    const CustomTheme(
      child: ChatJournalApp(),
    ),
  );
}

class ChatJournalApp extends StatelessWidget {
  const ChatJournalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat journal',
      theme: InheritedCustomTheme.of(context).themeData,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
          BlocProvider<CreateCategoryPageCubit>(create: (context) => CreateCategoryPageCubit()),
          BlocProvider<CategoryCubit>(create: (context) => CategoryCubit())
        ],
        child: HomePage(),
      ),
    );
  }
}
