import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';
import 'package:intl/intl.dart';
import 'markthisspotdialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Box<Location> locationBox;
  int _selectedIndex = 0; // To track selected icon in BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Open the Hive box in the initState
    openLocationBox();
  }

  Future<void> openLocationBox() async {
    locationBox = await Hive.openBox<Location>('locationBox');
    setState(() {});
  }

  // Method to handle taps on BottomNavigationBar items
// Method to handle taps on BottomNavigationBar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Show MarkThisSpotDialog when "Mark" icon (index 1) is tapped
    if (index == 1) {
      MarkThisSpotDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlyDrive Buddy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'What would you like to do?',
              style: TextStyle(fontSize: 18),
            ),
          ),

          const SizedBox(height: 16),

          // Scrollable container with ListView of locations
          Expanded(
            child: locationBox.isEmpty
                ? const Center(child: Text('No locations saved yet.'))
                : ListView.builder(
              itemCount: locationBox.length,
              itemBuilder: (context, index) {
                final location = locationBox.getAt(index);

                // Ensure location is not null
                if (location == null) {
                  return const SizedBox.shrink();
                }

                // Format the appointment date to DD/MM/YYYY
                String formattedDate =
                DateFormat('dd/MM/yyyy').format(location.appointment);

                return ColoredBox(
                  color: Colors.green,
                  child: Material(
                    child: ListTile(
                      title: Text(location.name),
                      subtitle: Text('Appointment: $formattedDate'),
                      tileColor: Colors.red,
                      onTap: () {},
                    ),

                  )
                );

              },
            ),
          ),

        ],
      ),

      // Bottom Navigation Bar
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
        unselectedItemColor: Colors.blue[200], // Current selected index
        selectedItemColor: Colors.blue, // Color for selected item
        onTap: _onItemTapped, // Function to handle taps
      ),
    );
  }
  // Method to build each button with custom color and action
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.white.withOpacity(0.3), // Splash effect color
      child: Ink(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

}
