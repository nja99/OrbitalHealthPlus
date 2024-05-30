import "package:flutter/material.dart";
import "package:healthsphere/components/home/home_app_bar.dart";
import "package:healthsphere/components/home/home_appointment.dart";
import "package:healthsphere/components/home/home_drawer.dart";
import "package:healthsphere/components/home/home_events.dart";



class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
          body: Column(
            children: [
              HomeAppBar(scaffoldKey:_scaffoldKey),
              const HomeAppointment(),
              const HomeEvents(),
            ],
          ),
    );
  }
}

