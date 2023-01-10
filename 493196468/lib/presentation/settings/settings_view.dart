import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/settings_cubit/settings_cubit.dart';
import 'general_settings_view.dart';
import 'theme.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: getHeadLineText(
                state.textSize,
                context,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(
                      'General',
                      style: getTitleText(
                        state.textSize,
                        context,
                      ),
                    ),
                    subtitle: Text(
                      'Themes & Interface settings',
                      style: getBodyText(
                        state.textSize,
                        context,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GeneralSettingsView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
