import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chat_bubble.dart';
import 'loading_indicator.dart';
import 'api_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> messages = [
    {"role": "bot", "message": "Hi, how can I help you?"}
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty && !_isLoading) {
      setState(() {
        messages.add({"role": "user", "message": _controller.text});
        messages.add({"role": "bot", "message": null});
        _isLoading = true;
      });

      print("Sending message: ${_controller.text}");

      try {
        final response = await ApiService.sendMessage(_controller.text);

        setState(() {
          messages.removeLast();
          messages.add({"role": "bot", "message": response});
          _isLoading = false;
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } catch (e) {
        print('Error: $e');
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ChatFree GPT',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center align the title
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index]['message'];
                if (message == null) {
                  return ChatBubble(
                    message: LoadingIndicator(
                        animationController: _animationController),
                    isUserMessage: false,
                  );
                } else {
                  return ChatBubble(
                    message: Text(message),
                    isUserMessage: messages[index]['role'] == 'user',
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isLoading, // Disable input when loading
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF1F1F1F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _isLoading
                      ? null
                      : _sendMessage, // Disable button when loading
                  child: Icon(Icons.send, color: Colors.white),
                  backgroundColor:
                      _isLoading ? Colors.grey : Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
