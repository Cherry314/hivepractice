import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/functions/fetchaddress.dart';
import 'package:hivepractice/functions/fetchwhat3words.dart';
import 'package:hivepractice/hive/location.dart';

class AddLocationLatLon extends StatefulWidget {
  const AddLocationLatLon({required this.latitude, required this.longitude, super.key});

  final double latitude;
  final double longitude;


  @override
  State<AddLocationLatLon> createState() => _AddLocationLatLonState();
}

class _AddLocationLatLonState extends State<AddLocationLatLon> {
  final box = Hive.box<Location>('locationBox');
  Location? location; // Now nullable

  // Text controllers to capture input from the user
  final TextEditingController nameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController altitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController what3wordsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();


  final FocusNode nameFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
      latitudeController.text = widget.latitude.toString();
      longitudeController.text = widget.longitude.toString();
      getData(widget.latitude, widget.longitude); // Fetch the additional data (address, what3words)

      WidgetsBinding.instance.addPostFrameCallback((_) {
        nameFocusNode.requestFocus();
      });
  }

  void getData(double latitude, double longitude) async {
    String? address = await ReverseGeocodingService.fetchAddress(latitude, longitude);
    String? words = await what3wordsService.fetchWhat3Words(latitude, longitude);
    address ??= 'Address could not be found.';
    words ??= 'No what3words available.';
    setState(() {
      addressController.text = address!;
      what3wordsController.text = words!;
    });
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

  void saveLocation() async {
    // Open the Hive box
    var box = await Hive.openBox<Location>('locationBox');
    // This line checks every ID in the box and finds the highest ID. If the box is empty, it sets the new ID to 0. Otherwise, it finds the highest ID and adds 1 to it.
    int newId = box.isEmpty ? 0 : box.values.map((location) => location.id).reduce((a, b) => a > b ? a : b) + 1;

    final newLocation = Location(
      id: newId,
      name: nameController.text,
      latitude: double.parse(latitudeController.text), // Convert string to double
      longitude: double.parse(longitudeController.text), // Convert string to double
      altitude: 0.00, // Convert string to double
      address: addressController.text,
      what3words: what3wordsController.text,
      timeStamp: DateTime.now(),
      appointment: DateTime.now(),
      notes: notesController.text,
    );
    await box.add(newLocation);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location saved successfully')),
      );


    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Location'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
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
                    focusNode: nameFocusNode,
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
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: saveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                        ),
                        child: const Text(
                          'Save Changes',
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


