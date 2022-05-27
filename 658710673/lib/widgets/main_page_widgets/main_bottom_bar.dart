import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../category_page/category_cubit.dart';
import '../../create_category_page/create_category_cubit.dart';
import '../../filters_page/filters_cubit.dart';
import '../../home_page/home_cubit.dart';
import '../../home_page/home_page.dart';
import '../../settings_page/settings_cubit.dart';
import '../../timeline_page/timeline_page.dart';
import '../../utils/theme/theme_cubit.dart';

class MainBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: context.read<HomeCubit>().state.currTabIndex,
      onTap: (index) {
        final pages = [
          HomePage(),
          HomePage(),
          const TimelinePage(),
          HomePage(),
        ];
        if (context.read<HomeCubit>().state.currTabIndex != index) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 700),
              transitionsBuilder: (ctx, animation, secondaryAnimation, child) =>
                  SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              ),
              pageBuilder: (ctx, animation, secondaryAnimation) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: BlocProvider.of<CategoryCubit>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<CreateCategoryPageCubit>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<HomeCubit>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<ThemeCubit>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<SettingsCubit>(context),
                  ),
                  BlocProvider.value(
                    value: BlocProvider.of<FiltersPageCubit>(context),
                  ),
                ],
                child: pages[index],
              ),
            ),
          );
        }
        context.read<HomeCubit>().setSelectedTab(index);
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
    );
  }
}
