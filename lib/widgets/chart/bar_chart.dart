import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/home/expense/expense_card_item.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnalysisBarChart extends StatefulWidget {
  AnalysisBarChart({super.key, required this.typeChart,required this.typeTime, required this.account, required this.classifyExpense, required this.allExpenseData, required this.onPressedDate, required this.onPressedMonth, required this.onPressedYear,required this.refresh});

  String typeChart;
  String typeTime;
  final Account account;
  List<Map<String, List<Expense>>> classifyExpense;
  List<Map<String,Map<String, List<Expense>>>> allExpenseData;
  final Function() onPressedDate;
  final Function() onPressedMonth;
  final Function() onPressedYear;
  bool refresh;

  @override
  State<AnalysisBarChart> createState() => _AnalysisBarChartState();
} 

class _AnalysisBarChartState extends State<AnalysisBarChart> {
  late int showingTooltip;
  late int indexBar;
  late Map<String,List<Expense>> mapExpense;

  List<Map<String,Map<String,dynamic>>> calDifference(){

    List<Map<String,Map<String,dynamic>>> newExpenseData = [];

    for(var data in widget.allExpenseData){
      Map<String,Map<String,dynamic>> mapData = {};

      double differrenceTotal = 0;
      double expenseTotal = 0;
      double incomeTotal = 0;

      Map<String, dynamic> mapExpenseData = {};
      mapExpenseData['data'] = data['expenses'];
      data['expenses']!.forEach((key, value) { 
        for(var expense in value){
          expenseTotal += expense.amount;
        }
      });
      mapExpenseData['totalY'] = expenseTotal;
      mapExpenseData['color'] = Colors.yellow;

      Map<String, dynamic> mapIncomeData = {};
      mapIncomeData['data'] = data['incomes'];
      data['incomes']!.forEach((key, value) { 
        for(var expense in value){
          incomeTotal += expense.amount;
        }
      });
      mapIncomeData['totalY'] = incomeTotal;
      mapIncomeData['color'] = Colors.green;

      Map<String, dynamic> differenceData = {};
      expenseTotal > incomeTotal
          ? differrenceTotal = expenseTotal - incomeTotal
          : differrenceTotal = incomeTotal - expenseTotal;
      differenceData['totalY'] = differrenceTotal;
      differenceData['color'] = expenseTotal < incomeTotal ? Colors.blue : Colors.orange;
      
      mapData['expensesData'] = mapExpenseData;
      mapData['incomesData'] = mapIncomeData;
      mapData['difference'] = differenceData;

      newExpenseData.add(mapData);
    }

    return newExpenseData;
  }

