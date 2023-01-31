import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../settings/cubit/settings_cubit/settings_cubit.dart';
import '../../settings/theme.dart';
import 'cubit/statistics_cubit.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<StatisticsCubit>().updateStateFromRepo();
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Statistics',
              style: getHeadLineText(
                context.read<SettingsCubit>().state.textSize,
                context,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                const _PeriodSelectionDropButton(),
                ..._getAllStats(context),
                _StatisticsChart(
                  key: UniqueKey(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<Widget> _getAllStats(BuildContext context) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: _StatTile(
            statNum: context.read<StatisticsCubit>().getTotalNumberOfMessages(),
            statTitle: 'Total',
          ),
        ),
        Expanded(
          flex: 2,
          child: _StatTile(
            statNum:
                context.read<StatisticsCubit>().getBookmarkedNumberOfMessages(),
            statTitle: 'Bookmarks',
          ),
        ),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _StatTile(
            statNum:
                context.read<StatisticsCubit>().getLabeledNumberOfMessages(),
            statTitle: 'Labels',
          ),
        ),
        Expanded(
          child: _StatTile(
            statNum:
                context.read<StatisticsCubit>().getAnswersNumberOfMessages(),
            statTitle: 'Answers',
          ),
        ),
        Expanded(
          child: _StatTile(
            statNum: context.read<StatisticsCubit>().getMoodNumberOfMessages(),
            statTitle: 'Mood',
          ),
        ),
      ],
    ),
  ];
}

class _PeriodSelectionDropButton extends StatefulWidget {
  const _PeriodSelectionDropButton({Key? key}) : super(key: key);

  @override
  State<_PeriodSelectionDropButton> createState() =>
      _PeriodSelectionDropButtonState();
}

class _PeriodSelectionDropButtonState
    extends State<_PeriodSelectionDropButton> {
  static const _list = <String>[
    'Today',
    'Last 7 days',
    'Past 30 days',
    'This year',
  ];

  String _periodToString(Period period) {
    String res;
    switch (context.read<StatisticsCubit>().state.period) {
      case Period.today:
        res = 'Today';
        break;
      case Period.lastSevenDays:
        res = 'Last 7 days';
        break;
      case Period.pastThirtyDays:
        res = 'Past 30 days';
        break;
      case Period.thisYear:
        res = 'This year';
        break;
      default:
        res = 'Past 30 days';
    }
    return res;
  }

  Period _stringToPeriod(String str) {
    Period res;
    switch (str) {
      case 'Today':
        res = Period.today;
        break;
      case 'Last 7 days':
        res = Period.lastSevenDays;
        break;
      case 'Past 30 days':
        res = Period.pastThirtyDays;
        break;
      case 'This year':
        res = Period.thisYear;
        break;
      default:
        res = Period.thisYear;
    }
    return res;
  }

  String _dropdownValue = _list[2];

  @override
  Widget build(BuildContext context) {
    _dropdownValue =
        _periodToString(context.read<StatisticsCubit>().state.period);
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton(
        isExpanded: true,
        value: _dropdownValue,
        items: _list.map<DropdownMenuItem<String>>(
          (value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
        onChanged: (item) {
          _dropdownValue = item!;
          context
              .read<StatisticsCubit>()
              .setPeriod(_stringToPeriod(_dropdownValue));
          setState(() {});
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final int statNum;
  final String statTitle;

  const _StatTile({
    Key? key,
    required this.statNum,
    required this.statTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statNum.toString(),
            style: getHeadLineText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
          Text(
            statTitle,
            style: getTitleText(
              context.read<SettingsCubit>().state.textSize,
              context,
            ),
          ),
        ],
      ),
    );
  }
}

class _EachColumnData {
  final String chartName;
  late final int total;
  final int bookmarked;

  _EachColumnData({
    required this.chartName,
    required total,
    required this.bookmarked,
  }) {
    this.total = total - bookmarked;
  }
}

class _StatisticsChart extends StatelessWidget {
  const _StatisticsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final columnsDataList = _initializeChartData(context);
    return Container(
      alignment: Alignment.center,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          StackedColumnSeries<_EachColumnData, String>(
            dataSource: columnsDataList,
            color: theme.brightness == Brightness.light
                ? theme.primaryColorDark
                : theme.indicatorColor,
            xValueMapper: (events, _) => events.chartName,
            yValueMapper: (events, _) => events.bookmarked,
          ),
          StackedColumnSeries<_EachColumnData, String>(
            dataSource: columnsDataList,
            color: theme.brightness == Brightness.light
                ? theme.primaryColorLight
                : theme.primaryColor,
            xValueMapper: (events, _) => events.chartName,
            yValueMapper: (events, _) => events.total,
          ),
        ],
      ),
    );
  }
}

List<_EachColumnData> _initializeChartData(BuildContext context) {
  final state = context.read<StatisticsCubit>().state;
  switch (state.period) {
    case Period.today:
      return _initializeTodayColumnData(context);
    case Period.lastSevenDays:
      return _initializeDaysColumnData(context, 7);
    case Period.pastThirtyDays:
      return _initializeDaysColumnData(context, 30);
    case Period.thisYear:
      return _initializeYearColumnData(context);
  }
}

List<_EachColumnData> _initializeTodayColumnData(BuildContext context) {
  final columnsDataList = <_EachColumnData>[];
  columnsDataList.add(
    _EachColumnData(
      chartName: 'Today',
      total: context.read<StatisticsCubit>().getTotalNumberOfMessages(),
      bookmarked:
          context.read<StatisticsCubit>().getBookmarkedNumberOfMessages(),
    ),
  );
  return columnsDataList;
}

const _months = <int, String>{
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

List<_EachColumnData> _initializeYearColumnData(BuildContext context) {
  final columnsDataList = <_EachColumnData>[];
  for (var i = 1; i <= 12; i++) {
    columnsDataList.add(
      _EachColumnData(
        chartName: _months[i]!,
        total:
            context.read<StatisticsCubit>().getNumberOfMessagesNMonthBefore(i),
        bookmarked: context
            .read<StatisticsCubit>()
            .getBookmarkedNumberOfMessagesNMonthBefore(i),
      ),
    );
  }
  return columnsDataList;
}

List<_EachColumnData> _initializeDaysColumnData(
  BuildContext context,
  int num,
) {
  final columnsDataList = <_EachColumnData>[];
  for (var i = 0; i <= num; i++) {
    columnsDataList.add(
      _EachColumnData(
        chartName: '$i',
        total:
            context.read<StatisticsCubit>().getNumberOfMessagesNDaysBefore(i),
        bookmarked: context
            .read<StatisticsCubit>()
            .getBookmarkedNumberOfMessagesNDaysBefore(i),
      ),
    );
  }
  return columnsDataList;
}
