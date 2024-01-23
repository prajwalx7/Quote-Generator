import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_ofthe_day/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const HomeScreen(), 
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
