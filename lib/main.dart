import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/onboarding_page.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light, // Set the color of status bar icons
    )
  );
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Initialize Service Providers
  setUp();
  await getIt.allReady();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(isFirstLaunch: isFirstLaunch),
      )
    );
  });
}

class MyApp extends StatelessWidget {

  final bool isFirstLaunch;
  
  const MyApp({
    super.key,
    required this.isFirstLaunch
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: isFirstLaunch ? const OnBoardingPage() : const LoginPage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }

}