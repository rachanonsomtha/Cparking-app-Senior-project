import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../provider/parkingLot.dart';
import 'package:bezier_chart/bezier_chart.dart';

class BarChartSample1 extends StatefulWidget {
  final List<double> meanList;
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  final ParkLot parkingLotDetail;

  BarChartSample1(this.parkingLotDetail, this.meanList);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color.fromRGBO(96, 105, 165, 1);
  final Duration animDuration = Duration(milliseconds: 250);

  int touchedIndex;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shadowColor: Colors.black87,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white70,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    widget.parkingLotDetail.id,
                    style: TextStyle(
                        color: Color.fromRGBO(51, 57, 91, 1),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.parkingLotDetail.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        isPlaying ? randomData() : mainBarData(),
                        swapAnimationDuration: animDuration,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.amber,
    double width = 8,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: widget.parkingLotDetail.max +
                1, // height of each rod >> lot.max here
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(11, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 7:
            return makeGroupData(7, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 8:
            return makeGroupData(8, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 9:
            return makeGroupData(9, widget.meanList[i],
                isTouched: i == touchedIndex);
          case 10:
            return makeGroupData(10, widget.meanList[i],
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '7:00';
                  break;
                case 1:
                  weekDay = '8:00';
                  break;
                case 2:
                  weekDay = '9:00';
                  break;
                case 3:
                  weekDay = '10:00';
                  break;
                case 4:
                  weekDay = '11:00';
                  break;
                case 5:
                  weekDay = '12:00';
                  break;
                case 6:
                  weekDay = '13:00';
                  break;
                case 7:
                  weekDay = '14:00';
                  break;
                case 8:
                  weekDay = '15:00';
                  break;
                case 9:
                  weekDay = '16:00';
                  break;
                case 10:
                  weekDay = '17:00';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.amberAccent));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Color.fromRGBO(51, 57, 91, 1),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '7';
              case 1:
                return '8';
              case 2:
                return '9';
              case 3:
                return '10';
              case 4:
                return '11';
              case 5:
                return '12';
              case 6:
                return '13';
              case 7:
                return '14';
              case 8:
                return '15';
              case 9:
                return '16';
              case 10:
                return '17';
              default:
                return '';
            }
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: const BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Color.fromRGBO(51, 57, 91, 1),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '7';
              case 1:
                return '8';
              case 2:
                return '9';
              case 3:
                return '10';
              case 4:
                return '11';
              case 5:
                return '12';
              case 6:
                return '13';
              case 7:
                return '14';
              case 8:
                return '15';
              case 9:
                return '16';
              case 10:
                return '17';
              default:
                return '';
            }
          },
        ),
        leftTitles: const SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(11, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 7:
            return makeGroupData(7, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 8:
            return makeGroupData(8, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 9:
            return makeGroupData(9, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 10:
            return makeGroupData(10, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
