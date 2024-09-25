import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';
import 'package:hivepractice/markthisspotdialog.dart';
import 'package:hivepractice/functions/fetchaddress.dart';
import 'package:hivepractice/functions/fetchwhat3words.dart';
import 'package:hivepractice/functions/getlocation.dart';
import 'package:intl/intl.dart';

class MarkThisSpotDialog {
  static void show(BuildContext context) {
    String name = '';
    String notes = '';
    DateTime? selectedDateTime; // Variable to store selected date and time

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mark this spot'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
                  const SizedBox(height: 16), // Adds spacing between elements

                  // Add Date/Time Button
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                    child: Text(selectedDateTime == null
                        ? 'Add Date / Time'
                        : 'Selected: ${DateFormat('hh:mm a on dd/MM/yyyy').format(selectedDateTime!)}',
                    ),
                  ),
                ],
              );
            },
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
                getThisSpot(name, notes, selectedDateTime);
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

void getThisSpot(String name, String notes, DateTime? selectedDateTime) async {
  try {
    Position position = await getLocation();
    var longitude = position.longitude.toDouble();
    var latitude = position.latitude.toDouble();
    var altitude = position.altitude.toDouble();
    DateTime timestamp = DateTime.now();
    DateTime appointment = selectedDateTime ?? DateTime.now();

    // Fetch the address using the reverse geocoding service
    String? address = await ReverseGeocodingService.fetchAddress(latitude, longitude);
    String? words = await what3wordsService.fetchWhat3Words(latitude, longitude);
    address ??= 'Address could not be found.';
    words ??= 'No what3words available.';


    // If the address was successfully fetched
    address ??= 'Address could not be found.';
    print("Longitude: $longitude");
    print("Latitude: $latitude");
    print("Altitude: $altitude");
    print("Name: $name");
    print("Notes: $notes");
    print("Timestamp: $timestamp");
    print("Address: $address");
    print("Words: $words");
    print("Timestamp: $timestamp");
    print("Appointment: $appointment");




    // Open the Hive box
   // var box = await Hive.openBox<Location>('locationBox');
    // Generate a new ID based on the current length of the box
    var box = await Hive.openBox<Location>('locationBox');
   // This line checks every ID in the box and finds the highest ID.If the box is empty, it sets the new ID to 0. Otherwise, it finds the highest ID and adds 1 to it.
    int newId = box.isEmpty ? 0 : box.values.map((location) => location.id).reduce((a, b) => a > b ? a : b) + 1;


    // Create a new Location object
    Location newLocation = Location(
      id: newId,
      name: name,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      address: address,
      what3words: words,
      timeStamp: timestamp,
      appointment: appointment,
      notes: notes,
    );
    // Add the new location to the Hive box
    await box.add(newLocation);

    print("Location saved successfully!");

  } catch (e) {
    print("Error: $e");
  }
}




