import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:healthsphere/components/circle_button.dart";
import 'package:healthsphere/screens/home_screen.dart';


class HomeAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeAppBar({super.key,required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, \nGood Morning!',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
              ),
              CircleButton(
                icon: Icons.menu,
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 380.0, // Set width
              height: 48.0, // Set height
              child: CupertinoSearchTextField(
                backgroundColor: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





