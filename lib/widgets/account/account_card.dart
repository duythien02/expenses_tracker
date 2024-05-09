import 'package:expenses_tracker_app/models/account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.account});
  final Account account;

  String moneyFormat(){
    if (account.accountBalance >= 1000000) {
      var format = NumberFormat.compactSimpleCurrency(locale: account.currencyLocale);
      return format.format(account.accountBalance);
    } else {
      var format = NumberFormat.simpleCurrency(locale: account.currencyLocale);
      return format.format(account.accountBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      color: Color(account.color)),
                  child: Icon(
                    IconData(int.parse(account.symbol),
                        fontFamily: "MyIcon"),
                    size: MediaQuery.of(context).size.width / 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    account.accountName,
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
        
            Text(moneyFormat(),
                    style: const TextStyle(color: Colors.black))
          ],
        ),
      ),
    );
  }
}