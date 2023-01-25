import 'package:expense_tracker/model/chart_model.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class PieChart extends StatelessWidget {
  final List<ChartData> data;
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  PieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SfCircularChart(
          title: ChartTitle(
              text: 'expense vs balance',
              textStyle: TextStyle(
                fontSize: 13.sp,
              )),
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.desc,
              yValueMapper: (ChartData data, _) => data.amount,
              dataLabelSettings: const DataLabelSettings(
                  color: Colors.red, isVisible: true, showZeroValue: false),
              enableTooltip: true,
            )
          ],
        ),
      ),
    );
  }
}

class LineCharts extends StatelessWidget {
  final List<ChartExpense> data;
  final double width;
  LineCharts({
    Key? key,
    required this.data,
    required this.width,
  }) : super(key: key);
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Container(
        width: width,
        color: Colors.white,
        child: SafeArea(
            child: Column(
          children: [
            Text(
              "Expese trends in days",
              style: TextStyle(color: Colors.indigo.shade600, fontSize: 14.sp),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                  child: SfCartesianChart(
                    //title: ChartTitle(text: "Expense trends in day"),
                    enableAxisAnimation: true,
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      LineSeries<ChartExpense, String>(
                        yAxisName: "Amounts",
                        xAxisName: "Days",
                        name: 'Expenses',
                        dataSource: data,
                        xValueMapper: (ChartExpense chartData, _) =>
                            chartData.date!,
                        yValueMapper: (ChartExpense chartData, _) =>
                            int.parse(chartData.price!),
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            color: Colors.red.shade600,
                            angle: 50),
                        enableTooltip: true,
                      ),
                    ],
                    primaryXAxis: CategoryAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        labelPlacement: LabelPlacement.onTicks,
                        labelRotation: 100,
                        //numberFormat: NumberFormat('#'),
                        majorGridLines: const MajorGridLines(
                            width: 2,
                            color: Colors.red,
                            dashArray: <double>[5, 5]),
                        minorGridLines: const MinorGridLines(
                            width: 1,
                            color: Colors.green,
                            dashArray: <double>[5, 5]),
                        minorTicksPerInterval: 1,
                        majorTickLines: const MajorTickLines(
                            size: 6, width: 2, color: Colors.red),
                        minorTickLines: const MinorTickLines(
                            size: 4, width: 2, color: Colors.blue),
                        plotOffset: 10),
                    primaryYAxis: NumericAxis(
                        numberFormat: NumberFormat.simpleCurrency(
                            decimalDigits: 0, name: "\$", locale: "en-us"),
                        labelAlignment: LabelAlignment.center),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
