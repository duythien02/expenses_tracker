import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:expenses_tracker_app/widgets/account/transfer_data_group.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TransferDataTable extends StatefulWidget {
  const TransferDataTable({super.key, required this.account, required this.listAccount});
  final Account account;
  final List<Account> listAccount;

  @override
  State<TransferDataTable> createState() => _TransferDataTableState();
}

class _TransferDataTableState extends State<TransferDataTable> {
  String typeTime = 'month';
  final DateTime selectedDate = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  final List<DateTime?> dateRange = [];
  Map<dynamic,List<Transfer>> transferData = {};

  String formatDateRange() {
    if (dateRange.isNotEmpty) {
      if (dateRange.elementAt(0)!.year != dateRange.last!.year) {
        return 'từ ${dateRange.elementAt(0)!.day} thg ${dateRange.elementAt(0)!.month}, ${dateRange.elementAt(0)!.year} đến ${dateRange.last!.day} thg ${dateRange.last!.month}, ${dateRange.last!.year}';
      } else {
        return 'từ ${dateRange.elementAt(0)!.day} thg ${dateRange.elementAt(0)!.month} đến ${dateRange.last!.day} thg ${dateRange.last!.month}, ${dateRange.last!.year}';
      }
    } else {
      return '';
    }
  }

  String formatDate(List<Transfer> list) {
    return '${list[0].createdAt.day} Tháng ${list[0].createdAt.month}, ${list[0].createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 30,
          height: MediaQuery.of(context).size.height * 4 / 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'all'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Mọi lúc',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'day'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Ngày',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'month'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Tháng',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'year'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Năm',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: typeTime == 'range'
                              ? Border(
                                  bottom: BorderSide(
                                      width: 2, color: kColorScheme.primary))
                              : const Border(bottom: BorderSide.none)),
                      child: Text(
                        'Khoảng thời gian',
                        style: TextStyle(
                            color: kColorScheme.primary,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                //onTap: typeTime != 'all' ? onPressedCustom : null,
                child: Container(
                  decoration: BoxDecoration(
                    border: typeTime != 'all'
                        ? const Border(
                            bottom: BorderSide(width: 1, color: Colors.black),
                          )
                        : const Border(bottom: BorderSide.none),
                  ),
                  child: Text(
                    typeTime == 'day'
                        ? 'Ngày ${selectedDate.day} tháng ${selectedDate.month}'
                        : typeTime == 'month'
                            ? 'Tháng ${selectedDate.month} năm ${selectedDate.year}'
                            : typeTime == 'year'
                                ? '${selectedDate.year}'
                                : typeTime == 'all'
                                    ? 'Mọi lúc'
                                    : formatDateRange(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: FirebaseAPI.getGroupedTransferStream(widget.account),
                builder: (context,transfer){
                  if(transfer.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(transfer.hasData){
                    transferData = transfer.data!;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: transferData.length,
                        itemBuilder: (context, index) => StickyHeader(
                            header: SizedBox(
                              child: Text(
                                formatDate(transferData.values.elementAt(index)),
                                style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400),
                              ),
                            ),
                            content: TransferDataGroup(listTransfer: transferData.values.elementAt(index),listAccount: widget.listAccount,),
                          ),
                        ),
                    );
                  }
                  return Container();
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}