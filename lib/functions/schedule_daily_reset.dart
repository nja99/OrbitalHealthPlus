import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:healthsphere/services/auth/auth_service_locator.dart';
import 'package:healthsphere/services/database/medications_firestore_service.dart';

class DailyResetScheduler {
  static const int alarmID = 0;
  DateTime now = DateTime.now();

  Future<void> scheduledDailyReset() async {
    await AndroidAlarmManager.periodic(
      const Duration(hours: 24), 
      alarmID, 
      resetDoseStatus,
      startAt: DateTime(now.year, now.month, now.day + 1, 0, 0),
      exact: true,
      wakeup: true
    );
  }

  @pragma('vm:entry-point')
  static Future<void> resetDoseStatus() async {
    final firestoreService = getIt<MedicationFirestoreService>();
    await firestoreService.resetDoseStatus();
  }
}