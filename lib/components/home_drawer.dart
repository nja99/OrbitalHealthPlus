import 'package:flutter/material.dart';
import 'package:healthsphere/components/home_drawer_tile.dart';
import 'package:healthsphere/pages/login_page.dart';



class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: ListView(
        children: [

          // App logo
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.lock_open_outlined,
              size: 80,
            ),
          ),

          // Divider line
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),

          // Home list tile
          HomeDrawerTile(
            text: "H O M E",
            icon: Icons.home,
              onTap: () => Navigator.pop(context),
          ),

          // Setting list tile
          HomeDrawerTile(
            text: "S E T T I N G S",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),                
              );
            }
          ),

          const SizedBox(height:500),

          // Logout list tile
          HomeDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            }
          ),

          const SizedBox(height:25),
        ],
      ),
    );
  }
}
