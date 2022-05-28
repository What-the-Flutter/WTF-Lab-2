import 'package:flutter/material.dart';

import '../../constants.dart';

class AddCategoryScreen extends StatefulWidget {
  final String title;
  final String hintTetx;

  const AddCategoryScreen({
    super.key,
    required this.title,
    this.hintTetx = 'Category name',
  });
  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _controller = TextEditingController();
  final List categoryIocns = <IconData>[
    Icons.search,
    Icons.home,
    Icons.shopping_cart,
    Icons.delete,
    Icons.description,
    Icons.lightbulb,
    Icons.paid,
    Icons.article,
    Icons.emoji_events,
    Icons.sports_esports,
    Icons.fitness_center,
    Icons.work_outline,
    Icons.spa,
    Icons.celebration,
    Icons.payment,
    Icons.pets,
    Icons.account_balance,
    Icons.savings,
    Icons.family_restroom,
    Icons.crib,
    Icons.music_note,
    Icons.local_bar,
  ];

  int? selectedIconIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding,
          horizontal: kDefaultPadding * 2,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: widget.hintTetx,
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                ),
                itemCount: categoryIocns.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedIconIndex == index) {
                          selectedIconIndex = null;
                        } else {
                          selectedIconIndex = index;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedIconIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Icon(
                          categoryIocns[index],
                          color: selectedIconIndex == index
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (takeData() == null) {
            final snackBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: const Text('Fill in all fields of the form'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            Navigator.pop(context, takeData());
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  List? takeData() {
    if (selectedIconIndex != null && _controller.text != '') {
      return [
        _controller.text,
        categoryIocns[selectedIconIndex!],
      ];
    }
    return null;
  }
}
