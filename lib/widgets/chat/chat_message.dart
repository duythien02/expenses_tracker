import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:expenses_tracker_app/widgets/chat/mesage_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

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
    
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom:20,
            left: 0,
            right: 0,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx,index){
            final chatMessage = loadedMessages[index].data();
            // final nextChatMessage = index - 1 >= 0
            //     ? loadedMessages[index - 1].data()
            //     : null;
            final currentMessageUserId = chatMessage['from'];
            if(index - 1 < 0  && currentMessageUserId == FirebaseAPI.user.uid){
              return Column(
                children: [
                  MessageBubble(
                    message: chatMessage['text'],
                    isMe: FirebaseAPI.user.uid == currentMessageUserId,
                    nextMessageFromGemini: false,
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
              message: chatMessage['text'],
              isMe: FirebaseAPI.user.uid == currentMessageUserId,
              nextMessageFromGemini: false,
            );
          }
        );
      },
    );
  }
}