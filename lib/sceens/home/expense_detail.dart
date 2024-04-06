import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ExpenseDetailScreen extends StatelessWidget {
  ExpenseDetailScreen({super.key, required this.expense, required this.account});
  Expense expense;
  Account account;

  String formatDate() {
    return '${expense.date.day} Tháng ${expense.date.month}, ${expense.date.year}';
  }

  String moneyFormat(){
    var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
    return format.format(expense.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32,left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Số tiền' ,style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Text(moneyFormat(),style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 20,),
            Text('Tài khoản', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(account.color)),
                  child: Icon(
                    IconData(int.parse(account.symbol),
                        fontFamily: "MyIcon"),
                    size: MediaQuery.of(context).size.width / 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12,),
                Text(account.accountName, style: const TextStyle(color: Colors.black)) 
              ],
            ),
            const SizedBox(height: 20,),
            Text('Danh mục', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(expense.color)),
                  child: Icon(
                    IconData(int.parse(expense.symbol),
                        fontFamily: "MyIcon"),
                    size: MediaQuery.of(context).size.width / 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12,),
                Text(expense.categoryName,style: const TextStyle(color: Colors.black)) 
              ],
            ),
            const SizedBox(height: 20,),
            Text('Ngày', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Text(formatDate(),style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}