import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
      {super.key, required this.account, required this.listExpense});
  final List<Expense> listExpense;
  final Account account;

  int getTotalExpense(){
    int total = 0;
    for(var expense in listExpense){
      total += expense.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 62,
          child: Row(
            children: [
              Container(
              height: MediaQuery.of(context).size.width / 10,
              width: MediaQuery.of(context).size.width / 10,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(listExpense[0].color) ),
              child: Icon( IconData(int.parse(listExpense[0].symbol),fontFamily: "AppIcons"),
                size: MediaQuery.of(context).size.width / 16,
                color: Colors.white,
              )),
              Text(listExpense[0].categoryName,style: const TextStyle(color: Colors.black),),
              Text('${getTotalExpense()} ${account.currencySymbol}',style: const TextStyle(color: Colors.black))
            ],
          ),
        ),
      ),
    );
  }
}
