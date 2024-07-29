import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:healthsphere/utils/time_of_day_extension.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class NotificationService extends ChangeNotifier {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize the FlutterLocalNotificationsPlugin
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleAppointment(int notificationId, String title, String body, DateTime appointmentDateTime) async {

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone)); 

    DateTime dayBeforeDateTime = appointmentDateTime.subtract(const Duration(days: 1));
    DateTime threeHoursBeforeDateTime = appointmentDateTime.subtract(const Duration(hours: 3));

    // Configure the notification details
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'appointment_channel_id',
      'Appointments',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      notificationId,
      "$title in 1 Day",
      body,
      tz.TZDateTime.from(dayBeforeDateTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId + 1,
      '$title in 3 Hours',
      body,
      tz.TZDateTime.from(threeHoursBeforeDateTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleMedicationReminders(int userId, String body, List<String> sortedTimes) async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medication_channel_id',
      'Medication Reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    int notificationId = userId.hashCode;
    await cancelMedicationReminders(notificationId);

    for (String sortedTime in sortedTimes) {
      TimeOfDay scheduledTime = TimeOfDayExtension.toTimeOfDay(sortedTime);

      await _notificationsPlugin.zonedSchedule(
        notificationId,
        "It's time to take your Medication!",
        body,
        _nextScheduledReminder(scheduledTime),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      notificationId++;
    }
  }

  static Future<void> cancelAppointment(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);
    await _notificationsPlugin.cancel(notificationId + 1);
  }

  static Future<void> cancelMedicationReminders(int startNotificationId) async {
    for (int i = 0; i < 50; i++) {
      await _notificationsPlugin.cancel(startNotificationId + i);
    }
  }

  static tz.TZDateTime _nextScheduledReminder(TimeOfDay scheduledTime) {
    DateTime now = DateTime.now();
    DateTime scheduledDateTime = DateTime(now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);
    if (now.isAfter(scheduledDateTime)) {
      scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
    }

    return tz.TZDateTime.from(scheduledDateTime, tz.local);
  }

}