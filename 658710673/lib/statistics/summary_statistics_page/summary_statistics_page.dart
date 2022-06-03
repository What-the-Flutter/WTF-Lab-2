import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/chart_data.dart';
import '../../utils/constants.dart';
import 'summary_statistics_cubit.dart';
import 'summary_statistics_state.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final pageFilterResult = [];

  @override
  void initState() {
    super.initState();
    _showResultLists(context.read<StatisticsCubit>().state.timePeriod);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Align(
              child: Text('Statistics'),
              alignment: Alignment.center,
            ),
          ),
          body: _bodyStructure(state),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
  }

  Widget _bodyStructure(StatisticsState state) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _dropdownTimePeriodMenu(state),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _summaryStatisticsContainer('${state.summaryTotalList.length}', 'Total',
                  const Color.fromARGB(255, 174, 231, 238)),
            ),
            Expanded(
              child: _summaryStatisticsContainer('${state.summaryBookmarkList.length}', 'Bookmarks',
                  const Color.fromARGB(255, 198, 229, 198)),
            ),
          ],
        ),
        _summaryStatisticsChart(state),
      ],
    );
  }

  Widget _summaryStatisticsContainer(
    String eventAmount,
    String title,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.fromLTRB(5, 6, 5, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventAmount,
            style: const TextStyle(fontSize: 18),
          ),
          Text(title),
        ],
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _summaryStatisticsChart(StatisticsState state) {
    final chartData = <ChartData>[];
    _initializeChartData(state, chartData);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 80),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: const Color.fromARGB(255, 198, 229, 198),
              xValueMapper: (events, _) => events.chartName,
              yValueMapper: (events, _) => events.bookmarkY),
          StackedColumnSeries<ChartData, String>(
              dataSource: chartData,
              color: const Color.fromARGB(255, 174, 231, 238),
              xValueMapper: (events, _) => events.chartName,
              yValueMapper: (events, _) => events.totalY),
        ],
      ),
    );
  }

  void _initializeChartData(StatisticsState state, List<ChartData> chartData) {
    if (state.timePeriod == StatisticsConst.today) {
      _initializeTodayAndYearChartData(state, chartData, 'Today');
    } else if (state.timePeriod == StatisticsConst.pastSevenDays) {
      _initializeTimeChartData(state, chartData, StatisticsConst.daysInWeek);
    } else if (state.timePeriod == StatisticsConst.pastThirtyDays) {
      _initializeTimeChartData(state, chartData, StatisticsConst.daysInMonth);
    } else if (state.timePeriod == StatisticsConst.thisYear) {
      _initializeTimeChartData(state, chartData, StatisticsConst.daysInYear);
    }
  }

  void _initializeWeekChartData(StatisticsState state, List<ChartData> chartData) {
    for (var i = 0; i <= StatisticsConst.daysInWeek; i++) {
      chartData.add(ChartData(
        chartName: '$i',
        totalY: state.summaryTotalList
            .where((event) => DateTime.now().difference(event.timeOfCreation).inDays == i)
            .length,
        bookmarkY: state.summaryBookmarkList
            .where((event) => DateTime.now().difference(event.timeOfCreation).inDays == i)
            .length,
      ));
    }
  }

  void _initializeTimeChartData(StatisticsState state, List<ChartData> chartData, int timeNum) {
    for (var i = 0; i <= timeNum; i++) {
      chartData.add(ChartData(
        chartName: '$i',
        totalY: state.summaryTotalList
            .where((event) => DateTime.now().difference(event.timeOfCreation).inDays == i)
            .length,
        bookmarkY: state.summaryBookmarkList
            .where((event) => DateTime.now().difference(event.timeOfCreation).inDays == i)
            .length,
      ));
    }
  }

  void _initializeTodayAndYearChartData(
    StatisticsState state,
    List<ChartData> chartData,
    String chartName,
  ) {
    chartData.add(
      ChartData(
        chartName: chartName,
        totalY: state.summaryTotalList.length,
        bookmarkY: state.summaryBookmarkList.length,
      ),
    );
  }

  Widget _dropdownTimePeriodMenu(StatisticsState state) {
    return DropdownButton<String>(
      value: state.timePeriod,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      style: const TextStyle(color: Colors.black54),
      underline: Container(
        height: 1,
        color: Colors.black26,
      ),
      onChanged: (newValue) {
        context.read<StatisticsCubit>().selectTimePeriod(newValue!);
        _showResultLists(newValue);
      },
      items: <String>[
        StatisticsConst.thisYear,
        StatisticsConst.pastThirtyDays,
        StatisticsConst.pastSevenDays,
        StatisticsConst.today,
      ].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _showResultLists(String newValue) {
    switch (newValue) {
      case StatisticsConst.today:
        context.read<StatisticsCubit>().showTotalListToday(pageFilterResult);
        context.read<StatisticsCubit>().showBookmarkListToday(pageFilterResult);
        break;
      case StatisticsConst.pastSevenDays:
        context.read<StatisticsCubit>().showTotalListPastWeek(pageFilterResult);
        context.read<StatisticsCubit>().showBookmarkListPastWeek(pageFilterResult);
        break;
      case StatisticsConst.pastThirtyDays:
        context.read<StatisticsCubit>().showTotalListPastMonth(pageFilterResult);
        context.read<StatisticsCubit>().showBookmarkListPastMonth(pageFilterResult);
        break;
      case StatisticsConst.thisYear:
        context.read<StatisticsCubit>().showTotalListThisYear(pageFilterResult);
        context.read<StatisticsCubit>().showBookmarkListThisYear(pageFilterResult);
        break;
    }
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          label: ('Summary'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.mood),
          label: ('Mood'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.multiline_chart),
          label: ('Charts'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: ('Times'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.bubble_chart),
          label: ('Labels'),
        )
      ],
    );
  }
}
