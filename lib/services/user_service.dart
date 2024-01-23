import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_ofthe_day/services/constants.dart';

class UserService {

  static String apiKey = quoteApiKey;
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
        // print('API Response: $data'); 

        if (data.isNotEmpty &&
            data.first['quote'] != null &&
            data.first['author'] != null) {
        
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
      // print('Error in getSingleQuote: $e'); 
      rethrow; // Rethrow the caught exception 
    }
  }
}