  double getTotalCostsAllExpense(Map<String, List<Expense>> expenseData) {
    double total = 0;
    for (var element in expenseData.values) {
      for (var expense in element) {
        total += expense.amount;
      }
    }
    return total;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10,color: Colors.black);
    String text = '';
    DateTime now = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if(widget.typeTime == 'day'){
      switch (value.toInt()) {
        case 0:
          text = widget.typeChart == 'all' 
          ? '${now.subtract(const Duration(days: 4)).day} Thg ${now.month}'  
          : '${now.subtract(const Duration(days: 5)).day} Thg ${now.month}';
          break;
        case 1:
          text = widget.typeChart == 'all'
          ? '${now.subtract(const Duration(days: 3)).day} Thg ${now.month}'  
          : '${now.subtract(const Duration(days: 4)).day} Thg ${now.month}';
          break;
        case 2:
          text = widget.typeChart == 'all'
          ? '${now.subtract(const Duration(days: 2)).day} Thg ${now.month}'  
          : '${now.subtract(const Duration(days: 3)).day} Thg ${now.month}';
          break;
        case 3:
          text = widget.typeChart == 'all'
          ? '${now.subtract(const Duration(days: 1)).day} Thg ${now.month}'  
          : '${now.subtract(const Duration(days: 2)).day} Thg ${now.month}';
          break;
        case 4:
          text = widget.typeChart == 'all'
          ? '${now.day} Thg ${now.month}'  
          : '${now.subtract(const Duration(days: 1)).day} Thg ${now.month}';
          break;
        case 5:
          text = '${now.day} Thg ${now.month}';
          break;
      }
    }else if(widget.typeTime == 'month'){
      switch (value.toInt()) {
        case 0:
          if(widget.typeChart == 'all'){
            var newDate = DateTime(now.year, now.month - 4);
            text = 'Thg ${newDate.month}';
          }else{
            var newDate = DateTime(now.year, now.month - 5);
            text = 'Thg ${newDate.month}';
          } 
          break;
        case 1:
          if(widget.typeChart == 'all'){
            var newDate = DateTime(now.year, now.month - 3);
            text = 'Thg ${newDate.month}';
          }else{
            var newDate = DateTime(now.year, now.month - 4);
            text = 'Thg ${newDate.month}';
          } 
          break;
        case 2:
          if(widget.typeChart == 'all'){
            var newDate = DateTime(now.year, now.month - 2);
            text = 'Thg ${newDate.month}';
          }else{
            var newDate = DateTime(now.year, now.month - 3);
            text = 'Thg ${newDate.month}';
          } 
          break;
        case 3:
          if(widget.typeChart == 'all'){
            var newDate = DateTime(now.year, now.month - 1);
            text = 'Thg ${newDate.month}';
          }else{
            var newDate = DateTime(now.year, now.month - 2);
            text = 'Thg ${newDate.month}';
          } 
          break;
        case 4:
          if(widget.typeChart == 'all'){
            var newDate = DateTime(now.year, now.month);
            text = 'Thg ${newDate.month}';
          }else{
            var newDate = DateTime(now.year, now.month - 1);
            text = 'Thg ${newDate.month}';
          } 
          break;
        case 5:
          text = 'Thg ${now.month}';
          break;
      }
    }else{
      switch (value.toInt()) {
        case 0:
          text = widget.typeChart == 'all' 
          ? '${now.year - 4}'  
          : '${now.year - 5}';
          break;
        case 1:
          text = widget.typeChart == 'all'
          ? '${now.year - 3}'  
          : '${now.year - 4}';
          break;
        case 2:
          text = widget.typeChart == 'all'
          ? '${now.year - 2}'  
          : '${now.year - 3}';
          break;
        case 3:
          text = widget.typeChart == 'all'
          ? '${now.year - 1}'  
          : '${now.year - 2}';
          break;
        case 4:
          text = widget.typeChart == 'all'
          ? '${now.year}'  
          : '${now.year - 1}';
          break;
        case 5:
          text = '${now.year}';
          break;
      }
    }
    
