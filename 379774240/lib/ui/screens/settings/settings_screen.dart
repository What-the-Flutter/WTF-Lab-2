import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import '../../constants/constants.dart';
import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsCubit settingsCubit;

  const SettingsScreen({
    super.key,
    required this.settingsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => settingsCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: const _Body(),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 84.0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onBackground,
          size: 36,
        ),
      ),
      title: Text(
        'Settings',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 30,
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        var cubit = context.read<SettingsCubit>();
        return SingleChildScrollView(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  'Dark Theme',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
                ),
                value: state.isDarkTheme,
                onChanged: (onChanged) {
                  cubit.swithTheme();
                },
              ),
              SwitchListTile(
                title: Text(
                  'Align messages to the left',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
                ),
                value: state.isMessageLeftAlign,
                onChanged: (onChanged) {
                  cubit.alignMessageLeft();
                },
              ),
              SwitchListTile(
                title: Text(
                  'Hide date bubble',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 18,
                  ),
                ),
                value: state.isDateBubbleHiden,
                onChanged: (onChanged) {
                  cubit.hideDateBublle();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.kDefaultPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Message font size',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 18,
                      ),
                    ),
                    const _SliderFontSize(),
                  ],
                ),
              ),
              Padding(
                key: UniqueKey(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.kDefaultPadding,
                ),
                child: InkWell(
                  onTap: () {
                    cubit.setDefaultSettings();
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppPadding.kSmallPadding),
                    ),
                    child: Center(
                      child: Text(
                        'Set default settings',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                key: UniqueKey(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.kDefaultPadding,
                  vertical: AppPadding.kMediumPadding,
                ),
                child: InkWell(
                  onTap: _shareApp,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppPadding.kSmallPadding),
                    ),
                    child: Center(
                      child: Text(
                        'Share app',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _shareApp() async {
    await FlutterShare.share(
      title: 'Example share',
      text: 'Share app with other people',
      linkUrl: 'https://google.com',
      chooserTitle: 'Example Chooser Title',
    );
  }
}

class _SliderFontSize extends StatefulWidget {
  const _SliderFontSize({super.key});

  @override
  State<_SliderFontSize> createState() => _SliderFontSizeState();
}

class _SliderFontSizeState extends State<_SliderFontSize> {
  late double index;

  @override
  Widget build(BuildContext context) {
    final labels = ['16', '18', '20'];
    final min = .0;
    final max = labels.length - 1.0;
    final divisions = labels.length - 1;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        switch (state.fontSize.round()) {
          case 16:
            index = .0;
            break;
          case 18:
            index = 1.0;
            break;
          case 20:
            index = 2.0;
            break;
          default:
            index = .0;
            break;
        }

        return Container(
          width: 180,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.kDefaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    labels.length,
                    (index) => Text(
                      labels[index],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Slider(
                value: index,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: (value) {
                  setState(() => index = value);
                  context.read<SettingsCubit>().setFontSize(index.round());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
