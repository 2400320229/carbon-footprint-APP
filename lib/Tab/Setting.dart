import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataBase.dart';
import 'package:logger/logger.dart';
import '../main.dart';

var logger = Logger();
List<CountNode> data = [];
Map<String,double> summary = {};
class Setting_page extends StatefulWidget {

  const Setting_page({super.key});

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {

  Timer? _timer;
  bool? is_land = false;
  List<PieData> pieData = [];
  List<Map<String, dynamic>> monthlySales = [];
  List<Map<String, dynamic>> productSales = [];
  List<Widget> land=[
    PieChartSample2(pieData: [],),
    BarChartSample(productSales: [],),
    LineChartSample(monthlySales: [],)
  ];
  List<Widget> un_land=[
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("请登录",style: TextStyle(fontSize: 50),),
        ElevatedButton(onPressed: (){
          Get.toNamed("/land");
        }, child: Text("去登录"))
      ],
    )
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
    height: double.infinity,
    child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: is_land==true?land:un_land
    )
    );
  }
  init()async{

    final p = await SharedPreferences.getInstance();
    is_land =  p.getBool("island");
    if (mounted) { // 检查是否仍在树中
      setState(() {
        is_land = true;
      });
    }
    data = await nodedb.getAllCountNode();
    await analyze_data();
    logger.d(data);
  }
  analyze_data() async {
    double s_yi = 0;
    double s_zhu = 0;
    double s_xing = 0;
    double s_shi = 0;
    for(var a in data){
      logger.d("type::"+a.type.toString());
      switch(a.type){
        case 1:
          s_yi += a.count;
          break;
        case 2:
          s_shi += a.count;
          break;
        case 3:
          s_zhu += a.count;
          break;
        case 4:
          s_xing += a.count;
          break;
        default:
          break;
      }
    }
    List<PieData> _pieData = [];
    List<Map<String, dynamic>> _productSales = [];
    List<Map<String, dynamic>> _monthlySales = [];
    var all = s_shi+s_yi+s_xing+s_zhu;
    _timer =Timer(Duration(milliseconds: 500),(){
        summary = {
          "yi":s_yi,
          "shi":s_shi,
          "zhu":s_zhu,
          "xing":s_xing,
          "_yi_":s_yi/all*100,
          "_shi_":s_shi/all*100,
          "_zhu_":s_zhu/all*100,
          "_xing_":s_xing/all*100,
        };
        _pieData = [
          PieData('衣', summary["_yi_"]!, Colors.blue),
          PieData('食', summary["_shi_"]!, Colors.red),
          PieData('住', summary["_zhu_"]!, Colors.green),
          PieData('行', summary["_xing_"]!, Colors.amber),
        ];
        _productSales = [
          {'类型': '衣', 'sales': summary["yi"]},
          {'类型': '食', 'sales': summary["shi"]},
          {'类型': '住', 'sales': summary["zhu"]},
          {'类型': '行', 'sales': summary["xing"]},
        ];
        _monthlySales = [
          {'类型': '衣', 'sales': 0},
          {'类型': '食', 'sales': 0},
          {'类型': '住', 'sales': 0},
          {'类型': '行', 'sales': 0},
          {'类型': '衣', 'sales': 0},
          {'类型': '食', 'sales': 0},
          {'类型': '住', 'sales': 0},
        ];
        if (mounted) {
          setState(() {
            pieData = _pieData;
            monthlySales = _monthlySales;
            productSales = _productSales;
            land = [ // 重新初始化 land
              PieChartSample2(pieData: pieData),
              BarChartSample(productSales: productSales),
              LineChartSample(monthlySales: monthlySales),
            ];
          });
        }
    });
    logger.d(summary);

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
  List<PieData> pieData = [
    PieData('A', 25, Colors.blue),
    PieData('B', 25, Colors.red),
    PieData('C', 25, Colors.green),
    PieData('D', 25, Colors.amber),
  ];
  PieChartSample2({super.key,required this.pieData});
  @override
  State<StatefulWidget> createState() => PieChartSample2State();
}

class PieChartSample2State extends State<PieChartSample2> {
  int touchedIndex = -1;
  List<PieData> pieData = [
    PieData('A', 25, Colors.blue),
    PieData('B', 25, Colors.red),
    PieData('C', 25, Colors.green),
    PieData('D', 25, Colors.amber),
  ];
  @override
  void didUpdateWidget(covariant PieChartSample2 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.pieData != oldWidget.pieData && mounted){
      setState(() {
        logger.d("2222");
        pieData = widget.pieData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


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

//折线图
class LineChartSample extends StatefulWidget {
  List<Map<String, dynamic>> monthlySales = [];
  LineChartSample({super.key,required this.monthlySales});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  List<Map<String, dynamic>> monthlySales = [
    {'类型': '衣', 'sales': 0.0},
    {'类型': '食', 'sales': 0.0},
    {'类型': '住', 'sales': 0.0},
    {'类型': '行', 'sales': 0.0},
  ];
  @override
  void didUpdateWidget(covariant LineChartSample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.monthlySales!=oldWidget.monthlySales && mounted){
      setState(() {
        monthlySales = widget.monthlySales;
      });
    }
  }
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
                      monthlySales[value.toInt()]['类型'],
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



//条形图
class BarChartSample extends StatefulWidget {
  List<Map<String, dynamic>> productSales = [];
  BarChartSample({super.key,required this.productSales});

  @override
  State<BarChartSample> createState() => _BarChartSampleState();
}

class _BarChartSampleState extends State<BarChartSample> {
  List<Map<String, dynamic>> productSales = [
    {'类型': '衣', 'sales': 0.0},
    {'类型': '食', 'sales': 0.0},
    {'类型': '住', 'sales': 0.0},
    {'类型': '行', 'sales': 0.0},
  ];
  @override
  void didUpdateWidget(covariant BarChartSample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.productSales!=oldWidget.productSales && mounted){
      setState(() {
        productSales = widget.productSales;
      });
    }
  }

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
                      productSales[value.toInt()]['类型'],
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
                    ), toY: entry.value["sales"],
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
