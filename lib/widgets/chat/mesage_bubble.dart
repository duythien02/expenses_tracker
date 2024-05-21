import 'package:expenses_tracker_app/main.dart';
import 'package:expenses_tracker_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  final ChatMessage message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                        right: 13,
                      ),
                      child: Text(
                        isMe ? DateFormat.jm().format(message.createAt) : 'Gemini, ${DateFormat.jm().format(message.createAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? kColorScheme.primary
                          : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe
                            ? Radius.zero
                            : const Radius.circular(12),
                        topRight: isMe
                            ? Radius.zero
                            : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 12,
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        height: 1.3,
                        color: isMe
                            ? Colors.white
                            : Colors.black87,
                      ),
                      softWrap: true,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}