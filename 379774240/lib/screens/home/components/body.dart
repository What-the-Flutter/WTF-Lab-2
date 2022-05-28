import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants.dart';
import '../../../inherited/app_state.dart';
import '../../addCategory/add_category_screen.dart';
import '../../addEvent/add_event_screen.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final categories = StateInheritedWidget.of(context).state.categories;

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Slidable(
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                icon: Icons.favorite_outline,
                label: 'Favorite',
              ),
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                icon: Icons.archive,
                label: 'Archive',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  _editCategoryWithFetchedData(context, 'Edit a category',
                      categories[index].title, index);
                },
                backgroundColor: Theme.of(context).colorScheme.surface,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) {
                  setState(() {
                    categories.removeAt(index);
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 4,
              horizontal: kDefaultPadding / 4,
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventScreen(categoryIndex: index),
                  ),
                );
              },
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Icon(
                    categories[index].icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ),
              title: Text(
                categories[index].title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                categories[index].subtitle,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _editCategoryWithFetchedData(BuildContext context, String title,
      String hintTetx, int categoryInedx) async {
    final state = StateInheritedWidget.of(context);
    final List result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(
          title: title,
          hintTetx: hintTetx,
        ),
      ),
    );
    setState(() {
      state.editCategory(result[0], result[1], categoryInedx);
    });
  }
}
