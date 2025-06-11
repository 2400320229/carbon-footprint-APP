import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_try/Base/Item.dart';
import 'package:flutter_try/Tab/Home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/DataBase.dart';
import 'package:logger/logger.dart';
import '../Pages/main.dart';

var logger = Logger();
List<CountNode> data = [];
Map<String,double> summary = {};


class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _OpenState();
}

class _OpenState extends State<DataPage> {
  bool check1 = false;
  bool check2 = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                      width: 250,
                      height: 200,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF578063),
                      ),
                      child: Text("本地数据",style: TextStyle(
                          fontSize: 30
                      ),)
                  ),
                  onTap: (){
                    setState(() {
                      check1 = true;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(

                  child: Container(
                      alignment: Alignment.center,
                      width: 250,
                      height: 200,
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF9E8867),
                      ),
                      child: Text("账号数据",style: TextStyle(
                          fontSize: 30
                      ),)
                  ),
                  onTap: (){
                    setState(() {
                      check2 = true;
                    });
                  },
                ),
              ],
            )

          ],
        ),
        if(check1)
          Setting_page(show: (){
            setState(() {
              logger.d("back 1");
              check1 = false;
            });
          },),
        if(check2)
          LandSetting(show: (){
            setState(() {
              logger.d("back 2");
              check2 = false;
            });
          },),
      ],
    );
  }
}

class Setting_page extends StatefulWidget {
  final VoidCallback show;
  Setting_page({super.key,required this.show});

  @override
  State<Setting_page> createState() => _Setting_pageState();
}

class _Setting_pageState extends State<Setting_page> {

