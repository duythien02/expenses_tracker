import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/create_transfer.dart';
import 'package:expenses_tracker_app/widgets/account/transfer_data_table.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransferHistoryScreen extends StatelessWidget {
  TransferHistoryScreen({super.key,required this.account, required this.listAccount, required this.currency});
  final Account account;
  final List<Account> listAccount;
  final Currency currency;
  bool hasTransfer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử chuyển khoản'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        leading: IconButton(
          onPressed: () => Navigator.pop(context, hasTransfer),
          icon: const Icon(
            Icons.arrow_back
          )
        )
      ),
      body: Column(
        children: [
          TransferDataTable(account: account,listAccount: listAccount,),
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 177, 32, 1),
            ),
            child: IconButton(
              color: Colors.black,
              onPressed: () async {
                bool? hasTransfer = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTransferScreen(listAccount: listAccount, currency: currency)));
                if(hasTransfer != null){
                  this.hasTransfer = hasTransfer;
                }
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      )
    );
  }
}