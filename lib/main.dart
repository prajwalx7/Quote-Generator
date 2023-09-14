import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_ofthe_day/screens/home_screen.dart';

class Themes {
  static final ThemeData myTheme = ThemeData(
    primaryColor: const Color(0xFF99bfc7),
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: Colors.deepPurple ,
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.myTheme,
      home: const HomeScreen(),
    );
  }
}
