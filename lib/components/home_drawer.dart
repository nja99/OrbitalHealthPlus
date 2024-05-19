import 'package:flutter/material.dart';
import 'package:healthsphere/components/home_drawer_tile.dart';
import 'package:healthsphere/pages/settings_page.dart';
import 'package:healthsphere/services/auth/auth_service.dart';
import 'package:healthsphere/services/service_locator.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  void userSignOut() async {
    final authService = getIt<AuthService>();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: ListView(
        children: [
          // App logo
          const Padding(
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
              }),

          const SizedBox(height: 500),

          // Logout list tile
          HomeDrawerTile(
              text: "L O G O U T",
              icon: Icons.logout,
              onTap: () {
                userSignOut();
                Navigator.pop(context);
              }),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
