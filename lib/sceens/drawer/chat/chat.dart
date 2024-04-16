import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/widgets/chat/chat_message.dart';
import 'package:expenses_tracker_app/widgets/chat/new_message.dart';
import 'package:expenses_tracker_app/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
            );
          }
          return Container();
        },
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessage()
          ),
          NewMessage(),
        ],
      )
    );
  }
}