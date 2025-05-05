import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../DataBase.dart';
import 'package:logger/logger.dart';
import '../main.dart';

var logger = Logger();


class Setting_page extends StatefulWidget {

  const Setting_page({super.key});

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
    height: double.infinity,
    child:Column(
      children: [
        PieChartSample2(),
        BarChartSample(),
        LineChartSample()
      ],
    )
    );
  }
}

//饼图
class PieData {
  final String label;
  final double value;
  final Color color;

  PieData(this.label, this.value, this.color);
}

class PieChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChartSample2State();
}

class PieChartSample2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final pieData = [
      PieData('A', 30, Colors.blue),
      PieData('B', 20, Colors.red),
      PieData('C', 15, Colors.green),
      PieData('D', 35, Colors.amber),
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(pieData),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<PieData> pieData) {
    return List.generate(pieData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: pieData[i].color,
        value: pieData[i].value,
        title: '${pieData[i].value}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}

//条形图
class LineChartSample extends StatelessWidget {
  // 示例数据 - 每月销售额
  final List<Map<String, dynamic>> monthlySales = [
    {'month': 'Jan', 'sales': 35},
    {'month': 'Feb', 'sales': 28},
    {'month': 'Mar', 'sales': 42},
    {'month': 'Apr', 'sales': 50},
    {'month': 'May', 'sales': 65},
    {'month': 'Jun', 'sales': 80},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.7, // 图表宽高比
        child: LineChart(
          LineChartData(
            // ---- 网格线配置 ----
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
            ),

            // ---- 坐标轴标题配置 ----
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(  // 替换 SideTitles
                sideTitles: SideTitles(  // 现在 SideTitles 是 AxisTitles 的子属性
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {  // 替换 getTextStyles 和 getTitles
                    return Text(
                      monthlySales[value.toInt()]['month'],
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(  // 替换 SideTitles
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}k',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                  reservedSize: 28,
                ),
              ),
            ),

            // ---- 边框配置 ----
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.blueGrey.withOpacity(0.3),
                width: 1,
              ),
            ),

            // ---- 折线数据 ----
            lineBarsData: [
              LineChartBarData(
                spots: monthlySales.asMap().entries.map((entry) {
                  // 将数据转换为FlSpot(x,y)
                  return FlSpot(
                    entry.key.toDouble(), // x轴位置（索引）
                    entry.value['sales'].toDouble(), // y轴值
                  );
                }).toList(),
                isCurved: true, // 是否使用曲线
                color: Colors.blueAccent,
                barWidth: 4, // 线宽
                isStrokeCapRound: true, // 线头圆角
                dotData: FlDotData(
                  show: true, // 显示数据点
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: Colors.blueAccent,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true, // 显示区域填充
                  color: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
            ],

            // ---- 其他配置 ----
            minX: 0,
            maxX: monthlySales.length.toDouble() - 1,
            minY: 0,
            maxY: 100, // y轴最大值
            /*lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.blueGrey, // 替代 tooltipBgColor
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem(
                      '${months[spot.x.toInt()]}\n',
                      const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '销售额: ${spot.y.toInt()}k',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),
            ),*/
          ),
        ),
      ),
    );
  }
}

//折线图
class BarChartSample extends StatelessWidget {
  // 示例数据 - 产品销量
  final List<Map<String, dynamic>> productSales = [
    {'product': '手机', 'sales': 65},
    {'product': '平板', 'sales': 40},
    {'product': '笔记本', 'sales': 75},
    {'product': '耳机', 'sales': 35},
    {'product': '手表', 'sales': 25},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: BarChart(
          BarChartData(
            // ---- 对齐方式 ----
            alignment: BarChartAlignment.spaceAround,

            // ---- 网格线配置 ----
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false, // 只显示水平网格线
              getDrawingHorizontalLine: (value) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
            ),

            // ---- 坐标轴标题配置 ----
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(  // 替换 SideTitles
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      productSales[value.toInt()]['product'],
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(  // 替换 SideTitles
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}k',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                  reservedSize: 28,
                ),
              ),
            ),

            // ---- 边框配置 ----
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.blueGrey.withOpacity(0.3),
                width: 1,
              ),
            ),

            // ---- 条形数据 ----
            barGroups: productSales.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key, // x轴位置
                barRods: [
                  BarChartRodData(
                     // 条形高度
                    color: Colors.blueAccent, // 条形颜色
                    width: 20, // 条形宽度
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true, // 显示背景条// 背景条高度（最大可能值）
                      color: Colors.grey.withOpacity(0.15),
                    ), toY: 100,
                  ),
                ],
              );
            }).toList(),

            // ---- 其他配置 ----
            maxY: 100, // y轴最大值
            barTouchData: BarTouchData(
              enabled: true, // 启用触摸交互
              /*touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${productSales[group.x.toInt()]['product']}\n',
                    const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: '销量: ${rod.y.toInt()}k',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  );
                },
              ),*/
            ),
          ),
        ),
      ),
    );
  }
}