import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../category_page/category_cubit.dart';
import '../category_page/category_page.dart';
import '../create_category_page/create_category_cubit.dart';
import '../create_category_page/create_category_page.dart';
import '../models/category.dart';
import '../utils/app_theme.dart';
import '../widgets/main_page_widgets/main_bottom_bar.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                expandedHeight: 190,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
                title: const Center(
                  child: Text('Home'),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.invert_colors),
                    onPressed: () =>
                        InheritedCustomTheme.of(context).themeData == AppTheme.lightTheme
                            ? InheritedCustomTheme.of(context).switchTheme(ThemeKeys.dark)
                            : InheritedCustomTheme.of(context).switchTheme(ThemeKeys.light),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: (InheritedCustomTheme.of(context).themeData == AppTheme.lightTheme)
                      ? Image.asset(
                          'assets/images/app_bar_bg_light.jpg',
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          'assets/images/app_bar_bg_dark.png',
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => _categoryCard(state.categories[index], index, state),
                  childCount: state.categories.length,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createPage,
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: const MainBottomBar(),
        );
      },
    );
  }

  void _createPage() async {
    final category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<CreateCategoryPageCubit>(context),
          child: CreateCategoryPage(),
        ),
      ),
    );
    if (category is Category && mounted) {
      BlocProvider.of<HomeCubit>(context).addCategory(category);
    }
  }

  Padding _categoryCard(Category category, int index, HomeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Card(
        color: InheritedCustomTheme.of(context).themeData.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: category.icon,
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              category.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          subtitle: const Text('No events. Click to create one'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: BlocProvider.of<CategoryCubit>(context),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<HomeCubit>(context),
                    ),
                  ],
                  child: CategoryPage(
                    category: category,
                  ),
                ),
              ),
            );
            setState(() {});
          },
          onLongPress: () => _showModalBottomActions(context, index, state),
        ),
      ),
    );
  }

  Future<dynamic> _showModalBottomActions(BuildContext ctx, int index, HomeState state) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.centerLeft,
        height: 300,
        child: Column(
          children: [
            ListTile(
              onTap: () => infoDialog(context, index, state),
              leading: const Icon(
                Icons.info,
                color: Colors.green,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: () => {},
              leading: const Icon(
                Icons.push_pin_outlined,
                color: Colors.green,
              ),
              title: const Text('Pin/Unpin Page'),
            ),
            const ListTile(
              leading: Icon(
                Icons.archive,
                color: Colors.yellow,
              ),
              title: Text('Archive Page'),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
              onTap: () => _editPage(index, state),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
              onTap: () {
                Navigator.pop(context);
                _showModalBottomDeleteSheet(ctx, index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editPage(int index, HomeState state) async {
    Navigator.pop(context);
    final category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<CreateCategoryPageCubit>(context),
          child: CreateCategoryPage(editCategory: state.categories[index]),
        ),
      ),
    );
    if (category is Category) {
      BlocProvider.of<HomeCubit>(context).editCategory(
        index,
        category,
      );
    }
  }

  Future<dynamic> _showModalBottomDeleteSheet(BuildContext ctx, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        height: 190,
        child: Column(
          children: [
            const Text(
              'Delete Page?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Text(
              'Are you sure you want to delete this page?',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Entries of this page will still be accessible in the timeline',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () {
                        BlocProvider.of<HomeCubit>(ctx).deleteCategory(index);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> infoDialog(BuildContext context, int index, HomeState state) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CircleAvatar(
            child: state.categories[index].icon,
            backgroundColor: Colors.grey,
          ),
          title: Text(state.categories[index].title),
        ),
        content: SizedBox(
          height: 150,
          child: Expanded(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Created'),
                  subtitle: Text(
                    DateFormat()
                        .add_jms()
                        .format(state.categories[index].timeOfCreation)
                        .toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
