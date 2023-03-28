import 'package:flutter/material.dart';
import 'package:untitled/screens/device_list_screen.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceListingScreen(),
    );
  }
}










