import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/theme_state.dart';
import 'set_background_image.dart';
import 'settings_app_bar.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: SettingsAppBar(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Visuals',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.water_drop_outlined,
                    ),
                    title: const Text(
                      'Theme',
                    ),
                    subtitle: const Text(
                      'Light / Dark / Amoled',
                    ),
                    onTap: () {
                      final cubit = context.read<ThemeCubit>();
                      cubit.changeTheme();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.text_fields,
                    ),
                    title: const Text('Font Size'),
                    subtitle: const Text('Small / Default / Large'),
                    onTap: () {
                      fontSizeChangeDialog(state);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.lock_reset,
                    ),
                    title: const Text(
                      'Reset all Preferences',
                    ),
                    subtitle: const Text(
                      'Reset all Visual Customization',
                    ),
                    onTap: () {
                      BlocProvider.of<ThemeCubit>(context)
                          .resetAllPreferences();
                    },
                  ),
                ],
              ),
              const Text(
                'Chat Interface',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.format_list_bulleted,
                    ),
                    title: const Text(
                      'Bubble Alignment',
                    ),
                    subtitle: const Text(
                      'Force right-to-left bubble alignment',
                    ),
                    trailing: Switch(
                      onChanged: (val) {
                        BlocProvider.of<SettingsCubit>(context)
                            .changeBubbleAlignment();
                      },
                      value: state.isBubbleAlignment!,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.wb_iridescent,
                    ),
                    title: const Text(
                      'Center Date Bubble',
                    ),
                    trailing: Switch(
                      onChanged: (val) {
                        BlocProvider.of<SettingsCubit>(context)
                            .changeCenterDateBubble();
                      },
                      value: state.isCenterDateBubble!,
                    ),
                  ),

                  ///Выбор фоновой картинки
                  setBackgroundListTile(),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void fontSizeChangeDialog(SettingsState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Font Size',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Small',
                  ),
                  onTap: () {
                    BlocProvider.of<ThemeCubit>(context).setFontSizeText(1);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Default',
                  ),
                  onTap: () {
                    BlocProvider.of<ThemeCubit>(context).setFontSizeText(2);
                  },
                ),
                ListTile(
                  title: const Text(
                    'Large',
                  ),
                  onTap: () {
                    BlocProvider.of<ThemeCubit>(context).setFontSizeText(3);
                  },
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ListTile setBackgroundListTile() {
    return ListTile(
      leading: const Icon(
        Icons.image_outlined,
      ),
      title: const Text(
        'Background Image',
      ),
      subtitle: const Text(
        'Chat background image',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SetBackgroundImage(),
          ),
        );
      },
    );
  }
}
