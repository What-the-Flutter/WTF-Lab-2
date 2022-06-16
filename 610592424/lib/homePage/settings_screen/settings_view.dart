import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';

import 'settings_cubit.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<SettingsCubit>(context);
    _cubit.loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Settings',
        ),
        centerTitle: true,
      ),
      body: _body(_cubit),
    );
  }

  Widget _body(SettingsCubit cubit) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Theme'),
          leading: const Icon(Icons.invert_colors),
          onTap: _cubit.changeTheme,
        ),
        ListTile(
          leading: const Icon(Icons.text_fields),
          title: const Text('Font size'),
          subtitle: const Text(
            'Small/Medium/Large',
          ),
          onTap: () => _showDialog(cubit),
        ),
        ListTile(
          leading: const Icon(Icons.chat_bubble),
          title: const Text('Bubble alignment'),
          subtitle: _cubit.state.bubbleAlignment
              ? const Text('Right')
              : const Text('Left'),
          onTap: () {
            cubit.changeAlignment();
            setState(() {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.center_focus_strong),
          title: const Text('Center Date'),
          subtitle:
              _cubit.state.centerDate ? const Text('Yes') : const Text('No'),
          onTap: () {
            cubit.changeCenterDate();
            setState(() {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Reset settings'),
          onTap: () {
            cubit.resetSettings();
            setState(() {});
          },
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share app'),
          subtitle: const Text('Send a link to your friend'),
          onTap: () async {
            await FlutterShare.share(
              title: 'My app is available here: \n '
                  'https://github.com/flutterwtf/WTF-Lab-2/tree/main/610592424',
            );
          },
        ),
      ],
    );
  }

  void _showDialog(SettingsCubit cubit) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 150,
            height: 250,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Font Size',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                _sizeTile('Small', 0, cubit),
                _sizeTile('Medium', 1, cubit),
                _sizeTile('Large', 2, cubit),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Ok'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile _sizeTile(String size, int index, SettingsCubit cubit) {
    return ListTile(
      title: Text(size),
      onTap: () {
        cubit.changeTextTheme(index);
        Navigator.pop(context);
      },
    );
  }
}
