import 'package:flutter/material.dart';



class LocationCard1 extends StatefulWidget {
  const LocationCard1({super.key});

  @override
  State<LocationCard1> createState() => _LocationCard1State();
}

class _LocationCard1State extends State<LocationCard1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.black, // Replaced rteBorderColor with a default color
          width: 5, // border color
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}