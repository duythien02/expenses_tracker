import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/sceens/home/add_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomePieChart extends StatefulWidget {
  HomePieChart({super.key, required this.isExpense, required this.listAccount});
  bool isExpense;
  List<Account> listAccount;

  @override
  State<HomePieChart> createState() => _HomePieChartState();
}

class _HomePieChartState extends State<HomePieChart> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Card(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          //height: MediaQuery.of(context).size.width - 100,
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
                  Text(
                    '${widget.listAccount[0].accountBalance}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width - 170,
                    child: PieChart(
                        swapAnimationDuration: const Duration(milliseconds: 500),
                        PieChartData(sections: [
                          PieChartSectionData(
                              value: 20, showTitle: false, color: Colors.yellow),
                          PieChartSectionData(
                              value: 10, showTitle: false, color: Colors.red),
                          PieChartSectionData(
                              value: 10, showTitle: false, color: Colors.green),
                          PieChartSectionData(
                              value: 10, showTitle: false, color: Colors.blue),
                        ])),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child:
                      Container(
                        width: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(255, 177, 32, 1),
                        ),
                        child: IconButton(
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpense(isExpense: widget.isExpense,listAccount: widget.listAccount,)));
                          },
                          icon: const Icon(Icons.add)
                        ),
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
