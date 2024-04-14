import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
        ],
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
                Flexible(child: Text(expense.categoryName,style: const TextStyle(color: Colors.black))) 
              ],
            ),
            const SizedBox(height: 20,),
            Text('Ngày', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Text(formatDate(),style: const TextStyle(color: Colors.black)),
            expense.note != null 
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Text('Ghi chú', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 6,),
                  Text(expense.note!,style: const TextStyle(color: Colors.black)),
                ],
              ) 
              : Container(),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  //Push đến trang add expense với đối tượng expense được truyền vào
                },
                child: Text('SAO CHÉP',style: TextStyle(color: kColorScheme.primary),),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.all(20),
                        actionsPadding: const EdgeInsets.only(right: 20),
                        content: const Text(
                          'Bạn có chắc chắn muốn xoá giao dịch không?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
                          TextButton(onPressed: () async {
                            Navigator.popUntil(context, (route) => route.isFirst);
                            await FirebaseAPI.deleteExpense(expense.expenseId, account.accountId, expense.type,expense.amount);
                          }, child: const Text('Xoá')),
                        ],
                      );
                    },
                  );
                },
                child: const Text('XOÁ',style: TextStyle(color: Colors.red),),
              )
          ],
        ),
      ),
    );
  }
}