import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/home/add_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePieChart extends StatelessWidget {
  HomePieChart(
      {super.key,
      required this.isExpense,
      required this.listAccount,
      required this.currentAccount,
      required this.listExpense});
  bool isExpense;
  final List<Account> listAccount;
  final Account currentAccount;
  final List<List<Expense>> listExpense;

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

  int getColor(List<Expense> list) {
    return list[0].color;
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Ngày',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Tuần',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Tháng',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    'Năm',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '4 thg 3 - 10 thg 3',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width - 300,
                    width: MediaQuery.of(context).size.width - 300,
                    child: Center(
                      child: Text(
                        listExpense.isNotEmpty 
                            ? '${getTotalExpense()}'
                            : isExpense ? 'Không có chi phí nào' : 'Không có thu nhập nào',
                        style: const TextStyle(color: Colors.black, fontSize: 22), textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
