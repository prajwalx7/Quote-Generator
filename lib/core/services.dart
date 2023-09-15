import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  final String apiUrl;

  QuoteService(this.apiUrl);

  Future<Map<String, dynamic>> fetchStoicismQuote() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedResponse);
        final author = jsonData['author'];
        final quote = jsonData['quote'];

        return {
          'quote': quote,
          'author': author,
        };
      } else {
        throw Exception('Failed to load Stoic quote');
      }
    } catch (e) {
      // Handle error
      return {
        'quote': '',
        'author': '',
      };
    }
  }
}
