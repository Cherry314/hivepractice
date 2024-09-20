import 'package:http/http.dart' as http;
import 'dart:convert';


class ReverseGeocodingService {
  static Future<String?> fetchAddress(double latitude, double longitude) async {
    // Replace latitude and longitude in the API URL
    const String apiKey = '66e83cf47d11b039582715lqb6edf33';
    final String apiUrl = 'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=$apiKey';
    try {
      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        // Extract information from the JSON
        String? address = data['display_name'];
        return address;  // Return the address as a String
      } else {
        return null; // Return null if the response failed
      }
    } catch (error) {
      print('Error fetching the address: $error');
      return null; // Return null if there's an error
    }
  }
}