  Timer? _timer;
  List<PieData> pieData = [];
  List<Map<String, dynamic>> monthlySales = [];
  List<Map<String, dynamic>> productSales = [];
  List<Widget> land=[
    Text("总共产生碳足迹:"),
    PieChartSample2(pieData: [],),
    BarChartSample(productSales: [],),
    LineChartSample(monthlySales: [],)
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
      decoration: BoxDecoration(
          color: Colors.white
      ),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Row(children: [SizedBox(width: 10,),IconButton(onPressed: (){
                logger.d("back kk 1");
                widget.show();
                }, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
              Expanded(child: ListView(
              children: [
                ListTile(
                  title:Column(
                    children:land ,
                  ),
                )
              ],
            ))]
        )
    );
  }
  init()async{
    /*final p = await SharedPreferences.getInstance();
    is_land = await p.getBool("is_land");
    if(is_land == true){
      land = [Column(
      )];
    }else{*/
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
    DateTime now = DateTime.now();
    DateTime now_1 = now.subtract(Duration(days: 1));
    DateTime now_2 = now.subtract(Duration(days: 2));
    DateTime now_3 = now.subtract(Duration(days: 3));
    DateTime now_4 = now.subtract(Duration(days: 4));
    DateTime now_5 = now.subtract(Duration(days: 5));
    DateTime now_6 = now.subtract(Duration(days: 6));
    String date = now.toString().split(" ")[0];
    logger.d("data:::"+date);
    List<double> C_everday = [0,0,0,0,0,0,0];
    List<PieData> _pieData = [];
    List<Map<String, dynamic>> _productSales = [];
    List<Map<String, dynamic>> _monthlySales = [];
    for(var a in data){
      if(a.date.split(' ')[0] == now.toString().split(' ')[0]){
        C_everday[0] += a.count;
      }
      if(a.date.split(' ')[0] == now_1.toString().split(' ')[0]){
        C_everday[1] += a.count;
      }
      if(a.date.split(' ')[0] == now_2.toString().split(' ')[0]){
        C_everday[2] += a.count;
      }
      if(a.date.split(' ')[0] == now_3.toString().split(' ')[0]){
        C_everday[3] += a.count;
      }
      if(a.date.split(' ')[0] == now_4.toString().split(' ')[0]){
        C_everday[4] += a.count;
      }
      if(a.date.split(' ')[0] == now_5.toString().split(' ')[0]){
        C_everday[5] += a.count;
      }
      if(a.date.split(' ')[0] == now_6.toString().split(' ')[0]){
        C_everday[6] += a.count;
      }
    }
    var all = s_shi+s_yi+s_xing+s_zhu;
    _timer =Timer(Duration(milliseconds: 500),(){
      summary = {
        "sum":s_shi+s_xing+s_zhu+s_yi,
        "yi":s_yi,
        "shi":s_shi,
        "zhu":s_zhu,
        "xing":s_xing,
        "_yi_":double.parse((s_yi/all*100).toStringAsFixed(2)),
        "_shi_":double.parse((s_shi/all*100).toStringAsFixed(2)),
        "_zhu_":double.parse((s_zhu/all*100).toStringAsFixed(2)),
        "_xing_":double.parse((s_xing/all*100).toStringAsFixed(2)),
      };
      _pieData = (summary["yi"]==0 && summary["shi"]==0 && summary["zhu"]==0 && summary["xing"]==0)? [
        PieData('A', 25, Colors.blue),
        PieData('B', 25, Colors.red),
        PieData('C', 25, Colors.green),
        PieData('D', 25, Colors.amber),
      ]:[
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
        {
          '类型': now_6.toString().split(' ')[0].split("-")[1]+"-"+now_6.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[6]
        },
        {
          '类型': now_5.toString().split(' ')[0].split("-")[1]+"-"+now_5.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[5]
        },
        {
          '类型': now_4.toString().split(' ')[0].split("-")[1]+"-"+now_4.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[4]
        },
        {
          '类型': now_3.toString().split(' ')[0].split("-")[1]+"-"+now_3.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[3]
        },
        {
          '类型': now_2.toString().split(' ')[0].split("-")[1]+"-"+now_2.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[2]
        },
        {
          '类型': now_1.toString().split(' ')[0].split("-")[1]+"-"+now_1.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[1]
        },
        {
          '类型': now.toString().split(' ')[0].split("-")[1]+"-"+now.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[0]
        },
      ];
      if (mounted) {
        setState(() {
          pieData = _pieData;
          monthlySales = _monthlySales;
          productSales = _productSales;
          land = [
            Text("总共产生碳足迹:"+summary["sum"]!.toString()),// 重新初始化 land
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

class LandSetting extends StatefulWidget {
  final VoidCallback show;
  LandSetting({super.key,required this.show});

  @override
  State<LandSetting> createState() => _LandSettingState();
}

class _LandSettingState extends State<LandSetting> {
  bool? is_land = false;
  Timer? _timer;
  List<PieData> pieData = [];
  List<Map<String, dynamic>> monthlySales = [];
  List<Map<String, dynamic>> productSales = [];
  List<Widget> land=[
    Text("总共产生碳足迹:"),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  Future<void> init() async {
    data = [];
    try {
      final p = await SharedPreferences.getInstance();
      var aa = await p.getBool("is_land") ?? false; // 添加默认值
      setState(() {
        is_land = aa;
      });
      var ip = await p.getString("ip") ?? "localhost"; // 添加默认值
      var email = await p.getString("user_email") ?? ""; // 添加默认值

      // 检查必要参数
      if (ip.isEmpty || email.isEmpty) {
        logger.e("缺少必要参数: IP或邮箱为空");
        return;
      }

      final response = await http.get(
        Uri.parse('http://$ip:8000/get_data?email=${email}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        logger.e("API请求失败: ${response.statusCode}");
        return;
      }

      logger.d("API响应: ${response.body}");

      // 解析JSON
      final jsonMap = json.decode(response.body) as Map<String, dynamic>;
      final message = jsonMap['message'] as String?;

      if (message == null || message.isEmpty) {
        logger.e("API返回的message为空");
        return;
      }

      // 同步处理所有数据
      final items = message.split('|')
        ..removeWhere((item) => item.isEmpty); // 移除空字符串

      for (final item in items) {
        logger.d("处理项目: $item");
        final parts = item.split('?');

        // 验证数据格式
        if (parts.length < 3) {
          logger.w("格式错误的项目: $item");
          continue;
        }

        // 安全解析数值
        final countStr = parts[0];
        final typeStr = parts[1];
        final dateStr = parts[2];

        final count = double.tryParse(countStr) ?? 0.0;
        final type = int.tryParse(typeStr) ?? 0;

        data.add(CountNode(count: count, type: type, date: dateStr));
        logger.d("添加节点: count=$count, type=$type, date=$dateStr");
      }

      // 处理完成后使用数据
      logger.d("共处理 ${data.length} 个节点");
      Timer(Duration(milliseconds: 500),(){
        analyze_data();
      });

    } catch (e, stackTrace) {
      logger.e("初始化过程中出错: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white
        ),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Row(children: [SizedBox(width: 10,),IconButton(onPressed: (){
                widget.show();
              }, icon: ImageIcon(AssetImage("images/icons/back.png")))],),
              Expanded(child: ListView(
              children: [
                ListTile(
                  title:Column(
                    children:is_land == true?land :un_land,
                  ),
                )
              ],
            ))]
        )
    );
  }

  analyze_data() async {
    logger.d(data);
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
    DateTime now = DateTime.now();
    DateTime now_1 = now.subtract(Duration(days: 1));
    DateTime now_2 = now.subtract(Duration(days: 2));
    DateTime now_3 = now.subtract(Duration(days: 3));
    DateTime now_4 = now.subtract(Duration(days: 4));
    DateTime now_5 = now.subtract(Duration(days: 5));
    DateTime now_6 = now.subtract(Duration(days: 6));
    String date = now.toString().split(" ")[0];
    logger.d("data:::"+date);
    List<double> C_everday = [0,0,0,0,0,0,0];
    List<PieData> _pieData = [];
    List<Map<String, dynamic>> _productSales = [];
    List<Map<String, dynamic>> _monthlySales = [];
    for(var a in data){
      if(a.date.split(' ')[0] == now.toString().split(' ')[0]){
        C_everday[0] += a.count;
      }
      if(a.date.split(' ')[0] == now_1.toString().split(' ')[0]){
        C_everday[1] += a.count;
      }
      if(a.date.split(' ')[0] == now_2.toString().split(' ')[0]){
        C_everday[2] += a.count;
      }
      if(a.date.split(' ')[0] == now_3.toString().split(' ')[0]){
        C_everday[3] += a.count;
      }
      if(a.date.split(' ')[0] == now_4.toString().split(' ')[0]){
        C_everday[4] += a.count;
      }
      if(a.date.split(' ')[0] == now_5.toString().split(' ')[0]){
        C_everday[5] += a.count;
      }
      if(a.date.split(' ')[0] == now_6.toString().split(' ')[0]){
        C_everday[6] += a.count;
      }
    }
    var all = s_shi+s_yi+s_xing+s_zhu;
    _timer =Timer(Duration(milliseconds: 500),(){
      summary = {
        "sum":s_shi+s_xing+s_zhu+s_yi,
        "yi":s_yi,
        "shi":s_shi,
        "zhu":s_zhu,
        "xing":s_xing,
        "_yi_":double.parse((s_yi/all*100).toStringAsFixed(2)),
        "_shi_":double.parse((s_shi/all*100).toStringAsFixed(2)),
        "_zhu_":double.parse((s_zhu/all*100).toStringAsFixed(2)),
        "_xing_":double.parse((s_xing/all*100).toStringAsFixed(2)),
      };
      _pieData = (summary["yi"]==0 && summary["shi"]==0 && summary["zhu"]==0 && summary["xing"]==0)? [
        PieData('A', 25, Colors.blue),
        PieData('B', 25, Colors.red),
        PieData('C', 25, Colors.green),
        PieData('D', 25, Colors.amber),
      ]:[
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
        {
          '类型': now_6.toString().split(' ')[0].split("-")[1]+"-"+now_6.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[6]
        },
        {
          '类型': now_5.toString().split(' ')[0].split("-")[1]+"-"+now_5.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[5]
        },
        {
          '类型': now_4.toString().split(' ')[0].split("-")[1]+"-"+now_4.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[4]
        },
        {
          '类型': now_3.toString().split(' ')[0].split("-")[1]+"-"+now_3.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[3]
        },
        {
          '类型': now_2.toString().split(' ')[0].split("-")[1]+"-"+now_2.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[2]
        },
        {
          '类型': now_1.toString().split(' ')[0].split("-")[1]+"-"+now_1.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[1]
        },
        {
          '类型': now.toString().split(' ')[0].split("-")[1]+"-"+now.toString().split(' ')[0].split("-")[2],
          'sales': C_everday[0]
        },
      ];
      if (mounted) {
        setState(() {
          pieData = _pieData;
          monthlySales = _monthlySales;
          productSales = _productSales;
          land = [
            Text("总共产生碳足迹:"+summary["sum"]!.toString()),// 重新初始化 land
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
      final fontSize = isTouched ? 16.0 : 16.0;
      final radius = isTouched ? 70.0 : 50.0;
      final title = isTouched ? pieData[i].value.toString()+"%":pieData[i].label;

      return PieChartSectionData(
        color: pieData[i].color,
        value: pieData[i].value,
        title: '${title}',
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
  double max_Y = 100;
  @override
  void didUpdateWidget(covariant LineChartSample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    double sum = 0;
    if(widget.monthlySales!=oldWidget.monthlySales && mounted){

      for(var a in widget.monthlySales){
        logger.d(a["sales"]);
        sum += a["sales"];
      }
      setState(() {
        monthlySales = widget.monthlySales;
        max_Y = sum;
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
              verticalInterval: 1,
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
                  interval: 1,
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
              rightTitles: AxisTitles( // 如果需要左侧也显示标签
                sideTitles: SideTitles(showTitles: false), // 默认隐藏
              ),
              topTitles: AxisTitles( // 如果需要左侧也显示标签
                sideTitles: SideTitles(showTitles: false), // 默认隐藏
              ),
              leftTitles: AxisTitles(  // 替换 SideTitles
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
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
                isCurved: false, // 是否使用曲线
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
            maxY: max_Y, // y轴最大值
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (touchedSpot) => Colors.blueGrey, // 替代 tooltipBgColor
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    return LineTooltipItem('',
                      const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '${spot.y.toInt()}',
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
            ),
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
  double max_Y = 100;
  @override
  void didUpdateWidget(covariant BarChartSample oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    double sum = 0;
    if(widget.productSales!=oldWidget.productSales && mounted){
      for(var a in widget.productSales){
        logger.d(a["sales"]);
        sum += a["sales"];
      }
      setState(() {
        productSales = widget.productSales;
        max_Y = sum;
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
                  strokeWidth: 1.0,
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
                rightTitles: AxisTitles( // 如果需要左侧也显示标签
                  sideTitles: SideTitles(showTitles: false), // 默认隐藏
                ),
                topTitles: AxisTitles( // 如果需要左侧也显示标签
                  sideTitles: SideTitles(showTitles: false), // 默认隐藏
                ),
                leftTitles: AxisTitles(  // 替换 SideTitles
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}',
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

              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  //tooltipBgColor: Colors.blueGrey,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    // 获取当前数据
                    final item = productSales[group.x.toInt()];
                    return BarTooltipItem(
                      '${item['类型']}\n', // 第一行显示类型
                      TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: '${rod.toY.toInt()}', // 第二行显示数值
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    );
                  },
                  // 其他提示框样式配置
                  tooltipPadding: EdgeInsets.all(8),
                  tooltipMargin: 10,
                  fitInsideHorizontally: true, // 避免提示框超出屏幕
                ),
              ),
              // ---- 其他配置 ----
              maxY: max_Y, // y轴最大值
            )
        ),
      ),
    );
  }
}
