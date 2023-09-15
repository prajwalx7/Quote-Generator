import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quote_ofthe_day/core/services.dart';
import 'package:quote_ofthe_day/screens/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? keyy});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String todaysQuote = '';
  List<String> favoriteQuotes = [];

  void addToFavorites(String quote) {
    // Check if the quote already exists in the favorites list
    if (!favoriteQuotes.contains(quote)) {
      favoriteQuotes.add(quote);
    }

    // Update the state of the widget
    setState(() {});
  }

  void removeFromFavorites(int index) {
    if (favoriteQuotes.isNotEmpty &&
        0 <= index &&
        index < favoriteQuotes.length) {
      favoriteQuotes.removeAt(index);
    }

    setState(() {});
  }

  void removeQuote(String quote) {
    favoriteQuotes.remove(quote);

    setState(() {});
  }

  final QuoteService _quoteService = QuoteService(
      'Ai5dgMKmudETKI/GVZwddg==YtA1J8YwURgr8QuD'); // Replace with your actual API key

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  Future<void> refreshQuote() async {
    try {
      final data = await _quoteService.fetchQuoteAndImage();
      setState(() {
        todaysQuote = data['quote'];
      });
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      drawer: MyDrawer(
        favoriteQuotes: favoriteQuotes, // Pass the favorite quotes list here
        addToFavoritesCallback: (quote) {
          addToFavorites(quote);
        },
        removeFromFavorites: (index) {
          removeFromFavorites(
              index); // Call the removeFromFavorites method in HomeScreen
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Builder(builder: (context) {
              return Align(
                alignment: Alignment.topLeft, // Adjust alignment as needed
                child: IconButton(
                  icon: const Icon(
                    Iconsax.menu,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                //position of quotes
                padding: const EdgeInsets.only(
                  top: 250,
                  left: 16,
                  right: 16,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    todaysQuote,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0, // Adjust the bottom margin as needed
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.heart,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        final String currentQuote =
                            todaysQuote; // Get the current quote
                        if (currentQuote.isNotEmpty) {
                          addToFavorites(currentQuote); // Add to favorites
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0, // Adjust the bottom margin as needed
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.refresh,
                        color: Colors.black,
                      ),
                      onPressed: refreshQuote,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0, // Adjust the bottom margin as needed
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.share,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
