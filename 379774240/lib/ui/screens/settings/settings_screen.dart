import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: Builder(builder: (context) {
        context.read<SettingsCubit>().init();
        return Scaffold(
          appBar: _buildAppBar(context),
          body: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return ListView(
                children: [
                  SwitchListTile(
                    value: !state.appState.isLightTheme,
                    onChanged: (value) {
                      context.read<SettingsCubit>().swithTheme();
                    },
                    title: Text(
                      'Dark Theme',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        'Settings',
        style: TextStyle(
          fontFamily: 'Quicksand',
        ),
      ),
    );
  }
}
