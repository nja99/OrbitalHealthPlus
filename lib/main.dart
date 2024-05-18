import 'package:healthsphere/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthsphere/services/auth/auth_page.dart';
import 'package:healthsphere/services/providers/auth_providers.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const AuthProviders(
        child: MyApp()),
    )
  );
  
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }

}