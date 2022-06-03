import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../category_page/category_cubit.dart';
import '../create_category_page/create_category_cubit.dart';
import '../filters_page/filters_cubit.dart';
import '../home_page/home_cubit.dart';
import '../home_page/home_page.dart';
import '../settings_page/settings_cubit.dart';
import '../statistics/summary_statistics_page/summary_statistics_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
    required User? user,
  })  : _user = user,
        super(key: key);

  final User? _user;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(
            const Duration(milliseconds: 2300),
            () async {
              _controller.stop(canceled: true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider<HomeCubit>(
                          create: (context) => HomeCubit(user: widget._user),
                        ),
                        BlocProvider<CreateCategoryPageCubit>(
                          create: (context) => CreateCategoryPageCubit(),
                        ),
                        BlocProvider<CategoryCubit>(
                          create: (context) => CategoryCubit(user: widget._user),
                        ),
                        BlocProvider<SettingsCubit>(create: (context) => SettingsCubit()),
                        BlocProvider<FiltersPageCubit>(
                          create: (context) => FiltersPageCubit(user: widget._user),
                        ),
                        BlocProvider<StatisticsCubit>(
                          create: (context) => StatisticsCubit(user: widget._user),
                        ),
                      ],
                      child: HomePage(),
                    );
                  },
                ),
              );
            },
          ),
          builder: (context, snapshot) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _controller.value,
                  child: child,
                );
              },
              child: SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Image.asset(
                    './assets/images/launch_icon.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
