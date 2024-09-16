import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert';



Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}





class MarkThisSpotDialog {
  static void show(BuildContext context) {
    String name = '';
    String notes = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark this spot'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ensures the dialog doesn't stretch unnecessarily
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(), // Adds a box around the text field
                ),
                onChanged: (value) {
                  name = value;
                },
              ),
              const SizedBox(height: 16), // Adds spacing between text fields
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(), // Adds a box around the text field
                ),
                onChanged: (value) {
                  notes = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                getThisSpot(name, notes);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void getThisSpot(String name, String notes) async {
  try {
    Position position = await getLocation();
    var longitude = position.longitude.toDouble();
    var latitude = position.latitude.toDouble();
    var altitude = position.altitude.toDouble();
    var timestamp = DateTime.now().toIso8601String();



    // Fetch the address using the reverse geocoding service
    String? address = await ReverseGeocodingService.fetchAddress(latitude, longitude);

    // If the address was successfully fetched
    address ??= 'Address could not be found.';
    print("Longitude: $longitude");
    print("Latitude: $latitude");
    print("Altitude: $altitude");
    print("Name: $name");
    print("Notes: $notes");
    print("Timestamp: $timestamp");
    print("Address: $address");

// insert into Hive here



  } catch (e) {
    print("Error: $e");
  }
}

class ReverseGeocodingService {
  static Future<String?> fetchAddress(double latitude, double longitude) async {
    // Replace latitude and longitude in the API URL
    final String apiUrl = 'https://geocode.maps.co/reverse?lat=$latitude&lon=$longitude&api_key=66e83cf47d11b039582715lqb6edf33';

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