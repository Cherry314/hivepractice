import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';

class EditLocationPage extends StatefulWidget {
  const EditLocationPage({required this.iD, super.key});

  final int iD;

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  final box = Hive.box<Location>('locationBox');
  late Location? location;

  // Text controllers to capture input from the user
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController altitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController what3wordsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    location = box.get(widget.iD);

    if (location != null) {
      // Populate the text fields with the current location data
      nameController.text = location!.name;
      latitudeController.text = location!.latitude.toString();
      longitudeController.text = location!.longitude.toString();
      altitudeController.text = location!.altitude.toString();
      addressController.text = location!.address;
      what3wordsController.text = location!.what3words;
      notesController.text = location!.notes;
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    altitudeController.dispose();
    addressController.dispose();
    what3wordsController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void saveLocation() {
    if (location != null) {
      // Update the location fields with the new values from the input
      location!.name = nameController.text;
      location!.latitude = double.tryParse(latitudeController.text) ?? 0.0;
      location!.longitude = double.tryParse(longitudeController.text) ?? 0.0;
      location!.altitude = double.tryParse(altitudeController.text) ?? 0.0;
      location!.address = addressController.text;
      location!.what3words = what3wordsController.text;
      location!.notes = notesController.text;

      // Save the updated location back to the Hive box
      box.put(widget.iD, location!);

      // Show confirmation and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated successfully')),
      );
      Navigator.pop(context);
    } else {
      // If location is null, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Location not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Location'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: location == null
          ? const Center(child: Text('Location not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Name of Location
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name of Location',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Latitude
                  TextField(
                    controller: latitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Longitude
                  TextField(
                    controller: longitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Altitude
                  TextField(
                    controller: altitudeController,
                    decoration: const InputDecoration(
                      labelText: 'Altitude',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),

                  // Address (multiline)
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Allows the text to wrap
                  ),
                  const SizedBox(height: 10),

                  // What3Words
                  TextField(
                    controller: what3wordsController,
                    decoration: const InputDecoration(
                      labelText: 'What3Words',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Notes
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // Allows for multiline input
                  ),
                  const SizedBox(height: 20),

                  // Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text('Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: saveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text('Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}