import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quote_ofthe_day/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? keyy});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String todaysQuote =
      "My Unmatched Perspicacity Coupled with sheer Indefeagabiltiy make me a feared opponent in realme that has ever existed";
  String coverImage = "assets/images/god.jpeg";

  void refershQuote() {
    setState(() {
      todaysQuote = "This is a new quote!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Image.asset(
            coverImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 250, horizontal: 75),
              child: Text(
                todaysQuote,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: const Icon(Iconsax.heart),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: const Icon(Iconsax.refresh),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                    ),
                    child: const Icon(Iconsax.share),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Builder(
              builder: (BuildContext builderContext) {
                return IconButton(
                  icon: const Icon(
                    Iconsax.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Open the drawer
                    Scaffold.of(builderContext).openDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
