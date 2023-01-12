import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_cubit/settings_cubit.dart';
import 'theme.dart';

class GeneralSettingsView extends StatefulWidget {
  const GeneralSettingsView({Key? key}) : super(key: key);

  @override
  State<GeneralSettingsView> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  bool alignment = false;
  bool dateBubbleAlignment = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.read<SettingsCubit>().state;
    alignment = settings.bubbleAlignment == BubbleAlignment.left ? false : true;
    dateBubbleAlignment = settings.isCenterDateAlignment;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: AnimatedDefaultTextStyle(
              style: getHeadLineText(
                state.textSize,
                context,
              ),
              duration: const Duration(milliseconds: 700),
              child: const Text(
                'General',
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ).copyWith(
                          color: theme.brightness == Brightness.light
                              ? theme.primaryColorDark
                              : theme.primaryColor,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Visuals',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.emoji_objects_outlined),
                      title: AnimatedDefaultTextStyle(
                        style: getTitleText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Theme',
                        ),
                      ),
                      subtitle: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Light / Dark',
                        ),
                      ),
                      onTap: () => context.read<SettingsCubit>().changeTheme(),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.format_size),
                      title: AnimatedDefaultTextStyle(
                        style: getTitleText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Font Size',
                        ),
                      ),
                      subtitle: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Small / Default / Large',
                        ),
                      ),
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) =>
                            _ChangeTextSizeDialog(textSize: state.textSize),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings_backup_restore),
                      title: AnimatedDefaultTextStyle(
                        style: getTitleText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Reset All Preferences',
                        ),
                      ),
                      subtitle: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Reset all Visual Customizations',
                        ),
                      ),
                      onTap: () =>
                          context.read<SettingsCubit>().toDefaultSettings(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ).copyWith(
                          color: theme.brightness == Brightness.light
                              ? theme.primaryColorDark
                              : theme.primaryColor,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                          'Chat Interface',
                        ),
                      ),
                    ),
                    ListTile(
                      leading: settings.bubbleAlignment == BubbleAlignment.left
                          ? const Icon(Icons.format_align_left)
                          : const Icon(Icons.format_align_right),
                      title: AnimatedDefaultTextStyle(
                        style: getTitleText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Bubble Alignment',
                        ),
                      ),
                      subtitle: AnimatedDefaultTextStyle(
                        style: getBodyText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Force right-to-left bubble alignment',
                        ),
                      ),
                      trailing: Switch(
                        value: alignment,
                        onChanged: (value) {
                          setState(() {
                            context.read<SettingsCubit>().changeAlignment();
                            alignment = value;
                          });
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.bubble_chart),
                      title: AnimatedDefaultTextStyle(
                        style: getTitleText(
                          state.textSize,
                          context,
                        ),
                        duration: const Duration(milliseconds: 700),
                        child: const Text(
                        'Center Date Bubble',
                        ),
                      ),
                      trailing: Switch(
                        value: dateBubbleAlignment,
                        onChanged: (value) {
                          setState(() {
                            context
                                .read<SettingsCubit>()
                                .changeDateBubbleAlignment();
                            dateBubbleAlignment = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChangeTextSizeDialog extends StatefulWidget {
  final TextSizeKeys textSize;

  const _ChangeTextSizeDialog({
    Key? key,
    required this.textSize,
  }) : super(key: key);

  @override
  State<_ChangeTextSizeDialog> createState() => _ChangeTextSizeDialogState();
}

class _ChangeTextSizeDialogState extends State<_ChangeTextSizeDialog> {
  late TextSizeKeys _radioValue;

  @override
  void initState() {
    super.initState();
    _radioValue = widget.textSize;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColorLight,
      content: SizedBox(
        width: 300,
        height: 200,
        child: ListView(
          children: [
            Row(
              children: [
                Radio(
                  value: TextSizeKeys.small,
                  groupValue: _radioValue,
                  onChanged: (value) => setState(() {
                    _radioValue = value!;
                    context.read<SettingsCubit>().changeTextSize(_radioValue);
                    Navigator.pop(context);
                  }),
                ),
                Text(
                  'Small',
                  style: getBodyText(
                    _radioValue,
                    context,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: TextSizeKeys.medium,
                  groupValue: _radioValue,
                  onChanged: (value) => setState(() {
                    _radioValue = value!;
                    context.read<SettingsCubit>().changeTextSize(_radioValue);
                    Navigator.pop(context);
                  }),
                ),
                Text(
                  'Medium',
                  style: getBodyText(
                    _radioValue,
                    context,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: TextSizeKeys.large,
                  groupValue: _radioValue,
                  onChanged: (value) => setState(() {
                    _radioValue = value!;
                    context.read<SettingsCubit>().changeTextSize(_radioValue);
                    Navigator.pop(context);
                  }),
                ),
                Text(
                  'Large',
                  style: getBodyText(
                    _radioValue,
                    context,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: getBodyText(
              _radioValue,
              context,
            ),
          ),
        ),
      ],
    );
  }
}
