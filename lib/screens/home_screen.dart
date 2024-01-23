import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:quote_ofthe_day/services/constants.dart';
import 'package:quote_ofthe_day/screens/drawer.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quote_ofthe_day/services/user_controls.dart';
import 'package:quote_ofthe_day/services/user_service.dart';
import 'package:share/share.dart';
import "package:http/http.dart" as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, Key? keyy});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String todaysQuote = '';
  bool isLiked = false;
  List<String> favoriteQuotes = [];
  String currentImage = "";
  int imageCounter = 1;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    refreshQuote();
  }

  Future<void> refreshQuote() async {
    try {
      final r = await http.get(Uri.parse(
          "$unsplashEndpoint&page=$imageCounter&per_page=1&query=philosopher"));
      final data = jsonDecode(r.body);
      // print("image Data : ${data}");

      currentImage = data['results'][0]['urls']['small'];

      final Map<String, String> quoteData = await _userService.getSingleQuote();

      if (quoteData.isNotEmpty) {
        final String quote = quoteData['quote']!;
        final String author = quoteData['author']!;
        todaysQuote = '$quote\n- $author';
        isLiked = false;
      } else {
        throw Exception('Quote data is empty');
      }

      imageCounter++;
      setState(() {});
    } catch (e) {
      // print('Error fetching quote: $e');
      setState(
        () {
          todaysQuote = 'Failed to fetch quote';
        },
      );
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

  void shareQuote(String quote) {
    Share.share(quote);
  }

  void resetLikeButton() {
    setState(() {
      isLiked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
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
          if (currentImage != "")
            SizedBox(
              height: double.infinity,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaY: 1, sigmaX: 1),
                child: Image.network(
                  currentImage,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          if (currentImage != "")
            Container(
              height: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          SafeArea(
            child: Builder(
              builder: (context) {
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
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 250, left: 16, right: 16),
                child: SingleChildScrollView(
                  child: Text(
                    todaysQuote,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              UserControls(
                isLiked: isLiked,
                onTapLike: (isCurrentlyLiked) {
                  setState(
                    () {
                      if (isCurrentlyLiked) {
                        removeFromFavorites(
                          favoriteQuotes.indexOf(todaysQuote),
                        );
                      } else {
                        addToFavorites(todaysQuote);
                      }
                      isLiked = !isCurrentlyLiked;
                    },
                  );
                },
                onRefresh: refreshQuote,
                onShare: () {
                  shareQuote(todaysQuote);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
