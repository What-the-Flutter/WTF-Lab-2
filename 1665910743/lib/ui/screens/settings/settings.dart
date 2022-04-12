import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../constants.dart';
import '../../theme/font_cubit/font_cubit.dart';
import '../../theme/theme_cubit/theme_cubit.dart';
import '../../theme/theme_data.dart';
import '../home/cubit/home_cubit.dart';
import 'cubit/settings_cubit.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state == MyThemes.darkTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: kListViewPadding,
        child: ListView(
          children: [
            _nightSide(context, theme),
            _authSwitch(context),
            _bubbleAlignment(context),
            _fontSize(context),
            _chooseBackground(context),
            _shareButton(context),
            _resetButton(context),
          ],
        ),
      ),
    );
  }

  Widget _shareButton(BuildContext context) {
    return ListTile(
      onTap: (() {
        Share.share('check out my App!');
      }),
      leading:   Icon(Icons.adaptive.share),
      title: GradientText(
        'Share with friends!',
        style: Theme.of(context).textTheme.bodyText1,
        colors: [
          Colors.red,
          Colors.purple,
          Colors.lightBlue,
          Colors.green,
          Colors.yellow
        ],
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return ListTile(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Are you sure?',
                      style: Theme.of(context).textTheme.bodyText1),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        context.read<FontCubit>().fontChange(MyFontSize.medium);
                        context.read<SettingsCubit>().alignmentLeft();
                        context
                            .read<ThemeCubit>()
                            .themeChanged(MyThemeKeys.light);
                        context.read<HomeCubit>().setAuthKey(false);
                        context.read<SettingsCubit>().removeBackrgoundImage();
                        Navigator.pop(context);
                      },
                      child: const Text('Yes'),
                    )
                  ],
                ));
      },
      leading: const Icon(
        Icons.restart_alt,
        color: Colors.redAccent,
      ),
      title: Text(
        'Reset to default',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _chooseBackground(BuildContext context) {
    return ListTile(
      onTap: () => context.read<SettingsCubit>().getBackgroundImage(),
      leading: const Icon(Icons.image),
      title:
          Text('Chat Background', style: Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget _fontSize(context) {
    return ListTile(
      onTap: (() => showCupertinoModalPopup<void>(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    context.read<FontCubit>().fontChange(MyFontSize.small);
                    Navigator.pop(context);
                  },
                  child: Text('Small', style: FontSize.small.bodyText1),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    context.read<FontCubit>().fontChange(MyFontSize.medium);
                    Navigator.pop(context);
                  },
                  child: Text('Medium', style: FontSize.medium.bodyText1),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    context.read<FontCubit>().fontChange(MyFontSize.large);
                    Navigator.pop(context);
                  },
                  child: Text('Lagre', style: FontSize.large.bodyText1),
                )
              ],
            ),
          )),
      leading: const Icon(Icons.text_fields),
      title: Text(
        'Font Size',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _bubbleAlignment(BuildContext context) {
    return ListTile(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Change Bubble Alignment to:',
                      style: Theme.of(context).textTheme.bodyText1),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsCubit>().alignmentLeft();
                      },
                      child: const Text('Left'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<SettingsCubit>().alignmentRight();
                      },
                      child: const Text('Right'),
                    )
                  ],
                ));
      },
      leading: const Icon(Icons.align_horizontal_left),
      title: Text(
        'Bubble Alignment',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _nightSide(BuildContext context, bool theme) {
    return ListTile(
      leading: const Icon(Icons.sunny),
      title: Text(
        'Night Side',
        style: Theme.of(context).textTheme.bodyText1,
      ),
      trailing: Switch.adaptive(
          activeColor: Theme.of(context).primaryColor,
          value: theme,
          onChanged: (value) {
            value
                ? context.read<ThemeCubit>().themeChanged(MyThemeKeys.dark)
                : context.read<ThemeCubit>().themeChanged(MyThemeKeys.light);
          }),
    );
  }

  Widget _authSwitch(BuildContext context) {
    return ListTile(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Enable Bio Auth?',
                      style: Theme.of(context).textTheme.bodyText1),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<HomeCubit>().setAuthKey(false);
                      },
                      child: const Text('no'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<HomeCubit>().setAuthKey(true);
                      },
                      child: const Text('Yes'),
                    )
                  ],
                ));
      },
      leading: const Icon(Icons.fingerprint),
      title: Text(
        'Bio Auth',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
