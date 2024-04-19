import 'package:expenses_tracker_app/data/curencies_data.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/currency.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/create_account.dart';
import 'package:expenses_tracker_app/widgets/account/currency_card.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  late Currency currency;
  var getListAccount = FirebaseAPI.getListAccount();

  @override
  void initState() {
    super.initState();
    getMainAccount();
  }

  Future<void>getMainAccount() async{
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
            );
          }
          return Container();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 24,left: 12, right: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 24) / 2,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kColorScheme.primary
                        ),
                        child: const Icon(Icons.history,color: Colors.white,size: 35,),
                      ),
                      const SizedBox(height: 8,),
                      const Text('Lịch sử chuyển khoản', style: TextStyle(color: Colors.black,fontSize: 14),)
                    ],
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 24) / 2,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kColorScheme.primary
                        ),
                        child: const Icon(Icons.swap_horiz,color: Colors.white,size: 35,),
                      ),
                      const SizedBox(height: 8,),
                      const Text('Giao dịch chuyển khoản mới', style: TextStyle(color: Colors.black,fontSize: 14),)
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24,),
            FutureBuilder(
              future: getListAccount,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator(),),
                  );
                }
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () async {
                          var account = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountScreen(currency: currency, account: snapshot.data![index])));
                          if(account != null){
                            setState(() {
                              getMainAccount();
                              getListAccount = FirebaseAPI.getListAccount();
                            });
                          }
                        },
                        child: CurrencyCard(account: snapshot.data![index]),
                      )
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 16,),
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
                  var account = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountScreen(currency: currency,account: null,)));
                  if(account != null){
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