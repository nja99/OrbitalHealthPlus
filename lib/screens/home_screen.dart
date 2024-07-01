import 'package:flutter/material.dart';
import "package:healthsphere/components/expanded_container.dart";
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
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      drawer: const HomeDrawer(),
      body: const Column(
        children: [ 
          SizedBox(height: 50),
          ExpandedContainer(
            padding: EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HomeAppointment(),
                  HomeEvents(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

