import 'package:flutter/material.dart';

import '../../data/category_list.dart';
import '../../models/category.dart';

class CreateCategoryScreen extends StatefulWidget {
  CreateCategoryScreen({Key? key}) : super(key: key);

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final Color _selectedColor = Colors.indigo;
  final _controller = TextEditingController();
  IconData? _selectedIcon;

  final List<IconData> _icons = const <IconData>[
    Icons.ac_unit_outlined,
    Icons.access_alarm_rounded,
    Icons.qr_code,
    Icons.wallet_giftcard,
    Icons.edgesensor_high,
    Icons.radio,
    Icons.face,
    Icons.tab,
    Icons.yard,
    Icons.umbrella,
    Icons.ice_skating,
    Icons.offline_bolt,
    Icons.pages,
    Icons.dangerous,
    Icons.book, 
    Icons.sports_soccer
  ];

  void addNewCategory() {
    categoryList.add(
      Category(
        id: 'ct${categoryList.length + 1}',
        name: _controller.text,
        icon: _selectedIcon!,
        events: [],
        pinned: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Text(
              'Create a new category',
              style: Theme.of(context).textTheme.headline5,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter name of category',
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.4,
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(
                  _icons.length,
                  (index) {
                    return IconButton(
                      onPressed: () {
                        _selectedIcon = _icons[index];
                        setState(() {});
                      },
                      icon: Icon(_icons[index]),
                      color: _selectedIcon == _icons[index]
                          ? Colors.amber
                          : Colors.grey[700],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: (_controller.text != '' && _selectedIcon != null)
            ? const Icon(Icons.check)
            : const Icon(Icons.close),
        onPressed: (_controller.text != '' && _selectedIcon != null)
            ? () => {
                  addNewCategory(),
                  Navigator.pop(context),
                }
            : () => Navigator.pop(context),
      ),
    );
  }
}
