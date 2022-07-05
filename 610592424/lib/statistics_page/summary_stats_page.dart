import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'summary_stats_cubit.dart';
import 'summary_stats_view.dart';

class SummaryStatsPage extends StatelessWidget {
  const SummaryStatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SummaryStatsCubit(),
      child: const SummaryStatsView(),
    );
  }
}

