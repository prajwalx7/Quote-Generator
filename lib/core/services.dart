import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;


class APIService {
  final String apiKey;

  APIService(this.apiKey);

  Future<Map<String, dynamic>> fetchQuote({String topic = 'stoicism'}) async {
    try {
      final response = await http.get(
        Uri.parse('https://quotes-diffusion.p.rapidapi.com/'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'quotes-diffusion.p.rapidapi.com'
        },
        // Include the 'topic' parameter in the query string
        // This assumes that the API uses 'topic' as the parameter name for filtering
        // If the API uses a different parameter name, replace 'topic' with the correct name
        // and 'stoicism' with the desired topic value
        // 'topic': topic,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final quotes = jsonData['data'];

        if (quotes.isNotEmpty) {
          final randomIndex = Random().nextInt(quotes.length);
          final quoteData = quotes[randomIndex];
          final quote = quoteData['title'];
          final author = quoteData['author'];

          // Return the quote and author as a map
          return {
            'quote': quote,
            'author': author,
          };
        } else {
          throw Exception('No quotes found in the response');
        }
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      print('Error: $e');
      return {
        'quote': '',
        'author': '',
      };
    }
  }
}
