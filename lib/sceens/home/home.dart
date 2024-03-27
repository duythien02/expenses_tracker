// ignore: library_prefixes
import 'package:calendar_date_picker2/calendar_date_picker2.dart' as rangePicker;
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:expenses_tracker_app/widgets/home/expense_card_item.dart';
import 'package:expenses_tracker_app/widgets/home/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
    required this.listAccount,
    required this.currentAccount,
    required this.expenseData,
  });
  final List<Account> listAccount;
  Account currentAccount;
  Map<dynamic, List<Expense>> expenseData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpense = true;
  String typeTime = 'month';
  DateTime timeNow = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<DateTime?> dateRange = [];
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAPI.user.emailVerified;
    if (!isEmailVerified) {
      //FirebaseAPI.user.sendEmailVerification();
      SchedulerBinding.instance.addPostFrameCallback((_) => _showDialog());
    }
  }

  _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: SizedBox(
              child: Text(
                'Email của bạn chưa được xác nhận. Để xác nhận, vui lòng nhấp vào liên kết được gửi đến địa chỉ email bạn đã đăng ký',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }

  void changeTime() async {
    switch (typeTime) {
      case 'day':
        {
          final DateTime? dateTime = await showDatePicker(
            context: context,
            initialDate: timeNow,
            firstDate: DateTime(DateTime.now().year - 100),
            locale: const Locale('vi', 'VI'),
            lastDate: DateTime.now(),
          );
          if (dateTime != null) {
            setState(() {
              timeNow = dateTime;
            });
          }
        }
        break;
      case 'month':
        {
          final DateTime? dateTime = await showMonthPicker(
            roundedCornersRadius: 25,
            context: context,
            initialDate: timeNow,
            firstDate: DateTime(DateTime.now().year - 100),
            locale: const Locale('vi', 'VI'),
            lastDate: DateTime.now(),
            cancelWidget: const Text('Huỷ'),
            confirmWidget: const Text('OK'),
            selectedMonthBackgroundColor: kColorScheme.primary,
          );
          if (dateTime != null) {
            setState(() {
              timeNow = dateTime;
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
                    selectedDate: timeNow,
                    onChanged: (DateTime dateTime) {
                      setState(() {
                        timeNow = dateTime;
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
                      currentDate: timeNow,
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: timeNow,
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

  Map<String, List<Expense>> convertMap(String time) {
    Map<String, List<Expense>> newMap = {};
    if (isExpense) {
      widget.expenseData.forEach((key, value) {
        if (value.any((element) => element.type == Type.expense.name)) {
          newMap[key] = value;
        }
      });
    } else {
      widget.expenseData.forEach((key, value) {
        if (value.any((element) => element.type == Type.income.name)) {
          newMap[key] = value;
        }
      });
    }
    if (time != 'all') {
      Map<String, List<Expense>> filteredMap = {};
      switch (time) {
        case 'day':
          {
            List<Expense> filteredList = [];
            newMap.forEach((key, value) {
              for (var expense in value) {
                if (expense.date.day == timeNow.day &&
                    expense.date.month == timeNow.month &&
                    expense.date.year == timeNow.year) {
                  filteredList.add(expense);
                }
              }
              if (filteredList.isNotEmpty) {
                filteredMap[key] = filteredList;
                filteredList = [];
              }
            });
          }
          break;
        case 'month':
          {
            List<Expense> filteredList = [];
            newMap.forEach((key, value) {
              filteredList = value
                  .where((expense) =>
                      expense.date.month == timeNow.month &&
                      expense.date.year == timeNow.year)
                  .toList();
              if (filteredList.isNotEmpty) {
                filteredMap[key] = filteredList;
                filteredList = [];
              }
            });
          }
          break;
        case 'year':
          {
            List<Expense> filteredList = [];
            newMap.forEach((key, value) {
              filteredList = value
                  .where((expense) => expense.date.year == timeNow.year)
                  .toList();
              if (filteredList.isNotEmpty) {
                filteredMap[key] = filteredList;
                filteredList = [];
              }
            });
          }
          break;
        case 'range':
          {
            List<Expense> filteredList = [];
            newMap.forEach((key, value) {
              filteredList = value
                  .where((expense) => isInDateRange(expense.date, dateRange))
                  .toList();

              if (filteredList.isNotEmpty) {
                filteredMap[key] = filteredList;
                filteredList = [];
              }
            });
          }
          break;
      }
      return filteredMap;
    } else {
      return newMap;
    }
  }

  bool isInDateRange(DateTime expenseDate, List<DateTime?> dateRange) {
    if (dateRange.isEmpty) {
      return false;
    }

    DateTime startDate = dateRange[0]!;
    DateTime endDate = dateRange.length > 1 ? dateRange[1]! : startDate;

    return expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        expenseDate.isBefore(endDate.add(const Duration(days: 1)));
  }

  double getTotalAllExpense(Map<String, List<Expense>> expenseData) {
    double total = 0;
    for (var element in expenseData.values) {
      for (var expense in element) {
        total += expense.amount;
      }
    }
    return total;
  }

  String moneyFormat(int number) {
    var format = NumberFormat.simpleCurrency(
        locale: widget.currentAccount.currencyLocale);
    return format.format(number);
  }

  double getTotalExpenseCard(List<Expense> expenses) {
    return expenses.map((expense) => expense.amount).fold(0, (a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Column(children: [
          InkWell(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Huỷ'))
                        ],
                        title: const Text('Chọn tài khoản'),
                        contentPadding: const EdgeInsets.all(10),
                        content: IntrinsicHeight(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width / 2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                    widget.listAccount.length,
                                    (index) => RadioListTile(
                                          title: Text(
                                            widget
                                                .listAccount[index].accountName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400),
                                          ),
                                          subtitle: Text(moneyFormat(widget
                                              .listAccount[index]
                                              .accountBalance)),
                                          value: widget.listAccount[index],
                                          groupValue: widget.currentAccount,
                                          onChanged: (value) {
                                            widget.currentAccount = value!;
                                          },
                                        )),
                              ),
                            ),
                          ),
                        ),
                      ));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(IconData(int.parse(widget.currentAccount.symbol),
                    fontFamily: "AppIcons")),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.currentAccount.accountName,
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
          InkWell(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moneyFormat(widget.currentAccount.accountBalance),
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              )
            ],
          ))
        ]),
        centerTitle: true,
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (user.hasData) {
            return MainDrawer(
              user: user.data!,
            );
          }
          return Container();
        },
      ),
      body: Stack(
        children: [
          Container(
            height: 104,
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
                        if (isExpense != true) {
                          setState(() {
                            isExpense = true;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: isExpense
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 2, color: Colors.white))
                                : const Border(bottom: BorderSide.none)),
                        child: Text(
                          'CHI PHÍ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: isExpense
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        if (isExpense == true) {
                          setState(() {
                            isExpense = false;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: !isExpense
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 2, color: Colors.white))
                                : const Border(bottom: BorderSide.none)),
                        child: Text(
                          'THU NHẬP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                isExpense ? FontWeight.w400 : FontWeight.w600,
                          ),
                        ),
                      )),
                ],
              ),
              HomePieChart(
                isExpense: isExpense,
                listAccount: widget.listAccount,
                currentAccount: widget.currentAccount,
                listExpense: convertMap(typeTime).values.toList(),
                onPressedDate: () {
                  if (typeTime != 'day') {
                    setState(() {
                      typeTime = 'day';
                      timeNow = DateTime.now();
                    });
                  }
                },
                onPressedMonth: () {
                  if (typeTime != 'month') {
                    setState(() {
                      typeTime = 'month';
                      timeNow = DateTime.now();
                    });
                  }
                },
                onPressedYear: () {
                  if (typeTime != 'year') {
                    setState(() {
                      typeTime = 'year';
                      timeNow = DateTime.now();
                    });
                  }
                },
                onPressedRange: () {
                  dateRange = [timeNow];
                  if (typeTime != 'range') {
                    setState(() {
                      typeTime = 'range';
                    });
                  }
                  changeTime();
                },
                onPressedCustom: () {
                  changeTime();
                },
                onPressedAll: () {
                  setState(() {
                    typeTime = 'all';
                  });
                },
                dateRange: dateRange,
                time: timeNow,
                typeTime: typeTime,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: convertMap(typeTime).length,
                    itemBuilder: (context, index) {
                      var sortedKeys = convertMap(typeTime).keys.toList()
                        ..sort((a, b) {
                          double totalA =
                              getTotalExpenseCard(convertMap(typeTime)[b]!);
                          double totalB =
                              getTotalExpenseCard(convertMap(typeTime)[a]!);
                          return totalA.compareTo(totalB);
                        });
                      Map<String, List<Expense>> sortedMap = {};
                      for (var key in sortedKeys) {
                        sortedMap[key] = convertMap(typeTime)[key]!;
                      }
                      return ExpenseCard(
                        listExpense: sortedMap.values.elementAt(index),
                        account: widget.currentAccount,
                        total: getTotalAllExpense(sortedMap),
                      );
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
