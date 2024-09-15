import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  ChatUser currentUser = ChatUser(id: '0', firstName: 'user');
  ChatUser edith = ChatUser(
    id: '1',
    firstName: 'edith',
    profileImage: 'https://unsplash.com/photos/black-and-green-full-face-helmet-on-white-wooden-table-IGa3Md8wP6g',
  );
  List<ChatMessage> messages = [];
  final Gemini gemini = Gemini.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Chat With Edith'),
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == edith) {
        } else {
          String response = event.content?.parts
                  ?.fold('', (previous, current) => "$previous$current") ??
              '';
          ChatMessage message = ChatMessage(
              user: edith, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
