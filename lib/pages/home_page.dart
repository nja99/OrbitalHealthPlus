import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/components/buttons/circle_button.dart';
import 'package:healthsphere/components/home/home_drawer.dart';
import 'package:healthsphere/config/page_config.dart';

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

  void _onCategorySelected(int index) {
    _navigateBottomBar(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: const HomeDrawer(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children:  pages.map((page) => page.pageBuilder(_onCategorySelected, _selectedIndex)).toList(),
      ));
  }

  AppBar _buildAppBar() {

    double toolbarHeight = pages[_selectedIndex].showSearchBar ? 160 : 100;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      scrolledUnderElevation: 0,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inverseSurface,
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
            if (pages[_selectedIndex].showSearchBar) 
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

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100), 
          topRight: Radius.circular(100)
        ),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 40)]
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(100), 
          topRight: Radius.circular(100)
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            // BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.medication), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label:""),
          ]
        ),
      ),
    );
  }
}
