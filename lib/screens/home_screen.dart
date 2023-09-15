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
  final QuoteService _stoicismQuoteService =
      QuoteService('https://api.themotivate365.com/stoic-quote');

  void addToFavorites(String quote) {
    if (!favoriteQuotes.contains(quote)) {
      favoriteQuotes.add(quote);
    }

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

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  Future<void> refreshQuote() async {
    try {
      final data = await _stoicismQuoteService.fetchStoicismQuote();
      final quote = data['quote'];
      final author = data['author'];
      setState(() {
        todaysQuote = '$quote\n-$author';
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      drawer: MyDrawer(
        favoriteQuotes: favoriteQuotes,
        addToFavoritesCallback: (quote) {
          addToFavorites(quote);
        },
        removeFromFavorites: (index) {
          removeFromFavorites(index);
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Builder(builder: (context) {
              return Align(
                alignment: Alignment.topLeft,
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
                  top: 300,
                  left: 16,
                  right: 16,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
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
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.heart,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        final String currentQuote = todaysQuote;
                        if (currentQuote.isNotEmpty) {
                          addToFavorites(currentQuote);
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
                      bottom: 20.0,
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
                      bottom: 20.0,
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
