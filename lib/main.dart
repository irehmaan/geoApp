// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:geoapp/service/location_service.dart';
import 'package:provider/provider.dart';


import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => LocationProvider(),
        child: MapScreen(),
      ),
    );
  }
}
