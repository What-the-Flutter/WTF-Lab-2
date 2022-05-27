import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/constants.dart';
import '../utils/theme/app_theme.dart';
import '../utils/theme/theme_cubit.dart';
import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: context.read<SettingsCubit>().state.fontSize,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView(
              children: [
                _authSwitch(context),
                _bubbleAlignment(context),
                _centreDateBubble(context),
                _fontSize(context),
                _chooseBackground(context),
                _resetBackground(context),
                _shareButton(context),
                _resetButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareButton(BuildContext context) {
    return ListTile(
      key: const ValueKey('ShareButton'),
      onTap: () => context.read<SettingsCubit>().share(),
      leading: Icon(Icons.adaptive.share),
      title: Text(
        'Share with friends!',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _resetButton(BuildContext context) {
    return ListTile(
      key: const ValueKey('ResetButton'),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?', style: Theme.of(context).textTheme.bodyText1),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  BlocProvider.of<SettingsCubit>(context).resetSettings();
                  Navigator.pop(ctx);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
      leading: const Icon(
        Icons.restart_alt,
      ),
      title: Text(
        'Reset to default',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _chooseBackground(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return ListTile(
          key: const ValueKey('ChooseBackgroundButton'),
          onTap: () => context.read<SettingsCubit>().addBGImage(),
          leading: const Icon(Icons.image),
          title: Text(
            'Chat Background',
            style: TextStyle(
              fontSize: context.read<SettingsCubit>().state.fontSize,
            ),
          ),
        );
      },
    );
  }

  Widget _resetBackground(BuildContext context) {
    return ListTile(
      key: const ValueKey('ResetBgButton'),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?', style: Theme.of(context).textTheme.bodyText1),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  BlocProvider.of<SettingsCubit>(context).resetBGImage();
                  Navigator.pop(ctx);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
      leading: const Icon(
        Icons.image_not_supported,
      ),
      title: Text(
        'Reset Background',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _fontSize(BuildContext ctx) {
    return ListTile(
      key: const ValueKey('FontChangeButton'),
      onTap: () => showCupertinoModalPopup<void>(
        context: ctx,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                ctx.read<SettingsCubit>().changeFontSize(FontSizeKeys.small);
                Navigator.pop(context);
              },
              child: Text(
                'Small',
                style: TextStyle(
                  fontSize: FontSizes.fontSizes[FontSizeKeys.small],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ctx.read<SettingsCubit>().changeFontSize(FontSizeKeys.medium);
                Navigator.pop(context);
              },
              child: Text(
                'Medium',
                style: TextStyle(
                  fontSize: FontSizes.fontSizes[FontSizeKeys.medium],
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ctx.read<SettingsCubit>().changeFontSize(FontSizeKeys.large);
                Navigator.pop(context);
              },
              child: Text(
                'Large',
                style: TextStyle(
                  fontSize: FontSizes.fontSizes[FontSizeKeys.large],
                ),
              ),
            )
          ],
        ),
      ),
      leading: const Icon(Icons.text_fields),
      title: Text(
        'Font Size',
        style: TextStyle(
          fontSize: ctx.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _bubbleAlignment(BuildContext context) {
    return ListTile(
      key: const ValueKey('ChangeAlignmentButton'),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Change Bubble Alignment to:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment(true);
                },
                child: const Text('Left'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment(false);
                },
                child: const Text('Right'),
              )
            ],
          ),
        );
      },
      leading: const Icon(Icons.align_horizontal_left),
      title: Text(
        'Bubble Alignment',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _centreDateBubble(BuildContext context) {
    return ListTile(
      key: const ValueKey('ChangeDateBubbleAlignment'),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Change Date Bubble Alignment to:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<SettingsCubit>(context).changeCentreDateBubble(false);
                },
                child: const Text('Left'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  Navigator.pop(ctx);
                  BlocProvider.of<SettingsCubit>(context).changeCentreDateBubble(true);
                },
                child: const Text('Centre'),
              )
            ],
          ),
        );
      },
      leading: const Icon(Icons.wb_iridescent_rounded),
      title: Text(
        'Date Bubble Alignment',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }

  Widget _authSwitch(BuildContext context) {
    return ListTile(
      key: const ValueKey('AuthButton'),
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Enable Bio Auth?',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  BlocProvider.of<SettingsCubit>(context).changeLocalAuth(false);
                  Navigator.pop(ctx);
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: context.read<ThemeCubit>().state.colorScheme.primary),
                onPressed: () {
                  BlocProvider.of<SettingsCubit>(context).changeLocalAuth(true);
                  Navigator.pop(ctx);
                },
                child: const Text('Yes'),
              )
            ],
          ),
        );
      },
      leading: const Icon(Icons.fingerprint),
      title: Text(
        'Bio Auth',
        style: TextStyle(
          fontSize: context.read<SettingsCubit>().state.fontSize,
        ),
      ),
    );
  }
}
