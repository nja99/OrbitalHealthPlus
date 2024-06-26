import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:healthsphere/components/buttons/circle_button.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
import 'package:healthsphere/screens/appointment_screen.dart';
import 'package:healthsphere/screens/home_screen.dart';
import 'package:healthsphere/screens/medication_screen.dart';
import 'package:healthsphere/utils/page_data.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<PageData> _pages = [
    PageData(page: const HomeScreen(), title: "Home", showSearchBar: true),
    PageData(page: const HomeScreen(), title: "Health Monitor"),
    PageData(page: const MedicationScreen(), title: "Medications"),
    PageData(page: const AppointmentScreen(), title: "Appointments"),
    PageData(page: const HomeScreen(), title: "Home"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages.map((item) => item.page).toList(),
      ),
      appBar: _buildAppBar(),
      drawer: const HomeDrawer(),
      bottomNavigationBar: _buildBottomNavigationBar());
  }

  AppBar _buildAppBar() {

    double toolbarHeight =_pages[_selectedIndex].showSearchBar ? 160 : 100;

    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF887FF2),
              Color(0xFF6849EF)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )
        ),
      ),
      toolbarHeight: toolbarHeight,
      title: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleButton(
                  icon: Icons.menu,
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Text(
                  "Hello, \nGood Morning!",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_pages[_selectedIndex].showSearchBar) 
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: CupertinoSearchTextField(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
          ],
        ),
      )
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4B25DD),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label:""),
        ]);
  }
}
