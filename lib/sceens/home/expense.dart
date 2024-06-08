import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/home/expense/expense_detail_group.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen(
      {super.key, required this.listExpense, required this.account});
  final List<Expense> listExpense;
  final Account account;

  double getTotalExpense() {
    double total = 0;
    for (var expense in listExpense) {
      total += expense.amount;
    }
    return total;
  }

  Map<DateTime, List<Expense>> groupBydate() {
    Map<DateTime, List<Expense>> groupedExpenses = {};
    for (var expense in listExpense) {
      DateTime date =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      groupedExpenses.putIfAbsent(date, () => []).add(expense);
    }
    Map<DateTime, List<Expense>> sortedGroupedExpenses = Map.fromEntries(
        groupedExpenses.entries.toList()
          ..sort((e1, e2) => e2.key.compareTo(e1.key)));
    return sortedGroupedExpenses;
  }

  String formatDate(List<Expense> list) {
    return '${list[0].date.day} Tháng ${list[0].date.month}, ${list[0].date.year}';
  }

  String moneyFormat() {
    var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
    return format.format(getTotalExpense());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              listExpense[0].categoryName.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              moneyFormat(),
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 16),
        child: ListView.builder(
            itemCount: groupBydate().length,
            itemBuilder: (context, index) => StickyHeader(
                header: Container(
                  width: double.infinity,
                  color: kColorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      formatDate(groupBydate().values.elementAt(index)),
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                content: ExpenseDetailGroup(
                  account: account,
                  expense: groupBydate().values.elementAt(index),
                ))),
      ),
    );
  }
}
