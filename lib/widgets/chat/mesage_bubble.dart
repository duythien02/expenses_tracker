import 'package:expenses_tracker_app/main.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.nextMessageFromGemini
  });

  final bool nextMessageFromGemini;
  final String message;
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
                  const SizedBox(height: 6),
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
                      message,
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