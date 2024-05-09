import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:expenses_tracker_app/widgets/account/transfer_data.dart';
import 'package:flutter/material.dart';

class TransferDataGroup extends StatelessWidget {
  const TransferDataGroup({super.key, required this.listTransfer, required this.listAccount});
  final List<Transfer> listTransfer;
  final List<Account> listAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: List.generate(
          listTransfer.length,
          (index) {
            if(index != listTransfer.length - 1 && listTransfer.length >= 2){
              return Column(
                children: [
                  TransferData(transfer: listTransfer[index], listAccount: listAccount,),
                  Divider(height: 5, color: Colors.grey[300],)
                ],
              );
            }else{
              return TransferData(transfer: listTransfer[index],listAccount: listAccount,);
            }
          }
        )
      ),
    );
  }
}