import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapSingleLocation extends StatefulWidget {
  const MapSingleLocation({super.key, required this.latitude, required this.longitude, required this.name});
  final double latitude;
  final double longitude;
  final String name;

  @override
  State<MapSingleLocation> createState() => _MapSingleLocationState();
}

class _MapSingleLocationState extends State<MapSingleLocation> {
  final MapController _mapController = MapController();
  int _selectedIndex = 0;
  // Function to recenter the map to the given latitude and longitude

  void _recenterMap() {
    _mapController.move(LatLng(widget.latitude, widget.longitude), 13.0); // You can adjust the zoom level if needed
  }
  void _zoomMap() {
    _mapController.move(LatLng(widget.latitude, widget.longitude),18.0); // You can adjust the zoom level if needed
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locate on Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              ),
              initialCenter: LatLng(widget.latitude, widget.longitude),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.latitude, widget.longitude),
                    child: const Icon(Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.shade100,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.center_focus_strong_outlined),
            label: 'Re-center',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in),
            label: 'Zoom in',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Close',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue[200],
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }  // Method to handle taps on BottomNavigationBar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      _recenterMap();
    }
    if (index == 1) {
      _zoomMap();
    }
    if (index == 2) {
      Navigator.pop(context);
    }
  }

}