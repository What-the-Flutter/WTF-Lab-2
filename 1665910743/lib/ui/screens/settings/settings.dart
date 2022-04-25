import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../../../constants.dart' as constants;
import '../../theme/font_cubit/font_cubit.dart';
import '../../theme/theme_cubit/theme_cubit.dart';
import '../../theme/theme_data.dart';
import '../home/cubit/home_cubit.dart';
import 'cubit/settings_cubit.dart';

class Settings extends StatelessWidget {
  final ThemeCubit themeCubit;
  final HomeCubit homeCubit;
  final SettingsCubit settingsCubit;
  final FontCubit fontCubit;

  const Settings(
      {Key? key,
      required this.themeCubit,
      required this.homeCubit,
      required this.settingsCubit,
      required this.fontCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: constants.listViewPadding,
        child: ListView(
          children: [
            _nightSide(context),
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
      key: const ValueKey('ShareButton'),
      onTap: (() {
        Share.share('check out my App!');
      }),
      leading: Icon(Icons.adaptive.share),
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
      key: const ValueKey('ResetButton'),
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
                        fontCubit.fontChange(MyFontSize.medium);
                        settingsCubit.alignmentLeft();
                        themeCubit.themeChanged(MyThemeKeys.light);
                        homeCubit.setAuthKey(false);
                        settingsCubit.removeBackrgoundImage();
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
      key: const ValueKey('ChooseBackgroundButton'),
      onTap: settingsCubit.getBackgroundImage,
      leading: const Icon(Icons.image),
      title: Text(
        'Chat Background',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }

  Widget _fontSize(context) {
    return ListTile(
      key: const ValueKey('FontChangeButton'),
      onTap: (() => showCupertinoModalPopup<void>(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    fontCubit.fontChange(MyFontSize.small);
                    Navigator.pop(context);
                  },
                  child: Text('Small', style: FontSize.small.bodyText1),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    fontCubit.fontChange(MyFontSize.medium);
                    Navigator.pop(context);
                  },
                  child: Text('Medium', style: FontSize.medium.bodyText1),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    fontCubit.fontChange(MyFontSize.large);
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
      key: const ValueKey('ChangeAlignmentButton'),
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
                        settingsCubit.alignmentLeft();
                      },
                      child: const Text('Left'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        settingsCubit.alignmentRight();
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

  Widget _nightSide(BuildContext context) {
    final theme = themeCubit.state == MyThemes.darkTheme;

    return ListTile(
      key: const ValueKey('NightSideButton'),
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
                ? themeCubit.themeChanged(MyThemeKeys.dark)
                : themeCubit.themeChanged(MyThemeKeys.light);
          }),
    );
  }

  Widget _authSwitch(BuildContext context) {
    return ListTile(
      key: const ValueKey('AuthButton'),
      onTap: () {
        showDialog(
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
                        homeCubit.setAuthKey(false);
                      },
                      child: const Text('no'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                        homeCubit.setAuthKey(true);
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
