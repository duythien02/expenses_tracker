import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/models/user.dart';
import 'package:expenses_tracker_app/sceens/drawer/account/user_account.dart';
import 'package:expenses_tracker_app/sceens/drawer/chart/chart.dart';
import 'package:expenses_tracker_app/sceens/drawer/chat/chat.dart';
import 'package:expenses_tracker_app/sceens/drawer/profile/profile.dart';
import 'package:expenses_tracker_app/sceens/drawer/category/user_categories.dart';
import 'package:expenses_tracker_app/widgets/drawer/item_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, required this.user,required this.expenseData, required this.account});
  UserModel user;
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: user,expenseData: expenseData,account: account)),(route) => route.isFirst);
              },
              child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: kColorScheme.onPrimaryContainer
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: user.image == null 
                      ? const AssetImage("assets/images/user_avatar.png") as ImageProvider
                      : NetworkImage(user.image!),    
                  ),
                  accountName: Text('Tên người dùng: ${user.userName}'),
                  accountEmail: Text('Email: ${user.email}'),
                  
                  ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.popUntil(context, (route) => route.isFirst);
                
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Row(
                  children: [
                    Icon(Icons.home,color: Colors.white,),
                    SizedBox(width: 20,),
                    Text('Trang chủ')
                  ],
                ),
              ),
            ),
            ItemDrawer(
              destination: UserCategoryScreen(expenseData: expenseData,account: account),
              icon: Icons.category,
              title: 'Danh mục',
            ),
            ItemDrawer(
              destination: UserAccountScreen(expenseData: expenseData,account: account),
              icon: Icons.account_balance,
              title: 'Tài khoản',
            ),
            ItemDrawer(
              destination: ChartScreen(expenseData: expenseData,account: account),
              icon: Icons.bar_chart,
              title: 'Biểu đồ',
            ),
            ItemDrawer(
              destination: ChatScreen(expenseData: expenseData,account: account),
              icon: Icons.message,
              title: 'Chat',
            ),
          ],
        ),
      );
  }
}