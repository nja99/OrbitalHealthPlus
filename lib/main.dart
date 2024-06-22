import 'package:flutter/services.dart';
import 'package:healthsphere/pages/onboarding_page.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light, // Set the color of status bar icons
    )
  );
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      )
    );
  });
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: const OnBoardingPage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }

}