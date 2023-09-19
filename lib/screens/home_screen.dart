import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:like_button/like_button.dart';
import 'package:quote_ofthe_day/screens/drawer.dart';
import 'dart:ui' as ui;
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? keyy});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String todaysQuote = '';
  late String imageAsset = 'images/bg0.jpeg'; // default background
  bool isLiked = false;

  List<String> favoriteQuotes = []; //empty list b4 adding any quotes

  // Function to fetch a random quote from json
  Future<Map<String, String>> fetchRandomQuote() async {
    try {
      // Load the JSON file containing quotes from the app's assets.
      final quotesJson = await rootBundle.loadString('assets/quotes.json');

      // Parse the JSON data into a list of dynamic objects.
      final List<dynamic> quotes = json.decode(quotesJson);

      if (quotes.isNotEmpty) {
        // Generate a random index to select a random quote from the list.
        final randomIndex = Random().nextInt(quotes.length);

        // gets a random quote from quotes.json and store it in quoteData
        final quoteData = quotes[randomIndex];

        //gets quote and author from json
        final quote = quoteData['quote'];
        final author = quoteData['author'];

        // Return the quote and author as a Map
        return {
          'quote': quote,
          'author': author,
        };
      } else {
        // If the list of quotes ie. json is empty then throw an exception.
        throw Exception('No quotes found');
      }
    } catch (e) {
      //empty strings are return in case of errors in json
      return {
        'quote': '',
        'author': '',
      };
    }
  }

  // add quote to favorites
  void addToFavorites(String quote) {
    setState(() {
      favoriteQuotes.add(quote);
    });
  }

  // remove quote from favorites
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
    isLiked = favoriteQuotes.contains(todaysQuote);
    //if the current quote is in favorites then like button is red
    refreshQuote();
    //when this is called the state fo like button is changed
  }

  // Check if an asset exists if there ret true else false
  Future<bool> doesAssetExist(String assetName) async {
    try {
      await rootBundle.load(assetName);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Fetch a new random quote and update the background image.
  Future<void> refreshQuote() async {
    try {
      final Map<String, String?> quoteData = await fetchRandomQuote();
      final String? quote = quoteData['quote'];
      final String? author = quoteData['author'];

      if (quote != null) {
        final randomImageIndex = Random().nextInt(106);
        imageAsset = 'images/bg${randomImageIndex.toString()}.jpeg';

        setState(() {
          todaysQuote = author != null ? '$quote \n- $author' : quote;
        });
      } else {
        // Handle the case where the quote is null
      }
    } catch (e) {
      // Handle potential errors when fetching quote.
    }
  }

  // Share a quote using the Share package.
  void shareQuote(String quote) {
    Share.share(quote);
  }

  // Reset the like button state.
  void resetLikeButton() {
    setState(() {
      isLiked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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

          //background blur widget
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          SafeArea(
            // Menu button for opening the drawer.
            child: Builder(builder: (context) {
              return Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(
                      Iconsax.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            }),
          ),
          Column(
            // Position of quote
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
              // Buttons - like,refresh,share
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: LikeButton(
                      isLiked: isLiked,
                      onTap: (bool isCurrentlyLiked) {
                        setState(() {
                          if (isCurrentlyLiked) {
                            // Remove the quote from favorites.
                            removeFromFavorites(
                                favoriteQuotes.indexOf(todaysQuote));
                          } else {
                            // Add the quote to favorites.
                            addToFavorites(todaysQuote);
                          }
                          // Toggle the like state.
                          isLiked = !isCurrentlyLiked;
                        });

                        return Future.value(!isCurrentlyLiked);
                      },
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked
                              ? Colors.red // like button color when presed
                              : Colors.white, // default color of like button
                          size: 30,
                        );
                      },
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
                      onPressed: () {
                        resetLikeButton(); // Reset the like button state.
                        refreshQuote();
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
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        shareQuote(todaysQuote);
                      },
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
