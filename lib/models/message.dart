class ChatMessage {
  late String messageId;
  late String text;
  late String from;
  late DateTime createAt;

  ChatMessage({
    required this.messageId,
    required this.text,
    required this.from,
    required this.createAt,
  });

  Map<String, dynamic> toMap() {
    return ({
      'messageId': messageId,
      'text': text,
      'from': from,
      'createAt': createAt.microsecondsSinceEpoch
    });
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] as String,
      text: map['text'] as String,
      from: map['from'] as String,
      createAt: DateTime.fromMicrosecondsSinceEpoch(map['createAt'] as int),
    );
  }
}
