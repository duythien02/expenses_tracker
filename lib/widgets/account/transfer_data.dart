import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/transfer_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferData extends StatelessWidget {
  const TransferData({super.key, required this.transfer,required this.listAccount, required this.activeAccount});
  final Transfer transfer;
  final List<Account> listAccount;
  final Account activeAccount;

  String moneyFormat(double number) {
    var format = NumberFormat.simpleCurrency(
        locale: transfer.currencyLocal);
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransferDetailScreen(transfer: transfer, listAccount: listAccount))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 20,
                  width: MediaQuery.of(context).size.width / 20,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(BorderSide(width: 1))),
                  child: Icon(
                    transfer.type == TransferType.init.name 
                      ? Icons.attach_money 
                      : transfer.type == TransferType.change.name
                        ? Icons.edit
                        : EvaIcons.arrowDownwardOutline,
                    size: MediaQuery.of(context).size.width / 24,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listAccount.indexWhere((element) => element.accountId == transfer.fromAccountId) == -1 
                        ? '${transfer.fromAccountName} (đã xoá)' 
                        : transfer.fromAccountName,style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      transfer.type == TransferType.init.name 
                        ? 'Số dư ban đầu'
                        : transfer.type == TransferType.change.name
                          ? 'Điều chỉnh số dư'
                          : listAccount.indexWhere((element) => element.accountId == transfer.toAccountId) == -1
                            ? '${transfer.toAccountName!} (đã xoá)'
                            : transfer.toAccountName!, 
                      style: transfer.toAccountId == null 
                        ? TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400) 
                        : const TextStyle(color: Colors.black),
                    ),
                    if(transfer.note != null)
                      Text(
                        transfer.note!,
                        style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400),
                      )
                  ],
                ),
              ],
            ),
          ),
          transfer.type == TransferType.transfer.name
            ? Text(
              transfer.fromAccountId == activeAccount.accountId
                ? '-${moneyFormat(transfer.amount)}'
                : '+${moneyFormat(transfer.amount)}',
              style: const TextStyle(color: Colors.black),
            )
            : Text(
              transfer.amount >= 0 
                ? '+${moneyFormat(transfer.amount)}'
                : moneyFormat(transfer.amount),
              style: const TextStyle(color: Colors.black),
            ),
        ],
      ),
    );
  }
}