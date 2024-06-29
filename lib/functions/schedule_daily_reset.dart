import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:healthsphere/config/firebase_options.dart';
import 'package:healthsphere/services/database/medications_firestore_service.dart';
import 'package:healthsphere/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Timer? midnightTimer;

void scheduleDailyReset() async {
  
  final service = FlutterBackgroundService();

  // Configure Background Service

  await service.configure(
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: true
    )
  );

  service.startService();
}

void onStart(ServiceInstance service) async {

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('UTC'));

  await checkAndPerformReset();
  scheduleMidnightTask();

  service.on('stopService').listen((event) {
    midnightTimer?.cancel();
    service.stopSelf();
  });

}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  return true;
}

Future<void> scheduleMidnightTask() async {
  DateTime now = DateTime.now();
  DateTime localMidnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  Duration timeDifference = localMidnight.difference(now);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("expectedResetTime", localMidnight.toIso8601String());

  midnightTimer = Timer(timeDifference, () async {
    await resetDoseAtMidnight();
    scheduleMidnightTask();
  });
}

Future<void> checkAndPerformReset() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  DateTime now = DateTime.now();
  String? expectedResetTimeString = prefs.getString("expectedResetTime");

  if (expectedResetTimeString != null) {
    DateTime expectedResetTime = DateTime.parse(expectedResetTimeString);

    if(now.isAfter(expectedResetTime)) {
      await resetDoseAtMidnight();
    }
  }

  scheduleMidnightTask();
}

Future<void> resetDoseAtMidnight() async {

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    setUp();
  }

  final firestoreService = getIt<MedicationFirestoreService>();
  await firestoreService.resetDoseStatus();
}

void stopDailyResetService() async {
  final service = FlutterBackgroundService();
  service.invoke('stopService');

  // Wait for a short duration to ensure the service has stopped completely
  await Future.delayed(const Duration(seconds: 2));
}
