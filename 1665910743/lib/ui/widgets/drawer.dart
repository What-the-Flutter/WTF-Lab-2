import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../cubit/category_cubit/category_list_cubit.dart';
import '../../cubit/theme_cubit/theme_cubit.dart';
import '../theme/theme_data.dart';

class JourneyDrawer extends StatefulWidget {
  const JourneyDrawer({Key? key}) : super(key: key);

  @override
  State<JourneyDrawer> createState() => _JourneyDrawerState();
}

class _JourneyDrawerState extends State<JourneyDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state == MyThemes.darkTheme;
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [_header(context), _body(context, theme)],
      ),
    );
  }

  Widget _body(BuildContext context, bool theme) {
    var authValue = context.watch<CategoryListCubit>().state.authKey;

    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Enable Bio auth'),
              Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: authValue!,
                  onChanged: (value) async {
                    context.read<CategoryListCubit>().setAuthKey(value);
                    context.read<CategoryListCubit>().getAuthKey();
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Night Side'),
              Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: theme,
                  onChanged: (value) {
                    setState(() {
                      value
                          ? context
                              .read<ThemeCubit>()
                              .themeChanged(MyThemeKeys.dark)
                          : context
                              .read<ThemeCubit>()
                              .themeChanged(MyThemeKeys.light);
                    });
                  }),
            ],
          ),
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
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  DateFormat.yMMMMd()
                      .format(
                        DateTime.now(),
                      )
                      .toString(),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
