import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../cubit/home/home_cubit.dart';
import '../../../data/categories_repository.dart';
import '../../../data/models/category.dart';
import '../../../inherited/app_theme.dart';
import '../../constants/constants.dart';
import '../category/add_category_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  EmulatorCategoriesRepository emulatorCategoriesRepository =
      EmulatorCategoriesRepository();

  List<Widget> pages = const [
    Text('Home'),
    Text('Daily'),
    Text('Timeline'),
    Text('Explore'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(emulatorCategoriesRepository),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: _buildAppBar(),
          body:
              _Body(emulatorCategoriesRepository: emulatorCategoriesRepository),
          floatingActionButton: _buildFloatingActionButton(context),
          bottomNavigationBar: _buildNavBar(),
        );
      }),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _createCategoryWithFetchedData(context, 'Create a new category');
      },
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      title: pages[currentPage],
      actions: [
        IconButton(
          onPressed: () => AppThemeInheritedWidget.of(context).swichTheme(),
          icon: Icon(
            Icons.invert_colors,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }

  NavigationBar _buildNavBar() {
    return NavigationBar(
      selectedIndex: currentPage,
      animationDuration: const Duration(milliseconds: 400),
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: (newIndex) {
        setState(() {
          currentPage = newIndex;
        });
      },
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Daily',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.timeline,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.timeline,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Timeline',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.explore,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.explore,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          label: 'Explore',
        ),
      ],
    );
  }

  Future<void> _createCategoryWithFetchedData(
      BuildContext context, String title) async {
    final Category category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(title: title),
      ),
    );

    context.read<HomeCubit>().addCategory(category);
  }
}

class _Body extends StatefulWidget {
  final EmulatorCategoriesRepository emulatorCategoriesRepository;
  const _Body({super.key, required this.emulatorCategoriesRepository});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchCategories();
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) {
        if (state is HomeLoadedData) {
          return _buildListView(state);
        } else if (state is HomeError) {
          return _buildErrorScreen(state);
        } else if (state is HomeInitial) {
          return Center(child: Text(state.title));
        } else {
          return const Center(child: Text('loading data'));
        }
      },
    );
  }

  Widget _buildErrorScreen(HomeError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            state.errorMessage,
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () {
              context.read<HomeCubit>().fetchCategories();
            },
            icon: const Icon(
              Icons.refresh_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(HomeLoadedData state) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, state.categories[index], index,
              state.categories[index].title);
        },
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, Category category, int index, String stitie) {
    return Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.only(
        bottom: AppPadding.kMediumPadding,
      ),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<HomeCubit>().likeCategory(index);
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              icon: Icons.favorite_outline,
            ),
            SlidableAction(
              onPressed: (_) {},
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              icon: Icons.archive,
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.35,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              icon: Icons.edit,
            ),
            SlidableAction(
              onPressed: (_) {
                context.read<HomeCubit>().removeCategory(index);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              icon: Icons.delete,
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  title: stitie,
                  categoryIndex: index,
                  eventList: category.events,
                ),
              ),
            );
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              category.iconData,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          title: Text(
            category.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          subtitle: Text(
            category.subtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          trailing: category.isFavorive
              ? Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.error,
                )
              : const SizedBox(width: 1),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await context.read<HomeCubit>().fetchCategories();
  }

  Future<void> _editCategoryWithFetchedData(BuildContext context, String title,
      String hintTetx, int categoryInedx) async {
    final Category category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(
          title: title,
          hintTetx: hintTetx,
        ),
      ),
    );

    context.read<HomeCubit>().editCategory(categoryInedx, category);
  }
}
