import 'package:flutter/material.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
import 'package:healthsphere/screens/appointment_screen.dart';
import 'package:healthsphere/screens/home_screen.dart';
import 'package:healthsphere/utils/page_data.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<PageData> _pages = [
    PageData(page: const HomeScreen(), title: "Home"),
    PageData(page: const AppointmentScreen(), title: "Appointments"),
    PageData(page: const HomeScreen(), title: "Home"),
    PageData(page: const HomeScreen(), title: "Home"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages.map((item) => item.page).toList(),
        ),
        appBar: _buildAppBar(),
        drawer: const HomeDrawer(),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: Text(_pages[_selectedIndex].title),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF4B25DD)),
        centerTitle: true,
        backgroundColor: Colors.white);
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottomBar,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4B25DD),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ]);
  }
}
