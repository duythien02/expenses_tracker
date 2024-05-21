import 'package:expenses_tracker_app/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _textController = TextEditingController();

  late List<Content> listContent;

  @override
  void initState() {
    super.initState();
    listContent = [];
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _talkWithGemini() async {
    final enteredMessage = _textController.text;

    Content content = Content.text(enteredMessage);

    listContent.add(content);

    if(enteredMessage.trim().isEmpty){
      return;
    }

    FocusScope.of(context).unfocus();
    _textController.clear();
    await FirebaseAPI.sendTextInChat(enteredMessage, FirebaseAPI.user.uid);

    final model = GenerativeModel(model: "gemini-pro", apiKey: dotenv.env["GEMINI_API_KEY"]!);
    
    final chat = model.startChat(
      history: listContent
    );

    final respone = await chat.sendMessage(content);
    await FirebaseAPI.sendTextInChat(respone.text ?? "", "gemini-pro");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              autofocus: true,
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                hintText: 'Nhập câu lệnh tại đây ....',
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.send),
            onPressed: _talkWithGemini,
          )
        ],
      ),
    );
  }
}