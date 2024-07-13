import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<String> sendMessage(String userInput) async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.101:5000/chat'), // Replace with your machine's IP
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'user_input': userInput},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['response'];
    } else {
      throw Exception(
          'Failed to get response from server. Status code: ${response.statusCode}');
    }
  }
}
