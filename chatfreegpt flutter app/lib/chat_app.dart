import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        primaryColor: Color(0xFF1F1F1F),
        accentColor: Colors.blueAccent,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white70),
        ),
      ),
      home: ChatScreen(),
    );
  }
}
