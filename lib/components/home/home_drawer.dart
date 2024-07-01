import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer_tile.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/settings_page.dart';
import 'package:healthsphere/pages/drugdatabase_page.dart';
import 'package:healthsphere/services/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  void userSignOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if(!mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(80),
        bottomRight: Radius.circular(80)
      ),
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.55,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column( 
          children: [
            // App logo
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Image.asset("lib/assets/images/logo_light.png", height: 120),
            ),
      
            // Divider line
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Divider(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
      
            // Home list tile
            HomeDrawerTile(
              text: "HOME",
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
      
          // Setting list tile
          HomeDrawerTile(
            text: "SETTINGS",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) => const SettingsPage()));
            }
          ),
      
          HomeDrawerTile(
            text: "DATABASE", 
            icon: Icons.data_array, 
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context) => const DrugDatabasePage()));
            }
          ),
      
          const Spacer(),
      
          // Logout list tile
          HomeDrawerTile(
            text: "LOGOUT",
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
