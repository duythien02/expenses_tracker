import 'package:expenses_tracker_app/models/account.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

// ignore: must_be_immutable
class AddExpense extends StatefulWidget {
  AddExpense({super.key, required this.isExpense, required this.account});
  bool isExpense;
  Account account;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm giao dịch',style: TextStyle(color: Colors.white),),
      ),
      body: Stack(
        children: [ 
          Container(
            height: 45,
            decoration: ShapeDecoration(
              color: kColorScheme.primary,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        if(widget.isExpense != true){
                          setState(() {
                          widget.isExpense = true;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: widget.isExpense 
                            ? const Border(bottom: BorderSide(width: 2,color: Colors.white))
                            : const Border(bottom: BorderSide.none)
                        ),
                        child: Text(
                          'CHI PHÍ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: widget.isExpense ? FontWeight.w600 : FontWeight.w400),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        if(widget.isExpense == true){
                          setState(() {
                          widget.isExpense = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: !widget.isExpense 
                            ? const Border(bottom: BorderSide(width: 2,color: Colors.white))
                            : const Border(bottom: BorderSide.none)
                        ),
                        child: Text(
                          'THU NHẬP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: widget.isExpense ? FontWeight.w400 : FontWeight.w600, ),
                        ),
                      )),
                ],
              ),
            ]
          )
        ]
      )
    );
  }
}