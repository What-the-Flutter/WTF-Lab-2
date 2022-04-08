import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_cubit.dart';

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
      body: _body(),
    );
  }

  Widget _body() {
    return ListView(
      children: [
        ListTile(
          title: const Text('Theme'),
          leading: const Icon(Icons.invert_colors),
          onTap: _cubit.changeTheme,
        ),
      ],
    );
  }
}
