// ignore_for_file: prefer_relative_imports

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_journal/ui/screens/Category_Screen/cubit/category_cubit.dart';

import '../screens/chat_screen/cubit/event_cubit.dart';
import '../screens/home/cubit/home_cubit.dart';
import '../screens/settings/cubit/settings_cubit.dart';
import '../screens/settings/settings.dart';
import '../screens/stats.dart/stats_screen.dart';
import '../theme/font_cubit/font_cubit.dart';
import '../theme/theme_cubit/theme_cubit.dart';

class JourneyDrawer extends StatelessWidget {
  const JourneyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      child: Column(
        children: [_header(context), _body(context)],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((_) => Settings(
                        themeCubit: context.read<ThemeCubit>(),
                        homeCubit: context.read<HomeCubit>(),
                        settingsCubit: context.read<SettingsCubit>(),
                        fontCubit: context.read<FontCubit>(),
                      )),
                ),
              );
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text(
              'Settings',
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((_) => StatsScreen(
                        categoryCubit: context.read<CategoryCubit>(),
                        eventCubit: context.read<EventCubit>(),
                      )),
                ),
              );
            },
            leading: Icon(
              Icons.pie_chart,
              color: Theme.of(context).primaryColor,
            ),
            title: const Text(
              'Statistics',
            ),
          )
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Journal',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                Text(
                  DateFormat.yMMMMd()
                      .format(
                        DateTime.now(),
                      )
                      .toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
