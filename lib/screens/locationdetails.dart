import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hivepractice/hive/location.dart';
import 'package:hivepractice/screens/editlocationpage.dart';
import 'package:intl/intl.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({required this.iD, super.key});

  final int iD;

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  Location? location; // Don't need 'late' here since it's nullable.
  final box = Hive.box<Location>('locationBox');

  @override
  void initState() {
    super.initState();
    location = box.get(widget.iD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: location == null
          ? const Center(child: Text('Location not found'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Location Details',
              //   style: TextStyle(
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.teal,
              //   ),
              // ),
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
                          value: location?.name ?? 'N/A'),
                      DetailItem(
                          title: 'Latitude:',
                          value: '${location?.latitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Longitude:',
                          value: '${location?.longitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Altitude:',
                          value: '${location?.altitude ?? 'N/A'}'),
                      DetailItem(
                          title: 'Address:',
                          value: location?.address ?? 'N/A'),
                      DetailItem(
                          title: 'What3Words:',
                          value: location?.what3words ?? 'N/A'),
                      DetailItem(
                          title: 'Notes:', value: location?.notes ?? 'N/A'),
                      DetailItem(
                          title: 'Timestamp:',
                          value: location?.timeStamp != null
                              ? DateFormat('hh:mm a on dd/MM/yyyy')
                              .format(location!.timeStamp)
                              : 'N/A'),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditLocationPage(iD: widget.iD),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
