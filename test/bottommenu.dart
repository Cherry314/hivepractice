import 'package:flutter/material.dart';

class Bottommenu extends StatefulWidget {
  const Bottommenu({super.key});

  @override
  State<Bottommenu> createState() => _BottommenuState();
}

class _BottommenuState extends State<Bottommenu> {
  int _selectedIndex = 0; // To track selected icon in BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //this is the last thing before the closing scaffold bracket

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in_map),
            label: 'Mark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_rounded),
            label: 'Itinerary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue[200],
        // Current selected index
        selectedItemColor: Colors.blue,
        // Color for selected item
        onTap: _onItemTapped, // Function to handle taps
      ),

    );
  }

  // Method to handle taps on BottomNavigationBar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {

    }
    if (index == 1) {

    }
    if (index == 2) {

    }
    if (index == 3) {

    }
  }


}