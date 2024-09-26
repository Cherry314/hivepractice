import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';
import 'package:hivepractice/screens/locationdetails.dart';
import 'package:hivepractice/screens/mapsinglelocation.dart';
import 'package:hivepractice/screens/navmap.dart';
import 'package:hivepractice/screens/showmap.dart';
import 'package:intl/intl.dart';
import 'markthisspotdialog.dart';
import '';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<Location>? locationStore; // Make it nullable
  bool isLoading = true; // Add loading state
  int _selectedIndex = 0; // To track selected icon in BottomNavigationBar

  @override
  void initState() {
    super.initState();
    // Open the Hive box in the initState
    openLocationBox();
  }

  Future<void> openLocationBox() async {
    locationStore = await Hive.openBox<Location>('locationBox');
    setState(() {
      isLoading = false; // Box has been opened, set loading to false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlyDrive Buddy'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
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
            child: locationStore!.isEmpty
                ? const Center(child: Text('No locations saved yet.'))
                : ListView.builder(
              itemCount: locationStore!.length,
              itemBuilder: (context, index) {
                final locationSingle = locationStore!.getAt(index);

                if (locationSingle == null) {
                  return const SizedBox.shrink();
                }

                // Format the appointment date to DD/MM/YYYY
                String formattedDate =
                DateFormat('dd/MM/yyyy').format(locationSingle.appointment);

                return Padding(
                  padding: const EdgeInsets.all(8.0), // Add padding for spacing between items
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey, // Set tile color here
                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    ),
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MapSingleLocation(
                                latitude: locationSingle.latitude,
                                longitude:locationSingle.longitude,
                                name: locationSingle.name)));
                        },
                        child: const Icon(Icons.location_on),
                      ),
                      title: Text(locationSingle.name),
                      subtitle: Text('Appointment: $formattedDate'),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationDetails(
                              iD: index,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
  // Method to handle taps on BottomNavigationBar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Show MarkThisSpotDialog when "Mark" icon (index 1) is tapped
    if (index == 1) {
      MarkThisSpotDialog.show(context);
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapPage()),
      );
    }
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NavMap()),
      );
    }
  }
}

