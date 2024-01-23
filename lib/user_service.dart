import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_ofthe_day/constants.dart';

class UserService {
  static String apiKey = QUOTE_API_KEY;

  static const String apiUrl =
      'https://api.api-ninjas.com/v1/quotes?category=happiness';

  Future<Map<String, String>> getSingleQuote() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'X-Api-Key': apiKey},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('API Response: $data'); // Print API response for analysis

        if (data.isNotEmpty &&
            data.first['quote'] != null &&
            data.first['author'] != null) {
          // Extract the quote and author from the first map in the list
          final quoteContent = data.first['quote'] as String;
          final authorName = data.first['author'] as String;

          return {
            'quote': quoteContent,
            'author': authorName,
          };
        } else {
          throw Exception('Quote or author not found in response');
        }
      } else {
        throw Exception('HTTP Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getSingleQuote: $e'); // Print error for debugging
      throw e; // Rethrow the caught exception for further analysis
    }
  }
}