    return SideTitleWidget(
      axisSide: AxisSide.bottom,
      child: Text(text, style: style),
    );
  }

  double getTotalCostsExpenseCard(List<Expense> expenses) {
    return expenses.map((expense) => expense.amount).fold(0, (a, b) => a + b);
  }

  Map<String, List<Expense>> sortExpenseData(Map<String, List<Expense>> data){
    var sortedKeys = data.keys.toList()
      ..sort((a, b) {
        double totalA = getTotalCostsExpenseCard(
            data[b]!);
        double totalB = getTotalCostsExpenseCard(
            data[a]!);
        return totalA.compareTo(totalB);
    });
    Map<String, List<Expense>> sortedByTotal = {};
    for (var key in sortedKeys) {
      sortedByTotal[key] = data[key]!;
    }
    return sortedByTotal;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.refresh){
      showingTooltip = -1;
      indexBar = -1;
      mapExpense = {};
      widget.refresh = false;
    }
    return Expanded(
      child: Column(
        children: [
          Card(
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 30,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            widget.onPressedDate();
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: widget.typeTime == 'day'
                                    ? Border(
                                        bottom: BorderSide(
                                            width: 2, color: kColorScheme.primary))
                                    : const Border(bottom: BorderSide.none)),
                            child: Text(
                              'Theo ngày',
                              style: TextStyle(
                                  color: kColorScheme.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onPressedMonth();
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: widget.typeTime == 'month'
                                    ? Border(
                                        bottom: BorderSide(
                                            width: 2, color: kColorScheme.primary))
                                    : const Border(bottom: BorderSide.none)),
                            child: Text(
                              'Theo tháng',
                              style: TextStyle(
                                  color: kColorScheme.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onPressedYear();
                            
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: widget.typeTime == 'year'
                                    ? Border(
                                        bottom: BorderSide(
                                            width: 2, color: kColorScheme.primary))
                                    : const Border(bottom: BorderSide.none)),
                            child: Text(
                              'Theo năm',
                              style: TextStyle(
                                  color: kColorScheme.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 72,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width - 260,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: BarChart(
                          swapAnimationDuration: const Duration(milliseconds: 0),
                          BarChartData(
                            barTouchData: BarTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (event, response) {
                                if (response != null && response.spot != null && event is FlTapUpEvent) {
                                  if(widget.typeChart == 'all'){
                                    if(response.spot!.touchedRodDataIndex < 2){
                                      mapExpense = calDifference()[response.spot!.touchedBarGroupIndex].values.elementAt(response.spot!.touchedRodDataIndex)['data'];
                                    }else{
                                      setState(() {
                                        mapExpense = {};
                                      });
                                    }
                                  }else{
                                    mapExpense = widget.classifyExpense[response.spot!.touchedBarGroupIndex];
                                  }
                                  setState(() {
                                    final x = response.spot!.touchedBarGroup.x;
                                    indexBar = response.spot!.touchedRodDataIndex;
                                    showingTooltip = x;
                                  });
                                }
                              },
                            ),
                            alignment: BarChartAlignment.spaceAround,
                            titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(),
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitles,
                              ),
                              ),
                            ),
                            borderData: FlBorderData(
                              border: const Border(bottom: BorderSide(width: 0.1))
                            ),
                            gridData: const FlGridData(
                              show: false,
                            ),
                            barGroups: List.generate(widget.typeChart == 'all' ? 5 : 6, (index1) {
                              Map<String, Map<String, dynamic>> allExpenseDataEachTime = widget.typeChart == 'all' ? calDifference()[index1] : {};
                              var classifyExpenseEachTime = widget.classifyExpense[index1];
                              double toYForRodData = 0;
                              double fromY = 0;
                              double toYForStackItem = 0;
                              classifyExpenseEachTime.forEach((categoryId, listExpense) {
                                for(var expense in listExpense){
                                  toYForRodData += expense.amount;
                                }
                              });
                              return BarChartGroupData(
                                x: index1,
                                groupVertically: widget.typeChart == 'all' ? null : true,
                                showingTooltipIndicators: showingTooltip == index1 ? [indexBar] : [],
                                barRods: widget.typeChart == 'all'
                                  ? List.generate(allExpenseDataEachTime.length, (index) {
                                      return BarChartRodData(
                                        fromY: 0,
                                        toY: double.parse(allExpenseDataEachTime.values.elementAt(index)['totalY'].toStringAsFixed(2)),
                                        color: allExpenseDataEachTime.values.elementAt(index)['color'],
                                        width: 10,
                                        borderRadius: BorderRadius.zero,
                                      );
                                    })
                                  : [
                                      BarChartRodData(
                                        rodStackItems: List.generate(classifyExpenseEachTime.length, (index) {
                                          List<Expense> expensesGroupedByCategory = widget.typeChart != 'all' && classifyExpenseEachTime.values.elementAt(index).isNotEmpty ? classifyExpenseEachTime.values.elementAt(index) : [];
                                          if(expensesGroupedByCategory.isNotEmpty){
                                            if(index > 0){
                                              fromY = toYForStackItem;
                                            }
                                            for(var expense in expensesGroupedByCategory){
                                              toYForStackItem += expense.amount;
                                            }
                                          }
                                          if(widget.typeChart != 'all' &&  classifyExpenseEachTime.values.elementAt(index).isEmpty){
                                            return BarChartRodStackItem(
                                              0,
                                              0,
                                              Colors.white,
                                            );
                                          }
                                          return BarChartRodStackItem(
                                            fromY,
                                            toYForStackItem,
                                            Color(expensesGroupedByCategory.elementAt(0).color),
                                          );
                                        }),
                                        toY: double.parse(toYForRodData.toStringAsFixed(2)),
                                        borderRadius: BorderRadius.zero,
                                        width: 20,
                                      )
                                    ]
                              );
                            })
                          )
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    widget.typeTime != 'year' 
                      ? Center(
                        child: Text(
                          widget.typeTime == 'day' 
                            ? 'Tháng ${DateTime.now().month} năm ${DateTime.now().month}' 
                            : '${DateTime.now().year}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                      : Container(),
                    const SizedBox(height: 12,),
                    if(widget.typeChart == 'all')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle
                                ),
                              ),
                              const Text(" - Chi phí", style: TextStyle(color: Colors.black,fontSize: 12),)
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle
                                ),
                              ),
                              const Text(" - Thu thập", style: TextStyle(color: Colors.black,fontSize: 12),)
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle
                                ),
                              ),
                              const Text(" - Lợi nhuận", style: TextStyle(color: Colors.black,fontSize: 12),)
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle
                                ),
                              ),
                              const Text(" - Lỗ", style: TextStyle(color: Colors.black,fontSize: 12),)
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  return ExpenseCard(
                    listExpense: sortExpenseData(mapExpense).values.elementAt(index),
                    account: widget.account,
                    total: getTotalCostsAllExpense(sortExpenseData(mapExpense)),
                  );
                },
                itemCount: mapExpense.length,
              ),
            )
        ],
      ),
    );
  }
}