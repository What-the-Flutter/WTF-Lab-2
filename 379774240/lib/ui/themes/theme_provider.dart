import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_controller_cubit.dart';

class ThemeProvider extends StatefulWidget {
  final Widget child;
  const ThemeProvider({
    required this.child,
    super.key,
  });

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeControllerCubit(),
      child: BlocBuilder<ThemeControllerCubit, ThemeControllerState>(
        builder: (context, state) {
          return widget.child;
        },
      ),
    );
  }
}
