import 'package:flutter/material.dart';
import 'package:signed/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Signed",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.black54
      ),
      home: HomeScreen(),
    );
  }
}