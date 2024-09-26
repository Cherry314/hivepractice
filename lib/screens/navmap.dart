import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


class NavMap extends StatefulWidget {
  const NavMap({super.key});

  @override
  State<NavMap> createState() => _NavMapState();
}

class _NavMapState extends State<NavMap> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(0, 0); // Default to (0,0), it will be updated
  LatLng _currentPosition = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Page'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
             onPositionChanged: (mapPosition, _) => _onMapMove(),
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),


              initialCenter: const LatLng(51.509865, -0.118092),
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),

            ],
          ),



        ],
      ),
    );
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

      _mapController.move(_center, 15.0); // Move the map to the current location
    });
  }

  void _onMapMove() {
    LatLng center = _mapController.camera.center;
    setState(() {
      _currentPosition = center;
      // Altitude could be fetched using reverse geolocation services, but keeping it static for now
    });
  }
  }

