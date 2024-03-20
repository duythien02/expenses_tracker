import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/home/expense_detail_item.dart';
import 'package:flutter/material.dart';

class ExpenseDetailGroup extends StatelessWidget {
  const ExpenseDetailGroup({super.key, required this.expense, required this.account});
  final List<Expense> expense;
  final Account account;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Column(
              children: List.generate(expense.length, (index) {
                if(index != expense.length - 1 && expense.length >= 2){
                  return Column(
                    children: [
                      ExpenseDetailItem(expense: expense[index], account: account,),
                      Divider(height: 5, color: Colors.grey[300],)
                    ],
                  );
                }else{
                  return ExpenseDetailItem(expense: expense[index], account: account,);
                }
              }),
            ),
          )
        ],
      ),
    );
  }
}