import 'package:flutter/material.dart';
import 'markthisspotdialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          // Spacer to push buttons to the bottom
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,  // Two buttons per row
              crossAxisSpacing: 16,  // Space between columns
              mainAxisSpacing: 16,   // Space between rows
              children: [
                // Show a dialog when Button 1 is pressed
                _buildButton('Button 1', Colors.blue, () => MarkThisSpotDialog.show(context)),
                _buildButton('Button 2', Colors.green, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button 2 pressed!')),
                  );
                }),
                _buildButton('Button 3', Colors.orange, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button 3 pressed!')),
                  );
                }),
                _buildButton('Button 4', Colors.red, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button 4 pressed!')),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build each button with custom color and action
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.white.withOpacity(0.3),  // Splash effect color
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

  // Method to display a dialog box when Button 1 is pressed
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Button 1 Pressed"),
          content: const Text("You have pressed Button 1!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
