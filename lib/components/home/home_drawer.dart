import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer_tile.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/home_page.dart';
import 'package:healthsphere/pages/settings_page.dart';
import 'package:healthsphere/pages/drugdatabase_page.dart';
import 'package:healthsphere/screens/map_screen.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/service_locator.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void userSignOut() async {
    final authService = getIt<AuthService>();
    await authService.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: SingleChildScrollView( // Wrap ListView with SingleChildScrollView
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Disable ListView's scrolling
          children: [
            // App logo
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset("lib/assets/images/logo_light.png", height: 120),
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
              onTap: () {
                Navigator.pop(
                  context
                );
              },
            ),


          // Setting list tile
          HomeDrawerTile(
            text: "S E T T I N G",
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

          HomeDrawerTile(
            text: "D A T A B A S E", 
            icon: Icons.data_array, 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DrugDatabasePage())
              );
            }
          ),

            // Adjust size if necessary
            const SizedBox(height: 400),

          // Logout list tile
          HomeDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () {
              userSignOut();
              Navigator.pop(context);
            }
          ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
