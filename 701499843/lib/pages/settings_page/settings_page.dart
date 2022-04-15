import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  const SettingsPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<SettingsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 30),
            ),
            centerTitle: true,
          ),
          body: _body(_cubit, state),
        );
      },
    );
  }

  Widget _body(
    SettingsCubit cubit,
    SettingsState state,
  ) {
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
            'Small / Default /Large',
          ),
          onTap: () => _showDialog(cubit),
        ),
        ListTile(
          leading: const Icon(Icons.share),
          title: const Text('Share app'),
          subtitle: const Text('Send a link to your friend'),
          onTap: () async {
            await Share.share(
                'Download Chat journal right now! \n https://github.com/flutterwtf/WTF-Lab-2/tree/main/701499843');
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: const Text('Reset settings'),
          onTap: cubit.resetSettings,
        ),
        ListTile(
          leading: const Icon(Icons.chat_bubble),
          title: const Text('Bubble alighment'),
          subtitle:
              state.bubbleAlignment ? const Text('Right') : const Text('Left'),
          onTap: cubit.changeAlighnment,
        ),
        ListTile(
          leading: const Icon(Icons.center_focus_strong),
          title: const Text('Center Date'),
          subtitle: state.centerDate ? const Text('Yes') : const Text('No'),
          onTap: cubit.changeCenterDate,
        )
      ],
    );
  }

  void _showDialog(SettingsCubit cubit) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
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
        });
  }

  ListTile _sizeTile(
    String size,
    int index,
    SettingsCubit cubit,
  ) {
    return ListTile(
      title: Text(size),
      onTap: () {
        cubit.changeTextTheme(index);
        Navigator.pop(context);
      },
    );
  }
}
