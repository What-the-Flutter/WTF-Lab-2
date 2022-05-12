import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/category_list.dart';
import '../widgets/category_item.dart';
import 'create_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _editController = TextEditingController();

  Future<void> categoryInfo(int index) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(
              categoryList[index].icon,
              size: 25.0,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          title: Text(
            categoryList[index].name,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                'Created',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: Text(
                DateFormat('yyyy MMMM dd  hh:mm aaa').format(
                  DateTime.now(),
                ),
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            ListTile(
              title: Text(
                'Last event',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              subtitle: Text(
                categoryList[index].events.isEmpty
                    ? 'No events'
                    : categoryList[index].events.last,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> editCategory(int index) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit'),
          content: TextField(controller: _editController),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => categoryList[index].name = _editController.text);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void deleteCategory(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Category ${categoryList[index].name} deleted',
        ),
      ),
    );
    setState(() => categoryList.removeAt(index));
  }

  void pinUnpinCategory(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category ${categoryList[index].name}'
            '${categoryList[index].pinned ? ' unpinned' : ' pinned'}'),
      ),
    );

    categoryList[index].pinned = !categoryList[index].pinned;

    if (categoryList[index].pinned) {
      setState(() {
        categoryList.insert(0, categoryList[index]);
        categoryList.removeAt(index + 1);
      });
    } else {
      setState(
        () {
          categoryList.add(categoryList[index]);
          categoryList.removeAt(index);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        itemCount: categoryList.length,
        separatorBuilder: (_, index) => const Divider(),
        itemBuilder: (_, index) {
          return CategoryItem(
            index,
            (_selectedIndex) {
              Scaffold.of(context).showBottomSheet(
                (context) {
                  return Container(
                    color: Theme.of(context).canvasColor,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.info, color: Colors.green),
                          title: const Text('Info'),
                          onTap: () {
                            Navigator.pop(context);
                            categoryInfo(_selectedIndex);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.edit, color: Colors.yellow),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            editCategory(_selectedIndex);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            deleteCategory(_selectedIndex);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.push_pin,
                              color: Colors.lightGreen),
                          title: const Text('Pin/Unpin'),
                          onTap: () {
                            Navigator.pop(context);
                            pinUnpinCategory(_selectedIndex);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.close, color: Colors.red),
                          title: const Text('Close'),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreateCategoryScreen(),
            ),
          );
        },
        tooltip: 'Add category',
      ),
    );
  }
}
