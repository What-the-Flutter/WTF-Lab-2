import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../settings_page/settings_cubit.dart';
import '../../settings_page/settings_page.dart';
import '../../statistics/summary_statistics_page/summary_statistics_cubit.dart';
import '../../statistics/summary_statistics_page/summary_statistics_page.dart';
import '../../utils/theme/theme_cubit.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.read<ThemeCubit>().state.colorScheme.secondary,
      child: ListView(
        children: [
          SizedBox(
            height: 145,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: context.read<ThemeCubit>().state.colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  DateFormat.yMMMMd().format(DateTime.now()).toString(),
                  style: TextStyle(
                    fontSize: context.read<SettingsCubit>().state.fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Search',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            leading: const Icon(Icons.search),
          ),
          ListTile(
            title: Text(
              'Notifications',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            leading: const Icon(Icons.notifications),
          ),
          ListTile(
            title: Text(
              'Statistics',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            leading: const Icon(Icons.timeline),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: BlocProvider.of<StatisticsCubit>(context),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<ThemeCubit>(context),
                    ),
                  ],
                  child: StatisticsPage(),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            leading: const Icon(Icons.settings),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: BlocProvider.of<SettingsCubit>(context),
                    ),
                    BlocProvider.value(
                      value: BlocProvider.of<ThemeCubit>(context),
                    ),
                  ],
                  child: const SettingsPage(),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Feedback',
              style: TextStyle(
                fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            leading: const Icon(Icons.mail),
          ),
        ],
      ),
    );
  }
}
