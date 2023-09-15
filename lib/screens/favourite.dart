import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FavoritePage extends StatefulWidget {
  final List<String> favoriteQuotes;
  final ValueChanged<String> onAdd;
  final ValueChanged<int> onRemove;

  const FavoritePage({
    Key? key,
    required this.favoriteQuotes,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  final TextEditingController _quoteController = TextEditingController();

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }

  void addToFavorites(String quote) {
    setState(() {
      widget.favoriteQuotes.add(quote);
    });

    widget.onAdd(quote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.purple[100],
        title: const Text(
          'Favorite Quotes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: widget.favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = widget.favoriteQuotes[index];
                return ListTile(
                  title: Text(quote),
                  trailing: IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () {
                      // Remove the quote from the favorites list
                      widget.favoriteQuotes.removeAt(index);

                      // Update the state of the widget
                      setState(() {});
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // Add a 10 pixel space between each quote
                return const Divider(height: 25);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _quoteController,
                    decoration: InputDecoration(
                      labelText: 'Add your own Quote',
                      focusColor: Colors.purple[100],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.add),
                  onPressed: () {
                    if (_quoteController.text.isNotEmpty) {
                      addToFavorites(_quoteController.text);
                      _quoteController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
