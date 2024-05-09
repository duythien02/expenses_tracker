import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/widgets/account/transfer_data_table.dart';
import 'package:flutter/material.dart';

class TransferHistory extends StatelessWidget {
  const TransferHistory({super.key,required this.account, required this.listAccount});
  final Account account;
  final List<Account> listAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử chuyển khoản'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Column(
        children: [
          TransferDataTable(account: account,listAccount: listAccount,),
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(255, 177, 32, 1),
            ),
            child: IconButton(
                color: Colors.black,
                onPressed: () {},
                icon: const Icon(Icons.add)),
          ),
        ],
      )
    );
  }
}