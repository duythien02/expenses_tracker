import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/models/message.dart';
import 'package:expenses_tracker_app/widgets/chat/mesage_bubble.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  String formatTime(DateTime currentChatMessageTime){

    Duration duration = currentChatMessageTime.difference(DateTime.now());
    
    if(duration.inDays > 1){
      return '${currentChatMessageTime.day} - ${currentChatMessageTime.month} - ${currentChatMessageTime.year}';
    }else{
      return 'Hôm nay';
    }
  }

  Widget dividerTime(DateTime currentChatMessageTime){
    return Row(
    children: [
        const Expanded(
            child: Divider()
        ),
        const SizedBox(width: 10,),
        Text(formatTime(currentChatMessageTime),style: const TextStyle(color: Colors.black),),
        const SizedBox(width: 10,),
        const Expanded(
            child: Divider()
        ),
    ]
);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAPI.getTextInChat(),
      builder: (ctx, chatSnapshots) {
        if(chatSnapshots.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty){
          return const Center(
            child: Text(
              'Hãy chat để bắt đầu trò chuyện với Gemini.',
              style: TextStyle(color: Colors.black),
            ),
          );
        }
    
        final loadedMessages = chatSnapshots.data!.docs;

        List<ChatMessage> listChatMessages= [];

        listChatMessages = loadedMessages.map((e) => ChatMessage.fromMap(e.data())).toList();
    
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom:20,
            left: 0,
            right: 0,
          ),
          reverse: true,
          itemCount: listChatMessages.length,
          itemBuilder: (ctx,index){
            final chatMessage = listChatMessages[index];

            final nextChatMessage = index + 1 < listChatMessages.length
              ? listChatMessages[index + 1]
              : null;

            DateTime currentMessageTime = chatMessage.createAt;
            DateTime? nextMessageTime = nextChatMessage?.createAt;


            final currentMessageFrom = chatMessage.from;
            
            if(nextChatMessage != null){
              Duration difference = currentMessageTime.difference(nextMessageTime!);
              int day = difference.inDays;
              if(day > 1){
                return Column(
                  children: [
                    dividerTime(currentMessageTime),
                    MessageBubble(
                      message: chatMessage,
                      isMe: FirebaseAPI.user.uid == currentMessageFrom,
                    ),
                  ],
                );
              }
            }
            if(index - 1 < 0  && currentMessageFrom == FirebaseAPI.user.uid){
              return Column(
                children: [
                  MessageBubble(
                    message: chatMessage,
                    isMe: FirebaseAPI.user.uid == currentMessageFrom,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Gemini đang phản hồi...",
                        textStyle: const TextStyle(
                          color: Colors.black
                        ),
                        speed: const Duration(milliseconds: 100)
                      ),
                    ],
                    repeatForever: true,
                  ),
                ],
              );
            }
            return MessageBubble(
              message: chatMessage,
              isMe: FirebaseAPI.user.uid == currentMessageFrom,
            );
          }
        );
      },
    );
  }
}