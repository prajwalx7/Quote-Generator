import 'dart:math';
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
  late String imageAsset = 'images/bg0.jpg'; //default background

  final APIService _apiService = APIService(
      'cdf158eb46msh94e5e46b346b00ap1b98f3jsnfac3a805ee03'); //diffusion API

  List<String> favoriteQuotes = [];

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
      final data = await _apiService.fetchQuote();
      final author = data['author'];

      // Fetch a Stoicism-related quote
      final stoicQuoteData = await _apiService.fetchQuote(topic: 'stoicism');
      final stoicQuote = stoicQuoteData['quote'];

      // I used this method to select a random background image from assets
      final randomImageIndex = Random().nextInt(16);
      imageAsset = 'images/bg$randomImageIndex.jpg';

      setState(() {
        todaysQuote = '$stoicQuote \n- $author';
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
          Image.asset(
            'assets/$imageAsset',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
