import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/home/add_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class HomePieChart extends StatelessWidget {
  HomePieChart(
      {super.key,
      required this.isExpense,
      required this.listAccount,
      required this.currentAccount,
      required this.listExpense,
      required this.onPressedDate,
      required this.onPressedMonth,
      required this.onPressedYear,
      required this.onPressedRange,
      required this.onPressedAll,
      required this.onPressedCustom,
      required this.time,
      required this.dateRange,
      required this.typeTime});
  bool isExpense;
  final List<Account> listAccount;
  final Account currentAccount;
  final List<List<Expense>> listExpense;
  final Function() onPressedDate;
  final Function() onPressedMonth;
  final Function() onPressedYear;
  final Function() onPressedRange;
  final Function() onPressedCustom;
  final Function() onPressedAll;
  final DateTime time;
  final List<DateTime?> dateRange;
  final String typeTime;

  int getTotalExpense() {
    int total = 0;
    for (var list in listExpense) {
      for (var expense in list) {
        total += expense.amount;
      }
    }
    return total;
  }

  double getTotalEachCategory(List<Expense> list) {
    double total = 0;
    for (var expense in list) {
      total += expense.amount;
    }
    return total;
  }

  String moneyFormat() {
    var format = NumberFormat.compactSimpleCurrency(
        locale: currentAccount.currencyLocale);
    return format.format(getTotalExpense());
  }

  int getColor(List<Expense> list) {
    return list[0].color;
  }

  String formatDateRange() {
    if (dateRange.isNotEmpty) {
      if (dateRange.elementAt(0)!.year != dateRange.last!.year) {
        return 'từ ${dateRange.elementAt(0)!.day} thg ${dateRange.elementAt(0)!.month}, ${dateRange.elementAt(0)!.year} đến ${dateRange.last!.day} thg ${dateRange.last!.month}, ${dateRange.last!.year}';
      } else {
        return 'từ ${dateRange.elementAt(0)!.day} thg ${dateRange.elementAt(0)!.month} đến ${dateRange.last!.day} thg ${dateRange.last!.month}, ${dateRange.last!.year}';
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
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
                      onPressedAll();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'all'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Mọi lúc',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onPressedDate();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'day'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Ngày',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onPressedMonth();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'month'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Tháng',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onPressedYear();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'year'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Năm',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      onPressedRange();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'range'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Khoảng thời gian',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: typeTime != 'all' ? onPressedCustom : null,
                child: Container(
                  decoration: BoxDecoration(
                    border: typeTime != 'all'
                        ? const Border(
                            bottom: BorderSide(width: 1, color: Colors.black),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  child: Text(
                    typeTime == 'day'
                        ? 'Ngày ${time.day} tháng ${time.month}'
                        : typeTime == 'month'
                            ? 'Tháng ${time.month} năm ${time.year}'
                            : typeTime == 'year'
                                ? '${time.year}'
                                : typeTime == 'all'
                                    ? 'Mọi lúc'
                                    : formatDateRange(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width - 170,
                    child: PieChart(
                      swapAnimationDuration: const Duration(milliseconds: 500),
                      PieChartData(
                        sections: listExpense.isNotEmpty
                            ? List.generate(
                                listExpense.length,
                                (index) => PieChartSectionData(
                                    value: getTotalEachCategory(
                                        listExpense[index]),
                                    showTitle: false,
                                    color: Color(getColor(listExpense[index]))),
                              )
                            : [
                                PieChartSectionData(
                                    value: 1,
                                    showTitle: false,
                                    color: Colors.grey),
                              ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: listExpense.isNotEmpty ? () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(16),
                            content: SizedBox(
                              child: Text(
                                NumberFormat.simpleCurrency(
                                  locale: currentAccount.currencyLocale,
                                ).format(
                                  getTotalExpense(),
                                ),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      );
                    } : null,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width - 290,
                      width: MediaQuery.of(context).size.width - 290,
                      child: Center(
                        child: Text(
                          listExpense.isNotEmpty
                              ? moneyFormat()
                              : isExpense
                                  ? 'Không có chi phí nào'
                                  : 'Không có thu nhập nào',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(255, 177, 32, 1),
                      ),
                      child: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddExpense(
                                          isExpense: isExpense,
                                          listAccount: listAccount,
                                          currentAccount: currentAccount,
                                        )));
                          },
                          icon: const Icon(Icons.add)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
