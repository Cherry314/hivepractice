import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';
import 'package:hivepractice/screens/editlocationpage.dart';
import 'package:hivepractice/screens/mapsinglelocation.dart';
import 'package:intl/intl.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({required this.iD, super.key});

  final int iD;

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  Location? locationSingle; // Don't need 'late' here since it's nullable.
  final locationStore = Hive.box<Location>('locationBox');
  int _selectedIndex = 0; // To track selected icon in BottomNavigationBar


  @override
  void initState() {
    super.initState();
    locationSingle = locationStore.get(widget.iD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: locationSingle == null
          ? const Center(child: Text('Location not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey[200],
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailItem(
                          title: 'Name of Location:',
                          value: locationSingle?.name ?? 'N/A'),
                      DetailItem(
                          title: 'Latitude:',
                          value: '${locationSingle?.latitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Longitude:',
                          value: '${locationSingle?.longitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Altitude:',
                          value: '${locationSingle?.altitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Address:',
                          value: locationSingle?.address ?? 'N/A'),
                      DetailItem(
                          title: 'What3Words:',
                          value: locationSingle?.what3words ?? 'N/A'),
                      DetailItem(
                          title: 'Notes:', value: locationSingle?.notes ?? 'N/A'),
                      DetailItem(
                          title: 'Timestamp:',
                          value: locationSingle?.timeStamp != null
                              ? DateFormat('hh:mm a on dd/MM/yyyy')
                              .format(locationSingle!.timeStamp)
                              : 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Close',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue[200], // Current selected index
        selectedItemColor: Colors.blue, // Color for selected item
        onTap: _onItemTapped, // Function to handle taps
      ),


    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Show MarkThisSpotDialog when "Mark" icon (index 1) is tapped
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditLocationPage(iD: widget.iD),
        ),
      );
    }
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapSingleLocation(
              latitude: locationSingle!.latitude,
              longitude:locationSingle!.longitude,
              name: locationSingle!.name)));
    }
    if (index == 2) {
     Navigator.pop(context);
    }
  }

}




class DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const DetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
