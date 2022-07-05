import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'summary_stats_cubit.dart';
import 'package:diploma/statistics_page/summary_stats_filter_view.dart';
import 'package:diploma/models/event_scale.dart';
import 'package:diploma/statistics_page/summary_stats_state.dart';

class SummaryStatsView extends StatefulWidget {
  const SummaryStatsView({Key? key}) : super(key: key);

  @override
  State<SummaryStatsView> createState() => _SummaryStatsViewState();
}

class _SummaryStatsViewState extends State<SummaryStatsView> {
  late final SummaryStatsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = BlocProvider.of<SummaryStatsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryStatsCubit, SummaryStatsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Statistics',
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_outlined),
            ),
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _timeMenu(),
              ),
              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(3),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,
                  ),
                  child: const Icon(Icons.settings),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryStatsFilterView(_cubit),
                  ),
                ).then((value) => _cubit.updateChart()),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: _summaryContainer(
                _cubit.fetchEventsAmount().toString(),
                'Total',
                const Color.fromARGB(255, 174, 231, 238),
              ),
            ),
            Expanded(
              child: _summaryContainer(
                _cubit.fetchEventsWithLabelAmount().toString(),
                'Labels',
                const Color.fromARGB(255, 198, 229, 198),
              ),
            ),
          ],
        ),
        Expanded(child: _loadChart()),
      ],
    );
  }

  Widget _timeMenu() {
    return DropdownButton<String>(
      value: _cubit.state.selectedPeriod,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      underline: Container(
        height: 1,
        color: Colors.black26,
      ),
      onChanged: (newValue) => _cubit.setNewPeriod(newValue!),
      items: <String>[
        'Today',
        'Last 7 days',
        'Last 30 days',
        'Last year',
      ].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _summaryContainer(
    String eventAmount,
    String title,
    Color color,
  ) {
    return Container(
      height: 60,
      margin: const EdgeInsets.fromLTRB(5, 6, 5, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventAmount,
            style: const TextStyle(fontSize: 20),
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

  Widget _loadChart() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: charts.BarChart(
        _getData,
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [
          charts.ChartTitle(
            'Time past',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea,
          ),
        ],
        domainAxis: const charts.OrdinalAxisSpec(
          showAxisLine: true,
          renderSpec: charts.NoneRenderSpec(),
        ),
      ),
    );
  }

  List<charts.Series<EventScale, String>> get _getData => [
        charts.Series<EventScale, String>(
          id: 'AllEvents',
          domainFn: (EventScale scale, _) => scale.period,
          measureFn: (EventScale scale, _) => scale.amount,
          data: _cubit.state.totalEventsScales,
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        ),
        charts.Series<EventScale, String>(
          id: 'LabelEvents',
          domainFn: (EventScale scale, _) => scale.period,
          measureFn: (EventScale scale, _) => scale.amount,
          data: _cubit.state.eventsWithLabelScales,
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        ),
      ];
}
