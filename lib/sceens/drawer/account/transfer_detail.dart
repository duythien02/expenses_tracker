import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferDetailScreen extends StatelessWidget {
  const TransferDetailScreen({super.key, required this.transfer, required this.listAccount});
  final Transfer transfer;
  final List<Account> listAccount;

  String formatDate() {
    return '${transfer.createdAt.day} Tháng ${transfer.createdAt.month}, ${transfer.createdAt.year}';
  }

  String moneyFormat(){
    var format = NumberFormat.simpleCurrency(locale: transfer.currencyLocal);
    return format.format(transfer.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết chuyển khoản'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32,left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transfer.type == TransferType.init.name 
              ? 'Số dư ban đầu'
              : transfer.type == TransferType.change.name
                ? 'Điều chỉnh số dư'
                : 'Chuyển từ tài khoản',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 6,),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(transfer.fromAccountColor)),
                  child: Icon(
                    IconData(int.parse(transfer.fromAccountSymbol),
                        fontFamily: "MyIcon"),
                    size: MediaQuery.of(context).size.width / 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12,),
                Text(
                  listAccount.indexWhere((element) => element.accountId == transfer.fromAccountId) == -1
                    ? '${transfer.fromAccountName} (đã xoá)'
                    : transfer.fromAccountName,
                  style: const TextStyle(color: Colors.black)) 
              ],
            ),
            if(transfer.toAccountId != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Text(
                  'Chuyển vào tài khoản',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 6,),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width / 10,
                      width: MediaQuery.of(context).size.width / 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Color(transfer.toAccountColor!)),
                      child: Icon(
                        IconData(int.parse(transfer.toAccountSymbol!),
                            fontFamily: "MyIcon"),
                        size: MediaQuery.of(context).size.width / 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12,),
                    Text(
                      listAccount.indexWhere((element) => element.accountId == transfer.toAccountId) == -1
                        ? '${transfer.toAccountName!} (đã xoá)'
                        : transfer.toAccountName!,
                      style: const TextStyle(color: Colors.black)) 
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Text(
              transfer.type == TransferType.transfer.name
                ? 'Số tiền chuyển khoản'
                : 'Số tiền',
              style: TextStyle(color: Colors.grey[600], fontSize: 14)
            ),
            const SizedBox(height: 6,),
            Text(moneyFormat(),style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 20,),
            Text('Ngày', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(height: 6,),
            Text(formatDate(),style: const TextStyle(color: Colors.black)),
            if(transfer.note != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20,),
                  Text('Ghi chú', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const SizedBox(height: 6,),
                  Text(transfer.note!,style: const TextStyle(color: Colors.black)),
                ],
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
                          'Bạn có chắc chắn muốn xoá giao dịch chuyển khoản này không?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context,false), child: const Text('Huỷ')),
                          TextButton(onPressed: () async {
                            Navigator.pop(context);
                            await FirebaseAPI.deleteTransfer(listAccount.firstWhere((element) => element.isActive == true).accountId, transfer.transferID);
                          }, child: const Text('Xoá')),
                        ],
                      );
                    },
                  ).then((value) {
                    if(value){
                      Navigator.pop(context,true);
                    }
                  });
                },
                child: const Text('XOÁ',style: TextStyle(color: Colors.red),),
              )
          ],
        ),
      ),
    );
  }
}