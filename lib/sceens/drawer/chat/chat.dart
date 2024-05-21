import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/account.dart';
import 'package:expenses_tracker_app/models/expese.dart';
import 'package:expenses_tracker_app/widgets/chat/chat_message.dart';
import 'package:expenses_tracker_app/widgets/chat/new_message.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key,  required this.expenseData, required this.account});
  final Map<dynamic, List<Expense>> expenseData;
  final Account account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
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
              expenseData: expenseData,
              account: account,
            );
          }
          return Container();
        },
      ),
      body: const Column(
        children: [
          Expanded(
            child: Chat()
          ),
          NewMessage(),
        ],
      )
    );
  }
}