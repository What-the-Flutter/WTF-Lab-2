import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_cubit.dart';
import 'settings_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (blocContext, state) {
        return Scaffold(
          appBar: _appBar(),
          body: _params(state),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Settings'),
    );
  }

  Widget _params(SettingsState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          _switchParams(state),
        ],
      ),
    );
  }

  Widget _switchParams(SettingsState state) {
    return Row(
      children: [
        const Text(
          'Use biometrics to log in',
        ),
        Switch(
          value: state.useBiometrics,
          onChanged: (value) {
            //BlocProvider.of<SettingsCubit>(context).changeBiometricsUsage();
          },
          activeTrackColor: Theme.of(context).colorScheme.onSecondary,
          activeColor: Colors.black,
        ),
      ],
    );
  }
}
