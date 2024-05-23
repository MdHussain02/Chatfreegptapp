import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget message;
  final bool isUserMessage;

  const ChatBubble(
      {Key? key, required this.message, required this.isUserMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blueAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: message,
        ),
      ),
    );
  }
}
