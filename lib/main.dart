import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/hive/location.dart';
import 'home.dart'; // Import your mod



void main()  async{
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter()); // Register the adapter
  var box = await Hive.openBox<Location>('locationBox');  // Open a box
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlyDrive Buddy',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}


