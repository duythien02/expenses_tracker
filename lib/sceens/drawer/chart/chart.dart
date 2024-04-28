import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/chart/bar_chart.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key,required this.expenseData, required this.account});
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String typeChart = 'all';
  String typeTime = 'day';
  DateTime timeNow = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  double getTotalAmountEachCategory(List<Expense> expenses) {
    return expenses.map((expense) => expense.amount).fold(0, (a, b) => a + b);
  }
  Map<String, List<Expense>> sortExpenseData(Map<String, List<Expense>> data){
    var sortedKeys = data.keys.toList()
      ..sort((a, b) {
        double totalA = getTotalAmountEachCategory(
            data[b]!);
        double totalB = getTotalAmountEachCategory(
            data[a]!);
        return totalB.compareTo(totalA);
    });
    Map<String, List<Expense>> sortedByTotal = {};
    for (var key in sortedKeys) {
      sortedByTotal[key] = data[key]!;
    }
    return sortedByTotal;
  }

  List<Map<String, List<Expense>>> classifyExpense(String time) {
    Map<dynamic, List<Expense>> newMap = {};
    switch (typeChart){
      case 'expense':{
      widget.expenseData.forEach((key, value) {
        if (value.any((element) => element.type == true)) {
          newMap[key] = value;
        }
      });
      }
      break;
      case 'income':{
        widget.expenseData.forEach((key, value) {
          if (value.any((element) => element.type == false)) {
            newMap[key] = value;
          }
        });
      }
      break;
    }
    List<Map<String, List<Expense>>> filteredExpenses = [];
    switch (time) {
      case 'day':
        {
          DateTime now = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          for(int countDay = 5; countDay >= 0; countDay--){
            DateTime newDate = now.subtract(Duration(days: countDay));
            Map<String, List<Expense>> expensesForDay = {};
            List<Expense> filteredExpensesForCategory = [];
            newMap.forEach((categoryId, expenses) {
              for(var expense in expenses){
                if(expense.date.year == newDate.year && expense.date.month == newDate.month && expense.date.day == newDate.day){
                  filteredExpensesForCategory.add(expense);
                }
              }
              if(filteredExpensesForCategory.isNotEmpty){
                expensesForDay[categoryId] = filteredExpensesForCategory;
                filteredExpensesForCategory = [];
              }
            });
            if(expensesForDay.isEmpty){
              expensesForDay['emptyData'] = [];
            }
            filteredExpenses.add(sortExpenseData(expensesForDay));
          }
        }
        break;
      case 'month':
        {
          int countMonth = 5;
          for(countMonth; countMonth >= 0; countMonth--){
            DateTime now = DateTime.utc(DateTime.now().year, DateTime.now().month - countMonth);
            Map<String, List<Expense>> expensesForMonth = {};
            List<Expense> filteredExpensesForCategory = [];
            newMap.forEach((categoryId, expenses) {
              for(var expense in expenses){
                if(expense.date.year == now.year && expense.date.month == now.month ){
                  filteredExpensesForCategory.add(expense);
                }
              }
              if(filteredExpensesForCategory.isNotEmpty){
                expensesForMonth[categoryId] = filteredExpensesForCategory;
                filteredExpensesForCategory = [];
              }
            });
            if(expensesForMonth.isEmpty){
              expensesForMonth['emptyData'] = [];
            }
            filteredExpenses.add(sortExpenseData(expensesForMonth));
          }
        }
        break;
      case 'year':
        {
          int countYear = 5;
          for(countYear; countYear >= 0; countYear--){
            DateTime now = DateTime.utc(DateTime.now().year - countYear);
            Map<String, List<Expense>> expensesForYear = {};
            List<Expense> filteredExpensesForCategory = [];
            newMap.forEach((categoryId, expenses) {
              for(var expense in expenses){
                if(expense.date.year == now.year){
                  filteredExpensesForCategory.add(expense);
                }
              }
                if(filteredExpensesForCategory.isNotEmpty){
                  expensesForYear[categoryId] = filteredExpensesForCategory;
                  filteredExpensesForCategory = [];
                }
            });
            if(expensesForYear.isEmpty){
              expensesForYear['emptyData'] = [];
            }
            filteredExpenses.add(sortExpenseData(expensesForYear));
          }
        }
        break;
    }
    return filteredExpenses;
  }

  List<Map<String,Map<String, List<Expense>>>> allExpenseByTime(String time){
    List<Map<String,Map<String, List<Expense>>>> filteredExpenses = [];
    switch (time) {
      case 'day':
        {
          DateTime now = DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          for(int countDay = 4; countDay >= 0; countDay--){
            DateTime newDate = now.subtract(Duration(days: countDay));
            Map<String,Map<String, List<Expense>>> classifyExpense = {
              'expenses': {},
              'incomes': {},
            };
            widget.expenseData.forEach((categoryId, expenses) {
              Map<String, List<Expense>> expensesGroupedByCategory = {};
              List<Expense> filteredExpensesForCategory = [];
              for(var expense in expenses){
                if(expense.date.year == newDate.year && expense.date.month == newDate.month && expense.date.day == newDate.day){
                  filteredExpensesForCategory.add(expense);
                }
              }
              if(filteredExpensesForCategory.isNotEmpty){
                expensesGroupedByCategory[categoryId] = filteredExpensesForCategory;
                if(filteredExpensesForCategory[0].type){
                  classifyExpense['expenses']!.addAll(expensesGroupedByCategory);
                }else{
                  classifyExpense['incomes']!.addAll(expensesGroupedByCategory);
                }
              }
            });
            filteredExpenses.add(classifyExpense);
          }
        }
        break;
      case 'month':
        {
          for(int countMonth = 4; countMonth >= 0; countMonth--){
            DateTime newDate = DateTime.utc(DateTime.now().year, DateTime.now().month - countMonth);
            Map<String,Map<String, List<Expense>>> classifyExpense = {
              'expenses': {},
              'incomes': {},
            };
            widget.expenseData.forEach((categoryId, expenses) {
              Map<String, List<Expense>> expensesGroupedByCategory = {};
              List<Expense> filteredExpensesForCategory = [];
              for(var expense in expenses){
                if(expense.date.year == newDate.year && expense.date.month == newDate.month){
                  filteredExpensesForCategory.add(expense);
                }
              }
              if(filteredExpensesForCategory.isNotEmpty){
                expensesGroupedByCategory[categoryId] = filteredExpensesForCategory;
                if(filteredExpensesForCategory[0].type){
                  classifyExpense['expenses']!.addAll(expensesGroupedByCategory);
                }else{
                  classifyExpense['incomes']!.addAll(expensesGroupedByCategory);
                }
              }
            });
            filteredExpenses.add(classifyExpense);
          }
        }
        break;
      case 'year':
        {
          for(int countYear = 4; countYear >= 0; countYear--){
            DateTime newDate = DateTime.utc(DateTime.now().year - countYear);
            Map<String,Map<String, List<Expense>>> classifyExpense = {
              'expenses': {},
              'incomes': {},
            };
            widget.expenseData.forEach((categoryId, expenses) {
              List<Expense> filteredExpensesForCategory = [];
              Map<String, List<Expense>> expensesGroupedByCategory = {};
              for(var expense in expenses){
                if(expense.date.year == newDate.year){
                  filteredExpensesForCategory.add(expense);
                }
              }
              if(filteredExpensesForCategory.isNotEmpty){
                expensesGroupedByCategory[categoryId] = filteredExpensesForCategory;
                if(filteredExpensesForCategory[0].type){
                  classifyExpense['expenses']!.addAll(expensesGroupedByCategory);
                }else{
                  classifyExpense['incomes']!.addAll(expensesGroupedByCategory);
                }
              }
            });
            filteredExpenses.add(classifyExpense);
          }
        }
        break;
    }

    return filteredExpenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biểu đồ'),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.hasData) {
            return MainDrawer(
              user: user.data!,
              expenseData: widget.expenseData,
              account: widget.account,
            );
          }
          return Container();
        },
      ),
      body: Stack(
        children: [
          Container(
            height: 104,
            decoration: ShapeDecoration(
              color: kColorScheme.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
            ),
          ),
          Column(
            children: [
              Container(
                height: 45,
                decoration: ShapeDecoration(
                  color: kColorScheme.primary,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30))),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (typeChart != 'all') {
                            setState(() {
                              typeChart = 'all';
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: typeChart == 'all'
                                  ? const Border(
                                      bottom:
                                          BorderSide(width: 2, color: Colors.white))
                                  : const Border(bottom: BorderSide.none)),
                          child: Text(
                            'CHUNG',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight:
                                    typeChart == 'all' ? FontWeight.w600 : FontWeight.w400),
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          if (typeChart != 'expense') {
                            setState(() {
                              typeChart = 'expense';
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: typeChart == 'expense'
                                  ? const Border(
                                      bottom:
                                          BorderSide(width: 2, color: Colors.white))
                                  : const Border(bottom: BorderSide.none)),
                          child: Text(
                            'CHI PHÍ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight:
                                    typeChart == 'expense' ? FontWeight.w600 : FontWeight.w400),
                          ),
                        )),
                    TextButton(
                      onPressed: () {
                        if (typeChart != 'income') {
                          setState(() {
                            typeChart = 'income';
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: typeChart == 'income'
                                ? const Border(
                                    bottom:
                                        BorderSide(width: 2, color: Colors.white))
                                : const Border(bottom: BorderSide.none)),
                        child: Text(
                          'THU NHẬP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                typeChart == 'income' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnalysisBarChart(
                typeChart: typeChart,
                typeTime: typeTime,
                account: widget.account,
                classifyExpense: classifyExpense(typeTime),
                allExpenseData: allExpenseByTime(typeTime),
                onPressedDate: (){
                  if (typeTime != 'day') {
                    setState(() {
                      typeTime = 'day';
                    });
                  }
                },
                onPressedMonth: () {
                  if (typeTime != 'month') {
                    setState(() {
                      typeTime = 'month';
                    });
                  }
                },
                onPressedYear: () {
                  if (typeTime != 'year') {
                    setState(() {
                      typeTime = 'year';
                    });
                  }
                },
                refresh: true,
              )
            ]
          ),
        ],
      )
    );
  }
}