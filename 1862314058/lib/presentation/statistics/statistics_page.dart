import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/statistics.dart';
import 'statistics_state.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    BlocProvider.of<StatisticsCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(3, 7, 3, 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _dropDownPeriodList(state),
              ),
              Text('Total: ${state.countOfMessages ?? '-'}'),
              Expanded(
                child: charts.BarChart(
                  BlocProvider.of<StatisticsCubit>(context)
                              .state
                              .selectedPeriod ==
                          'week'
                      ? _showWeekStatistics()
                      : BlocProvider.of<StatisticsCubit>(context)
                                  .state
                                  .selectedPeriod ==
                              'month'
                          ? _showMonthStatistics()
                          : _showYearStatistics(),
                  barGroupingType: charts.BarGroupingType.stacked,
                  domainAxis: const charts.OrdinalAxisSpec(
                    renderSpec: charts.SmallTickRendererSpec(
                      labelRotation: 45,
                    ),
                  ),
                  animate: true,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  DropdownButton _dropDownPeriodList(StatisticsState state) {
    return DropdownButton<String>(
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      value: state.selectedPeriod,
      items: <String>['today', 'week', 'month', 'year']
          .map<DropdownMenuItem<String>>(
        (value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (newValue) {
        BlocProvider.of<StatisticsCubit>(context).selectTimePeriod(
          newValue!,
        );
      },
    );
  }

  List<charts.Series<StatisticsModel, String>> _chartsSeries(
    Function(int) countMessages,
    int value,
    int limit,
    int period,
  ) {
    return [
      charts.Series<StatisticsModel, String>(
        id: 'messages',
        measureFn: (sales, _) => sales.value,
        data: _generateList(
          countMessages,
          value,
          <StatisticsModel>[],
          limit,
          period,
        ),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (sales, _) => sales.text,
      ),
    ];
  }

  List<charts.Series<StatisticsModel, String>> _showYearStatistics() {
    int _countYearMessages(int monthDifference) {
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where(
            (element) =>
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month - monthDifference,
                      ),
                    ) &&
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month - monthDifference + 1,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countYearMessages, 10, -1, 1);
  }

  List<charts.Series<StatisticsModel, String>> _showMonthStatistics() {
    int _countMonthMessages(int dayDifference) {
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where(
            (element) =>
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference,
                      ),
                    ) &&
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference + 2,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countMonthMessages, 29, 0, 30);
  }

  List<charts.Series<StatisticsModel, String>> _showWeekStatistics() {
    int _countWeekMessages(int dayDifference) {
      return BlocProvider.of<StatisticsCubit>(context)
          .state
          .messages
          .where(
            (element) =>
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isAfter(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference,
                      ),
                    ) &&
                DateFormat()
                    .add_yMMMd()
                    .parse(element.createMessageTime)
                    .isBefore(
                      DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day - dayDifference + 2,
                      ),
                    ),
          )
          .length;
    }

    return _chartsSeries(_countWeekMessages, 7, 0, 7);
  }

  List<StatisticsModel> _generateList(
    Function(int) function,
    int difference,
    List<StatisticsModel> list,
    int limit,
    int period,
  ) {
    switch (period) {
      case 1:
        list.add(
          StatisticsModel(
            '${DateFormat.MMM().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month - 1 - difference,
                DateTime.now().day,
              ),
            )}',
            function(difference + 1),
          ),
        );
        break;
      case 7:
        list.add(
          StatisticsModel(
            '${DateFormat.MMMd().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference,
              ),
            )}',
            function(difference + 1),
          ),
        );
        break;
      case 30:
        list.add(
          StatisticsModel(
            '${DateFormat.d().format(
              DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day - difference,
              ),
            )}',
            function(difference + 1),
          ),
        );
        break;
    }

    if (difference != limit) {
      return _generateList(
        function,
        difference - 1,
        list,
        limit,
        period,
      );
    }
    return list;
  }
}
