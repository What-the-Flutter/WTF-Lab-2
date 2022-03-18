import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/event_categyory.dart';
import 'ui/theme/inherited_widget.dart';
import 'ui/theme/theme_data.dart';
import 'ui/widgets/home_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryList(),
        )
      ],
      child: const CustomTheme(
        initialThemeKey: MyThemeKeys.light,
        child: Journal(),
      ),
    ),
  );
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
