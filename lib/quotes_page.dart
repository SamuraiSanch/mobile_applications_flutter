import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flashlight_plugin/flashlight_plugin.dart';

class QuotesPage extends StatelessWidget {
  const QuotesPage({super.key});

  // Функція для включення або вимикання ліхтарика з повідомленням
  void toggleFlashlight(BuildContext context, bool enable) {
    FlashlightPlugin.toggleFlashlight(enable: enable).then((_) {
      final statusMessage = enable ? "The flashlight is on!" : "The flashlight is off!";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            statusMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Flashlight not supported on this platform."),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  // Функція для завантаження цитат
  Future<Map<String, String>> fetchQuotes() async {
    const String apiKey = 'arZdrqzOset8cL8nvWeriQ==TamyKn402MsA2nf4';
    final categories = ['happiness', 'amazing', 'family', 'money', 'love'];
    final Map<String, String> quotes = {};

    for (var category in categories) {
      final apiUrl = 'https://api.api-ninjas.com/v1/quotes?category=$category';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, String>>(
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
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '[$category]: $quote',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => toggleFlashlight(context, true),
                child: const Text('Sunny'),
              ),
              ElevatedButton(
                onPressed: () => toggleFlashlight(context, false),
                child: const Text('Rainy'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
