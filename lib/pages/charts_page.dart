import 'package:flutter/material.dart';
import 'package:inzynierka/globals.dart';
import 'package:inzynierka/pages/charts_timeframe.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class ChartsPage extends StatefulWidget {
  const ChartsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  List<Color> tempColors = [
    Color.fromARGB(255, 227, 48, 8),
    Color.fromARGB(255, 238, 82, 82),
  ];
  List<Color> humidColors = [
    Color.fromARGB(255, 0, 158, 250),
    Color.fromARGB(255, 77, 213, 255),
  ];

  @override
  void initState() {
    chartsData.addListener(_refresh);
    super.initState();
  }

  @override
  void dispose() {
    chartsData.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (chartsData.apiData.isEmpty) {
      // ignore: void_checks
      return const ChartsTimeframe();
    } else {
      return Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                  //color: Color(0xff232d37),
                  ),
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 60,
                ),
                child: LineChart(
                  mainData(), //TODO add diffrent chart
                  // showAvg ? avgData() : mainData(),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 30.0, right: 25),
                  child: ElevatedButton(
                      onPressed: () => chartsData.clearData(),
                      child: const Text("Clear data")))),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 70.0, right: 28),
                  child: const Text("Temperature",
                      style:
                          TextStyle(color: Color.fromARGB(255, 227, 48, 8))))),
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: EdgeInsets.only(top: 100.0, right: 40),
                  child: const Text("Humidity",
                      style:
                          TextStyle(color: Color.fromARGB(255, 0, 158, 250)))))
        ],
      );
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    // Widget text = Text(
    //   chartsData.apiData[value.toInt()]['date'],
    //   //-dates[value.toInt()],
    //   style: style,
    // );

    Widget text = Transform.rotate(
        angle: -math.pi / 2,
        child: Container(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              chartsData.apiData[value.toInt()]['date'],
              style: style,
            )));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10';
        break;
      case 20:
        text = '20';
        break;
      case 30:
        text = '30';
        break;
      case 40:
        text = '40';
        break;
      case 50:
        text = '50';
        break;
      case 60:
        text = '60';
        break;
      case 70:
        text = '70';
        break;
      case 80:
        text = '80';
        break;
      case 90:
        text = '90';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: chartsData.apiData.length.toDouble() - 1,
      minY: 18,
      maxY: 80,
      lineBarsData: [
        LineChartBarData(
          spots: chartsData.humSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: humidColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  humidColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: chartsData.tempSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: tempColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors:
                  tempColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
