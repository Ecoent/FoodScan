import 'package:flutter/material.dart';
import 'package:food_scan/screens/Home.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  title: "Food Scan",
  home: new HomePage(),
  theme: ThemeData(
    primaryColor: Colors.white,
  ),
));