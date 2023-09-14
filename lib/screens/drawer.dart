import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

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
                'assets/images/marc.jpeg',
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/bg.jpeg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            title: const Text("Favourite"),
            leading: const Icon(
              Iconsax.heart,
              color: Colors.black,
            ),
            onTap: () {},
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
