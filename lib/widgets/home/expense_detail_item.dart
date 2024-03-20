import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/home/expense_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseDetailItem extends StatelessWidget {
  const ExpenseDetailItem(
      {super.key, required this.expense, required this.account});
  final Expense expense;
  final Account account;

  String moneyFormat() {
    var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
    return format.format(expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseDetailScreen(expense: expense, account: account))),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 10,
                      width: MediaQuery.of(context).size.width / 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(expense.color)),
                      child: Icon(
                        IconData(int.parse(expense.symbol),
                            fontFamily: "AppIcons"),
                        size: MediaQuery.of(context).size.width / 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.categoryName,
                          style: const TextStyle(color: Colors.black),
                        ),
                        expense.note != null
                            ? Text(
                                expense.note!,
                                style: const TextStyle(color: Colors.black),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
                Text(
                  moneyFormat(),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
