import 'package:flutter/material.dart';
import 'package:mapbox_project/src/views/full_screen_map_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maps',
      home: Scaffold(
        body: FullScreenMapView(),
      ),
    );
  }
}