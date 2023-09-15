import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String apiKey;
  final String apiUrl;

  QuoteService(this.apiKey)
      : apiUrl = 'https://api.api-ninjas.com/v1/quotes?category=inspirational';

  Future<Map<String, dynamic>> fetchQuoteAndImage() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Api-Key': apiKey, // Use the apiKey variable here
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final quote = jsonData[0]['quote'];
        final author = jsonData[0]['author'];

        return {
          'quote': quote,
          'author': author,
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle error
      // print('Error fetching data: $e');
      return {
        'quote': '',
        'author': '',
      };
    }
  }
}
