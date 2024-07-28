import 'package:flutter/material.dart';
import "package:healthsphere/components/expanded_container.dart";
import "package:healthsphere/components/home/home_appointment.dart";
import "package:healthsphere/components/home/home_drawer.dart";
import "package:healthsphere/components/home/home_events.dart";

class HomeScreen extends StatefulWidget {
  
  final Function(int) onCategorySelected;
  final int currentIndex;

  const HomeScreen({Key? key, required this.onCategorySelected, required this.currentIndex}) : super(key: key);


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
      extendBody: true,
      drawer: const HomeDrawer(),
      body: Column(
        children: [ 
          const SizedBox(height: 50),
          ExpandedContainer(
            padding: EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HomeAppointment(),
                  HomeEvents(onCategorySelected: widget.onCategorySelected, currentIndex: widget.currentIndex),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

