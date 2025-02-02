import 'package:flutter/services.dart';
import 'package:healthsphere/pages/auth/login_page.dart';
import 'package:healthsphere/pages/home_page.dart';
import 'package:healthsphere/pages/user_onboarding/onboarding_page.dart';
import 'package:healthsphere/pages/user_onboarding/profile_collection_page.dart';
import 'package:healthsphere/services/auth/auth_provider.dart';
import 'package:healthsphere/services/notification/notification_service.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:healthsphere/services/user/user_profile_service.dart';
import 'package:healthsphere/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'config/firebase_options.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  
  // Initialize Service Providers
  setUp();
  await getIt.allReady();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Make status bar transparent
    statusBarIconBrightness:
        Brightness.light, // Set the color of status bar icons
  ));
  

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => AuthProvider())
        ],
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
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfileService = getIt<UserProfileService>();

    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: isFirstLaunch 
        ? const OnBoardingPage() 
        : authProvider.user == null
          ? const LoginPage()
          : FutureBuilder<bool>(
            future: userProfileService.isProfileCreated(authProvider.user!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data == true) {
                return const HomePage();
              } else {
                return const ProfileCollectionPage();
              }
            }
          ),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }

}