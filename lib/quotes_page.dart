import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuotesPage extends StatelessWidget {
  const QuotesPage({Key? key}) : super(key: key);

  Future<Map<String, String>> fetchQuotes() async {
    const String apiKey = 'arZdrqzOset8cL8nvWeriQ==TamyKn402MsA2nf4';
    final categories = ['happiness', 'amazing', 'family', 'money', 'love'];

    Map<String, String> quotes = {};

    for (var category in categories) {
      final apiUrl = 'https://api.api-ninjas.com/v1/quotes?category=$category';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Додаємо цитату для кожної категорії
        quotes[category] = data[0]['quote'].toString();
      } else {
        quotes[category] = 'Failed to load quote for $category';
      }
    }

    return quotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspiration Quotes'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: fetchQuotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final quotes = snapshot.data!;
            return ListView.builder(
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final category = quotes.keys.elementAt(index);
                final quote = quotes[category];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '[$category]: $quote',
                    style: const TextStyle(
                      color: Colors.white,  // Білий текст
                      fontSize: 20,         // Збільшений розмір шрифту
                      fontStyle: FontStyle.italic,  // Додаємо стиль
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No quotes available'));
          }
        },
      ),
      backgroundColor: Colors.black, // Чорний фон для контрасту
    );
  }
}
