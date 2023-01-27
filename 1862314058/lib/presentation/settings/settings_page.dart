import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../theme/theme_state.dart';
import 'set_background_image.dart';
import 'settings_app_bar.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _resetAnimationController;

  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).init();
    _resetAnimationController = AnimationController(
      vsync: this,
    );
    _resetAnimationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        _resetAnimationController.reset();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _resetAnimationController.dispose();
    super.dispose();
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
              Text(
                'Visuals',
                style: Theme.of(context).textTheme.headline5,
              ),
              _visualsSettingsList(state),
              Text(
                'Chat Interface',
                style: Theme.of(context).textTheme.headline5,
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
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
                      value: state.isBubbleAlignment,
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
                      value: state.isCenterDateBubble,
                    ),
                  ),
                  _setBackgroundListTile(),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  ListView _visualsSettingsList(SettingsState state) {
    return ListView(
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
            _fontSizeChangeDialog(state);
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
            showResetDialog(context);
            BlocProvider.of<ThemeCubit>(context).resetAllPreferences();
          },
        ),
      ],
    );
  }

  void showResetDialog(BuildContext context) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Lottie.asset('assets/reset2.json',
                  repeat: false, controller: _resetAnimationController,
                  onLoaded: (composition) {
                _resetAnimationController.duration = composition.duration;
                _resetAnimationController.forward();
              }),
              const Text(
                'Done!',
              ),
            ],
          ),
        ),
      );

  void _fontSizeChangeDialog(SettingsState state) {
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
                Text(
                  'Font Size',
                  style: Theme.of(context).textTheme.headline5,
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

  ListTile _setBackgroundListTile() {
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
            builder: (context) => SetBackgroundImage(),
          ),
        );
      },
    );
  }
}
