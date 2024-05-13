// ignore: library_prefixes
import 'package:calendar_date_picker2/calendar_date_picker2.dart' as rangePicker;
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/transfer.dart';
import 'package:expenses_tracker_app/widgets/account/transfer_data_group.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class TransferDataTable extends StatefulWidget {
  const TransferDataTable({super.key, required this.account, required this.listAccount});
  final Account account;
  final List<Account> listAccount;

  @override
  State<TransferDataTable> createState() => _TransferDataTableState();
}

class _TransferDataTableState extends State<TransferDataTable> {
  String typeTime = 'month';
  DateTime time = DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  List<DateTime?> dateRange = [];
  Map<DateTime,List<Transfer>> transferData = {};

    void changeTime() async {
    switch (typeTime) {
      case 'day':
        {
          final DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: time,
            firstDate: DateTime(DateTime.now().year - 100),
            locale: const Locale('vi', 'VI'),
            lastDate: DateTime.now(),
          );
          if (dateTime != null) {
            setState(() {
              time = dateTime;
            });
          }
        }
        break;
      case 'month':
        {
          final DateTime? dateTime = await showMonthPicker(
            roundedCornersRadius: 25,
            context: context,
            initialDate: time,
            firstDate: DateTime(DateTime.now().year - 100),
            locale: const Locale('vi', 'VI'),
            lastDate: DateTime.now(),
            cancelWidget: const Text('Huỷ'),
            confirmWidget: const Text('OK'),
            selectedMonthBackgroundColor: kColorScheme.primary,
          );
          if (dateTime != null) {
            setState(() {
              time = dateTime;
            });
          }
        }
        break;
      case 'year':
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Chọn năm"),
                content: SizedBox(
                  width: 300,
                  height: 300,
                  child: YearPicker(
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime.now(),
                    selectedDate: time,
                    onChanged: (DateTime dateTime) {
                      setState(() {
                        time = dateTime;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          );
        }
        break;
      case 'range':
        {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                title: const Text("Chọn khoảng thời gian"),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: rangePicker.CalendarDatePicker2(
                    config: rangePicker.CalendarDatePicker2Config(
                      calendarType: rangePicker.CalendarDatePicker2Type.range,
                      currentDate: time,
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: time,
                    ),
                    value: dateRange,
                    onValueChanged: (dates) {
                      dateRange = dates;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Huỷ'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        dateRange;
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          if (dateRange.isEmpty || dateRange.length == 1) {
            setState(() {
              typeTime = 'month';
            });
          } else {
            setState(() {
              typeTime = 'range';
            });
          }
        }
    }
  }

  Map<DateTime, List<Transfer>> filteredExpense(String typeTime) {
    if (typeTime != 'all') {
      Map<DateTime, List<Transfer>> filteredMap = {};
      switch (typeTime) {
        case 'day':
          {
            transferData.forEach((transferTime, listTransfer) {
              if (transferTime.day == time.day &&
                  transferTime.month == time.month &&
                  transferTime.year == time.year) {
                    filteredMap[transferTime] = listTransfer;
              }
            });
          }
          break;
        case 'month':
          {
            transferData.forEach((transferTime, listTransfer) {
              if (transferTime.month == time.month &&
                  transferTime.year == time.year) {
                    filteredMap[transferTime] = listTransfer;
              }
            });
          }
          break;
        case 'year':
          {
            
            transferData.forEach((transferTime, listTransfer) {
              if (transferTime.year == time.year) {
                    filteredMap[transferTime] = listTransfer;
              }
            });
          }
          break;
        case 'range':
          {
            
            transferData.forEach((transferTime, listTransfer) {
              if(isInDateRange(transferTime, dateRange)){
                filteredMap[transferTime] = listTransfer;
              }
            });
          }
          break;
      }
      Map<DateTime, List<Transfer>> sortedGroupedExpenses = Map.fromEntries(filteredMap.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));
      return sortedGroupedExpenses;
    } else {
      Map<DateTime, List<Transfer>> sortedGroupedExpenses = Map.fromEntries(transferData.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));
      return sortedGroupedExpenses;
    }
  }

  bool isInDateRange(DateTime transferDate, List<DateTime?> dateRange) {
    if (dateRange.isEmpty) {
      return false;
    }

    DateTime startDate = dateRange[0]!;
    DateTime endDate = dateRange.length > 1 ? dateRange[1]! : startDate;

    return transferDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        transferDate.isBefore(endDate.add(const Duration(days: 1)));
  }

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
          height: MediaQuery.of(context).size.height * 3 / 4,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        typeTime = 'all';
                      });
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
                      if (typeTime != 'day') {
                        setState(() {
                          typeTime = 'day';
                          time = DateTime.now();
                        });
                      }
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
                      if (typeTime != 'month') {
                        setState(() {
                          typeTime = 'month';
                          time = DateTime.now();
                        });
                      }
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
                      if (typeTime != 'year') {
                        setState(() {
                          typeTime = 'year';
                          time = DateTime.now();
                        });
                      }
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
                      dateRange = [time];
                      if (typeTime != 'range') {
                        setState(() {
                          typeTime = 'range';
                        });
                      }
                      changeTime();
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
                onTap: typeTime != 'all' ? changeTime : null,
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
                        ? 'Ngày ${time.day} tháng ${time.month}'
                        : typeTime == 'month'
                            ? 'Tháng ${time.month} năm ${time.year}'
                            : typeTime == 'year'
                                ? '${time.year}'
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
                    return SizedBox(
                      height: (MediaQuery.of(context).size.height * 3 / 4) / 2,
                      child: const Center(child: CircularProgressIndicator(),)
                    );
                  }
                  if(transfer.hasData){
                    transferData = transfer.data!;
                    if(filteredExpense(typeTime).isEmpty){
                      return SizedBox(
                        height: (MediaQuery.of(context).size.height * 3 / 4) / 2,
                        child: const Center(
                          child: Text('Không có giao dịch trong thời gian này',style: TextStyle(color: Colors.black),)
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: filteredExpense(typeTime).length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            formatDate(filteredExpense(typeTime).values.elementAt(index)),
                            style: TextStyle(color: Colors.grey[600],fontWeight: FontWeight.w400),
                          ),
                          subtitle: TransferDataGroup(listTransfer: filteredExpense(typeTime).values.elementAt(index),listAccount: widget.listAccount,activeAccount: widget.account,),
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