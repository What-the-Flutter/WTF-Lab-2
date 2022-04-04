import 'package:flutter/material.dart';

import '../../data/category_list.dart';
import '../widgets/list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10.0),
      itemCount: categoryList.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) {
        return ListItem(index);
      },
    );
  }
}
