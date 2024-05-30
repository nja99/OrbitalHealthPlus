import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:healthsphere/components/home_app_bar.dart";
import "package:healthsphere/components/home_appointment.dart";
import "package:healthsphere/components/home_events.dart";



class HomeScreen extends StatefulWidget {
  
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
          body: Column(
            children: [
              HomeAppBar(),
              HomeAppointment(),
              HomeEvents(),
            ],
          ),
        ),
    );
  }
}

