import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/sceens/welcome/sync_data.dart';
import 'package:expenses_tracker_app/widgets/expense_card.dart';
import 'package:expenses_tracker_app/widgets/main_drawer.dart';
import 'package:expenses_tracker_app/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  List<Account> _list = [];
  bool isExpense = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAPI.getAccount(),
        builder: (context, account) {
          if (account.connectionState == ConnectionState.waiting) {
            return const SyncDataScreen();
          }
          if (account.hasData) {
            final data = account.data!.docs;
            _list = data.map((e) => Account.fromMap(e.data())).toList();
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: Column(children: [
                  InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(IconData(int.parse(_list[0].symbol),
                            fontFamily: "AppIcons")),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          _list[0].accountName,
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
                        "${_list[0].accountBalance} ${_list[0].currencySymbol}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 22),
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
                  if (user.connectionState == ConnectionState.done) {
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
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30))),
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
                                        : const Border(
                                            bottom: BorderSide.none)),
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
                                        : const Border(
                                            bottom: BorderSide.none)),
                                child: Text(
                                  'THU NHẬP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: isExpense
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      HomePieChart(
                        isExpense: isExpense,
                        account: _list[0],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, i) => const ExpenseCard(),
                          itemCount: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          return Container();
        });
  }
}
