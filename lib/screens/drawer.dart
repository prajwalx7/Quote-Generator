import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quote_ofthe_day/screens/favourite.dart';

class MyDrawer extends StatelessWidget {
  final List<String> favoriteQuotes;
  final Function(String) addToFavoritesCallback;
  final Function(int) removeFromFavorites;

  const MyDrawer({
    Key? key,
    required this.favoriteQuotes,
    required this.addToFavoritesCallback,
    required this.removeFromFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text(
              'Prajwal Dudhatkar',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            accountEmail: Text(
              'workwithprajwal@yahoo.com',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/user.jpeg',
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/drawerbg.jpeg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: const Text("Favorite"),
            leading: const Icon(
              Iconsax.heart,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoritePage(
                    favoriteQuotes: favoriteQuotes,
                    onAdd: (quote) {
                      addToFavoritesCallback(quote);
                    },
                    onRemove: (index) {
                      removeFromFavorites(index);
                    },
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Invite Friends"),
            leading: const Icon(
              Iconsax.people,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(
              Iconsax.setting,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text("About"),
            leading: const Icon(
              Iconsax.info_circle,
              color: Colors.black,
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
