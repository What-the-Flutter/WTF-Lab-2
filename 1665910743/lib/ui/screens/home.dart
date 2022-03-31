import 'package:flutter/material.dart';

import '../widgets/unpined_list.dart';

class HomeScreen extends StatelessWidget {
  static const title = 'Home';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UnpinedCategory();
  }
}
