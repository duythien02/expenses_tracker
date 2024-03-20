import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/home/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
      {super.key,
      required this.account,
      required this.listExpense,
      required this.total});
  final List<Expense> listExpense;
  final Account account;
  final double total;

  int getTotalExpense() {
    int total = 0;
    for (var expense in listExpense) {
      total += expense.amount;
    }
    return total;
  }

  double calPercent() {
    return getTotalExpense() / total * 100;
  }

  String moneyFormat(){
    var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
    return format.format(getTotalExpense());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExpenseScreen(
                    listExpense: listExpense, account: account))),
        child: Card(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 10,
                      width: MediaQuery.of(context).size.width / 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(listExpense[0].color)),
                      child: Icon(
                        IconData(int.parse(listExpense[0].symbol),
                            fontFamily: "AppIcons"),
                        size: MediaQuery.of(context).size.width / 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      listExpense[0].categoryName,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('${calPercent().toStringAsFixed(0)}%',style: const TextStyle(color: Colors.black),),
                    const SizedBox(width: 18,),
                    Text(moneyFormat(),
                        style: const TextStyle(color: Colors.black))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
