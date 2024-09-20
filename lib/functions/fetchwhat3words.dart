import 'package:http/http.dart' as http;
import 'dart:convert';

class what3wordsService {
  static Future<String?> fetchWhat3Words(double latitude,
      double longitude) async {
    // Replace latitude and longitude in the API URL
    const String apiKey = 'Z6YJNCFM';
    final String apiUrl = 'https://api.what3words.com/v3/convert-to-3wa?coordinates=$latitude,$longitude&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String? words = data['words'];
        return words;  // Return the address as a String
      } else {
        return 'nul'; // Return null if the response failed
      }
    } catch (error) {
      print('Error fetching the words: $error');
    }}}