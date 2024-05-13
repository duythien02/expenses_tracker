import 'dart:developer';

import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/create_account.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/create_transfer.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/transfer_history.dart';
import 'package:expenses_tracker_app/widgets/account/account_card.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen(
      {super.key, required this.expenseData, required this.account});
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  late Currency currency;
  var getListAccount = FirebaseAPI.getListAccount();
  List<Account> listAccount = [];

  @override
  void initState() {
    super.initState();
    getMainAccount();
  }

  Future<void> getMainAccount() async {
    await FirebaseAPI.getMainAccount().then((value) {
      setState(() {
        currency = currencies.firstWhere((element) => element.code == value.currencyCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tài khoản'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      drawer: FutureBuilder(
        future: FirebaseAPI.getInfoUser(),
        builder: (context, user) {
          if (user.hasData) {
            return MainDrawer(
              user: user.data!,
              expenseData: widget.expenseData,
              account: widget.account,
            );
          }
          return Container();
        },
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(bottom: 32, top: 24, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 24) / 2,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var transfer = await Navigator.push(context,MaterialPageRoute(builder: (context) => TransferHistoryScreen(account: widget.account, listAccount: listAccount,currency: currency,)));
                          if (transfer == true) {
                            setState(() {
                              getListAccount = FirebaseAPI.getListAccount();
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: kColorScheme.primary),
                          child: const Icon(
                            Icons.history,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Lịch sử chuyển khoản',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 24) / 2,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var transfer = await Navigator.push(context,MaterialPageRoute(builder: (context) => CreateTransferScreen(listAccount: listAccount,currency: currency,),),);
                          if(transfer != null){
                            setState(() {
                              getListAccount = FirebaseAPI.getListAccount();
                            });
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: kColorScheme.primary),
                          child: const Icon(
                            Icons.swap_horiz,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Giao dịch chuyển khoản mới',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            FutureBuilder(
              future: getListAccount,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  listAccount = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: listAccount.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () async {
                                var account = await Navigator.push(context,MaterialPageRoute(builder: (context) =>CreateAccountScreen(currency: currency,account: listAccount[index])));
                                log(account.toString());
                                if (account != null) {
                                  if(account == true){
                                    await FirebaseAPI.updateActiveAccount(listAccount.firstWhere((element) => element.isMain == account).accountId, true);
                                  }
                                  setState(() {
                                    getListAccount = FirebaseAPI.getListAccount();
                                  });
                                }
                              },
                              child: AccountCard(account: listAccount[index]),
                            )),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(
              height: 16,
            ),
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
                  var account = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountScreen(
                                currency: currency,
                                account: null,
                              )));
                  if (account != null) {
                    setState(() {
                      getListAccount = FirebaseAPI.getListAccount();
                    });
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
