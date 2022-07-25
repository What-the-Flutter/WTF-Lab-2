import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../constants/constants.dart';
import '../../themes/theme_controller_cubit.dart';
import '../addEvent/event_screen.dart';
import '../chat/chat_screen.dart';
import '../settings/settings_screen.dart';
import 'home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(),
      child: Builder(builder: (context) {
        context.read<HomeCubit>().init();
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _Body(pageController: pageController),
          bottomNavigationBar: _BottomNavBar(pageController: pageController),
          floatingActionButton: _buildFAB(),
          drawer: const _NavigationDrawer(),
        );
      }),
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(),
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: ((previous, current) =>
            previous.pageController.currentPage !=
            current.pageController.currentPage),
        builder: (context, state) {
          return Text(
            state.pageController.pages[state.pageController.currentPage],
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<ThemeControllerCubit>().swithTheme();
          },
          icon: const Icon(Icons.invert_colors),
        )
      ],
    );
  }
}

class _NavigationDrawer extends StatelessWidget {
  const _NavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.kBigPadding,
            AppPadding.kBigPadding,
            0,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const SettingsScreen())),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 26,
                    ),
                    const SizedBox(width: AppPadding.kDefaultPadding),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PageController pageController;
  const _Body({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: ((previous, current) {
        return previous.pageController.currentPage !=
            current.pageController.currentPage;
      }),
      builder: (context, state) {
        return PageView(
          controller: pageController,
          onPageChanged: (newIndex) {
            context.read<HomeCubit>().changePage(newIndex);
          },
          children: [
            const _HomeListView(key: ValueKey('Home')),
            Container(
              key: const ValueKey('Daily'),
              color: Colors.cyan,
              child: Center(
                child: Text(
                  state.pageController.pages[1],
                ),
              ),
            ),
            Container(
              key: const ValueKey('Timeline'),
              color: Colors.amber,
              child: Center(
                child: Text(
                  state.pageController.pages[2],
                ),
              ),
            ),
            Container(
              key: const ValueKey('Explore'),
              color: Colors.yellow,
              child: Center(
                child: Text(
                  state.pageController.pages[3],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final PageController pageController;

  const _BottomNavBar({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return NavigationBar(
          selectedIndex: state.pageController.currentPage,
          animationDuration: const Duration(milliseconds: 400),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (selectedIndex) {
            context.read<HomeCubit>().changePage(selectedIndex);
            pageController.animateToPage(
              selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeIn,
            );
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
      },
    );
  }
}

class _HomeListView extends StatelessWidget {
  const _HomeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.events != current.events,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () {
            return _refresh(context);
          },
          child: ListView.builder(
            itemCount: state.events.length,
            itemBuilder: (context, index) {
              return Padding(
                key: ValueKey(state.events[index].title),
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
                          context.read<HomeCubit>().likeEvent(
                                index,
                                state.events[index].id,
                              );
                        },
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSecondary,
                        icon: state.events[index].isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                      ),
                      SlidableAction(
                        onPressed: (_) {
                          //TODO complete
                        },
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        icon: Icons.done,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    extentRatio: 0.35,
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventScreen(
                                eventIndex: index,
                                title: 'Edit ${state.events[index].title}',
                                eventTitle: state.events[index].title,
                              ),
                            ),
                          );
                        },
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        icon: Icons.edit,
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          context
                              .read<HomeCubit>()
                              .removeEvent(state.events[index].id);
                        },
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      context
                          .read<HomeCubit>()
                          .setAppState(state.events[index].id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            eventIndex: index,
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
                        state.events[index].iconData,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    title: Text(
                      state.events[index].title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      state.events[index].subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    trailing: state.events[index].isFavorite
                        ? Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.secondary,
                          )
                        : const SizedBox(width: 0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _refresh(BuildContext context) async {
    await context.read<HomeCubit>().init();
  }
}
