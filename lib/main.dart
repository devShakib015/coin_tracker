import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 5,
          color: Color(0xFFB52175),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.white,
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.pink[900],
        ),
      ),
      home: Home(),
    );
  }
}
