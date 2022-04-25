import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieWidget extends StatelessWidget {
  const PieWidget({
    Key? key,
    required this.dataMap,
    required this.title,
    required this.chatRadius,
    this.totalValue,
  }) : super(key: key);

  final Map<String, double> dataMap;
  final String title;
  final double chatRadius;
  final double? totalValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          const SizedBox(height: 20),
          PieChart(
            totalValue: totalValue,
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: chatRadius,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: chatRadius / 5,
            baseChartColor: Colors.grey.withOpacity(0.15),
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: true,
              decimalPlaces: 1,
            ),
          ),
        ],
      ),
    );
  }
}
