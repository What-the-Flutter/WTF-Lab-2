import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../components/widgets/event_card.dart';
import '../../components/widgets/event_tile.dart';
import '../../constants/constants.dart';
import '../addEvent/add_event_screen.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_screen.dart';
import 'home_cubit.dart';

class HomeScreen extends StatelessWidget {
  final SettingsCubit settingsCubit;

  const HomeScreen({
    super.key,
    required this.settingsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => settingsCubit,
        ),
      ],
      child: Builder(
        builder: (context) {
          context.read<HomeCubit>().init();
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _Body(),
            floatingActionButton: _buildFAB(context),
            drawer: const _Drawer(),
          );
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        0,
        8,
        85,
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: const AddEventScreen(),
              duration: const Duration(
                milliseconds: 250,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 84.0,
      actions: [
        Center(
          child: Text(
            'Home',
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: AppPadding.kBigPadding)
      ],
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.kMediumPadding,
            vertical: AppPadding.kDefaultPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRight,
                      child: SettingsScreen(
                        settingsCubit: context.read<SettingsCubit>(),
                      ),
                      duration: const Duration(
                        milliseconds: 250,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                label: const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
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
  final pageController = PageController();
  _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        BlocListener<HomeCubit, HomeState>(
          listenWhen: (prev, curr) {
            if (prev.selectedItemInNavBar != curr.selectedItemInNavBar) {
              pageController.animateToPage(
                curr.selectedItemInNavBar,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              return true;
            } else {
              return false;
            }
          },
          listener: (context, state) {},
          child: PageView(
            controller: pageController,
            onPageChanged: (value) =>
                context.read<HomeCubit>().selectPage(value),
            children: [
              _HomePage(),
              Container(
                key: const ValueKey('Daily'),
                color: Colors.cyan,
                child: const Center(
                  child: Text('Daily'),
                ),
              ),
              Container(
                key: const ValueKey('Timeline'),
                color: Colors.amber,
                child: const Center(
                  child: Text('Timeline'),
                ),
              ),
              Container(
                key: const ValueKey('Explore'),
                color: Colors.yellow,
                child: const Center(
                  child: Text('Explore'),
                ),
              ),
            ],
          ),
        ),
        _BottomNavBar()
      ],
    );
  }

  Future animateToPage(HomeState state) async {
    await pageController.animateToPage(
      state.selectedItemInNavBar,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    print(state.selectedItemInNavBar);
  }
}

class _HomePage extends StatelessWidget {
  final EdgeInsets honestPadding = const EdgeInsets.fromLTRB(
    AppPadding.kBigPadding,
    AppPadding.kSmallPadding,
    AppPadding.kSmallPadding,
    AppPadding.kSmallPadding,
  );
  final EdgeInsets oddPadding = const EdgeInsets.fromLTRB(
    AppPadding.kSmallPadding,
    AppPadding.kSmallPadding,
    AppPadding.kBigPadding,
    AppPadding.kSmallPadding,
  );
  _HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              state.favoriteEvents.isEmpty
                  ? const SizedBox()
                  : _buildFavoriteBlock(context, state),
              _buildLatestBlock(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoriteBlock(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppPadding.kBigPadding),
          child: _buildHomePageTitle(
            context,
            text: 'Favorite',
          ),
        ),
        const SizedBox(height: AppPadding.kSmallPadding),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.kBigPadding,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppPadding.kMediumPadding,
              crossAxisSpacing: AppPadding.kMediumPadding,
            ),
            itemCount: state.favoriteEvents.length,
            itemBuilder: (context, index) {
              var event = state.favoriteEvents[index];
              return EventCard(
                event: event,
              );
            },
          ),
        ),
        const SizedBox(height: AppPadding.kBigPadding),
      ],
    );
  }

  Column _buildLatestBlock(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppPadding.kBigPadding),
          child: _buildHomePageTitle(
            context,
            text: 'Latest',
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: state.events.length,
          itemBuilder: (context, index) {
            return EventTile(
              event: state.events[index],
            );
          },
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Text _buildHomePageTitle(
    BuildContext context, {
    required String text,
  }) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 24,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  _BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.kBigPadding,
          0,
          AppPadding.kBigPadding,
          AppPadding.kDefaultPadding,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppPadding.kDefaultPadding),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return NavigationBar(
                backgroundColor: Colors.transparent,
                selectedIndex: state.selectedItemInNavBar,
                animationDuration: const Duration(milliseconds: 400),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: (selectedIndex) {
                  context.read<HomeCubit>().selectPage(selectedIndex);
                },
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 36.0,
                    ),
                    selectedIcon: Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.onSecondary,
                      size: 24.0,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.event_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 36.0,
                    ),
                    selectedIcon: Icon(
                      Icons.event,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    label: 'Daily',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.timeline_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 36.0,
                    ),
                    selectedIcon: Icon(
                      Icons.timeline,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    label: 'Timeline',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.explore_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 36.0,
                    ),
                    selectedIcon: Icon(
                      Icons.explore_outlined,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    label: 'Explore',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
