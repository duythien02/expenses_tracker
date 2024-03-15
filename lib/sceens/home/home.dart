import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/category.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:expenses_tracker_app/widgets/home/expense_card_item.dart';
import 'package:expenses_tracker_app/widgets/home/pie_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  HomeScreen(
      {super.key,
      required this.listAccount,
      required this.currentAccount,
      required this.expenseData});
  final List<Account> listAccount;
  Account currentAccount;
  Map<dynamic, List<Expense>>? expenseData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpense = true;
  Map<String, List<Expense>> mapExpense = {};

  Map<String, List<Expense>> convertMap(Map<dynamic, List<Expense>> map) {
    Map<String, List<Expense>> newMap = {};
    if (isExpense) {
      map.forEach((key, value) {
        if (value.any((element) => element.type == Type.expense.name)) {
          newMap[key] = value;
        }
      });
    } else {
      map.forEach((key, value) {
        if (value.any((element) => element.type == Type.income.name)) {
          newMap[key] = value;
        }
      });
    }
    return newMap;
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
                                          title: Text(widget
                                              .listAccount[index].accountName),
                                          subtitle: Text(
                                              '${widget.listAccount[index].accountBalance} ${widget.listAccount[index].currencySymbol}'),
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
                "${widget.currentAccount.accountBalance} ${widget.currentAccount.currencySymbol}",
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
                listExpense: convertMap(widget.expenseData!).values.toList()
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: convertMap(widget.expenseData!).length,
                  itemBuilder: (context, index) => ExpenseCard(
                    listExpense: convertMap(widget.expenseData!).values.elementAt(index),
                    account: widget.currentAccount,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
