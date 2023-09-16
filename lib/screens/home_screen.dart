import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quote_ofthe_day/screens/drawer.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? keyy});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String todaysQuote = '';
  late String imageAsset = 'images/bg0.jpg'; // default background

  List<String> favoriteQuotes = [];

  Future<Map<String, String>> fetchRandomQuote() async {
    try {
      final quotesJson = await rootBundle.loadString('assets/quotes.json');
      final List<dynamic> quotes = json.decode(quotesJson);

      if (quotes.isNotEmpty) {
        final randomIndex = Random().nextInt(quotes.length);
        final quoteData = quotes[randomIndex];
        final quote = quoteData['quote'];
        final author = quoteData['author'];

        return {
          'quote': quote,
          'author': author,
        };
      } else {
        throw Exception('No quotes found');
      }
    } catch (e) {
      // print('Error: $e');
      return {
        'quote': '',
        'author': '',
      };
    }
  }

  void addToFavorites(String quote) {
    setState(() {
      favoriteQuotes.add(quote);
    });
  }

  void removeFromFavorites(int index) {
    if (favoriteQuotes.isNotEmpty &&
        0 <= index &&
        index < favoriteQuotes.length) {
      favoriteQuotes.removeAt(index);
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  Future<void> refreshQuote() async {
    try {
      final Map<String, String?> quoteData = await fetchRandomQuote();
      final String? quote = quoteData['quote'];
      final String? author = quoteData['author'];

      if (quote != null) {
        final randomImageIndex = Random().nextInt(16);
        imageAsset = 'images/bg${randomImageIndex.toString()}.jpg';

        setState(() {
          todaysQuote = author != null ? '$quote \n- $author' : quote;
        });
      } else {
        // Handle the case where the quote is null
      }
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
          Image.asset(
            'assets/$imageAsset',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          SafeArea(
            //menu icon*********************
            child: Builder(builder: (context) {
              return Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Iconsax.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            }),
          ),
          Column(
            //***********************position of quotes**************************
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
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
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              // ********************buttons*******************
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
                        color: Colors.white,
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
                        color: Colors.white,
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
                        color: Colors.white,
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
