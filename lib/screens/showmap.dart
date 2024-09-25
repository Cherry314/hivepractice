import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hivepractice/screens/addlocationlatlon.dart';
import 'package:latlong2/latlong.dart';
import 'package:hivepractice/screens/editlocationpage.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(0, 0); // Default to (0,0), it will be updated
  LatLng _currentPosition = const LatLng(0, 0);
  double _altitude = 0.0; // Default altitude

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Check permission for location access
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      _currentPosition = _center;
      _altitude = position.altitude; // Update altitude from position data
      _mapController.move(_center, 15.0); // Move the map to the current location
    });
  }

  // Update latitude, longitude, and altitude based on the center of the map
  void _onMapMove() {
    LatLng center = _mapController.camera.center;
    setState(() {
      _currentPosition = center;
      // Altitude could be fetched using reverse geolocation services, but keeping it static for now
    });
  }

  // Handle Cancel button press
  void _onCancel() {
    Navigator.pop(context); // Simply go back or handle any other logic
  }

  // Handle Save button press
  void _onSave() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddLocationLatLon(
          latitude: _currentPosition.latitude,
          longitude: _currentPosition.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with Center Marker'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Flutter map widget
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 15.0,
              onPositionChanged: (mapPosition, _) => _onMapMove(),
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
            ],
          ),

          // Crosshair marker in the center of the screen
          const Center(
            child: Icon(
              Icons.add, // A "+" cross-like symbol
              size: 36,
              color: Colors.red,
            ),
          ),

          // Latitude, Longitude in a row and Altitude in a box below them
          Positioned(
            bottom: 90, // Position higher to make room for buttons
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Row for Latitude and Longitude
                Row(
                  children: [
                    // Latitude
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: TextEditingController(
                          text: _currentPosition.latitude.toStringAsFixed(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between boxes

                    // Longitude
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        controller: TextEditingController(
                          text: _currentPosition.longitude.toStringAsFixed(6),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 10),

                // Altitude box
                // TextField(
                //   readOnly: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Altitude (m)',
                //     border: OutlineInputBorder(),
                //     filled: true,
                //     fillColor: Colors.white,
                //   ),
                //   controller: TextEditingController(
                //     text: _altitude.toStringAsFixed(2),
                //   ),
                // ),
              ],
            ),
          ),

          // Cancel and Save buttons in a row
          Positioned(
            bottom: 10, // Position the row at the bottom
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
