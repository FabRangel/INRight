import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:inright/services/configurations/notification_config.service.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/services/email/email_service.dart';
import 'dart:math';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// Define the NotificationType enum
enum NotificationType { inr, medicationReminder, criticalValues }

class NotificationService {
  // Make sure the plugin is created as a singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;
  static Timer? _medicationReminderTimer;

  // Initialize notification settings
  static Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint("Initializing notification service");

    // Request permissions for iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization with custom sound
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentSound: true,
        );

    // Initialize settings for both platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint("Notification clicked: ${details.payload}");
      },
    );

    _isInitialized = true;
    debugPrint("Notification service initialized successfully");

    // Set up the medication reminder timer
    await setupMedicationReminderTimer();
  }

  // Schedule medication reminder based on the user's set notification time
  static Future<void> setupMedicationReminderTimer() async {
    // Cancel existing timer if any
    _medicationReminderTimer?.cancel();

    try {
      // Get user preferences
      final prefs = await SharedPreferences.getInstance();
      final recordatorioMedEnabled = prefs.getBool('recordatorioMed') ?? false;

      if (!recordatorioMedEnabled) {
        debugPrint('Medication reminders are disabled. Not scheduling timer.');
        return;
      }

      final horaNotificacion = prefs.getString('horaNotificacion') ?? "08:00";

      // Parse notification time
      final timeParts = horaNotificacion.split(':');
      if (timeParts.length != 2) {
        debugPrint('Invalid notification time format: $horaNotificacion');
        return;
      }

      final int hour = int.tryParse(timeParts[0]) ?? 8;
      final int minute = int.tryParse(timeParts[1]) ?? 0;

      // Calculate time until next notification
      final now = DateTime.now();
      var nextNotificationTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (nextNotificationTime.isBefore(now)) {
        nextNotificationTime = nextNotificationTime.add(
          const Duration(days: 1),
        );
      }

      final timeUntilNotification = nextNotificationTime.difference(now);
      debugPrint(
        'Scheduling medication reminder in ${timeUntilNotification.inHours} hours and ${timeUntilNotification.inMinutes % 60} minutes',
      );

      // Schedule the timer to trigger at the exact notification time
      _medicationReminderTimer = Timer(timeUntilNotification, () async {
        await _sendMedicationReminderNotification();
        // Re-schedule for next day after it's triggered
        setupMedicationReminderTimer();
      });
    } catch (e) {
      debugPrint('Error setting up medication reminder: $e');
    }
  }

  // Send the actual medication reminder notification
  static Future<void> _sendMedicationReminderNotification() async {
    try {
      // Get medication config provider to check dose status
      final medicationProvider = await _getMedicationStatus();

      if (medicationProvider == null) {
        return showNotification(
          title: 'Recordatorio de medicación',
          body: 'Es hora de revisar tu medicación diaria.',
          channelId: 'medication_reminders',
          channelName: 'Medication Reminders',
        );
      }

      // Check current dose status
      final now = DateTime.now();
      final dosisHoy = medicationProvider.dosisGeneradas.firstWhere(
        (d) => _isSameDay(d.fecha, now),
        orElse:
            () =>
                DosisDiaria(fecha: now, dosis: 0, hora: '00:00', diaSemana: ''),
      );

      if (dosisHoy.hora == '00:00' || dosisHoy.hora.isEmpty) {
        // No dose scheduled for today
        return showNotification(
          title: 'Recordatorio de medicación',
          body: 'No tienes dosis programadas para hoy.',
          channelId: 'medication_reminders',
          channelName: 'Medication Reminders',
        );
      }

      if (dosisHoy.tomada) {
        // Dose already taken, check next dose
        final nextDose = _findNextDose(medicationProvider, now);
        if (nextDose == null) {
          return showNotification(
            title: 'Dosis tomada correctamente',
            body: 'Has tomado tu dosis de hoy. No hay más dosis pendientes.',
            channelId: 'medication_reminders',
            channelName: 'Medication Reminders',
          );
        }

        final diff = nextDose.difference(now);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;

        return showNotification(
          title: 'Próxima dosis',
          body:
              'Faltan ${hours}h ${minutes}m para tu próxima dosis de ${medicationProvider.anticoagulante}.',
          channelId: 'medication_reminders',
          channelName: 'Medication Reminders',
        );
      } else {
        // Dose not taken
        final doseTimeParts = dosisHoy.hora.split(':');
        if (doseTimeParts.length != 2) return;

        final doseTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(doseTimeParts[0]),
          int.parse(doseTimeParts[1]),
        );

        if (doseTime.isAfter(now)) {
          // Dose is scheduled for later today
          final diff = doseTime.difference(now);
          final hours = diff.inHours;
          final minutes = diff.inMinutes % 60;

          return showNotification(
            title: 'Recordatorio de medicación',
            body:
                'Faltan ${hours}h ${minutes}m para tu dosis de ${medicationProvider.anticoagulante}.',
            channelId: 'medication_reminders',
            channelName: 'Medication Reminders',
          );
        } else {
          // User is late for their dose
          final delay = now.difference(doseTime);
          final hours = delay.inHours;
          final minutes = delay.inMinutes % 60;

          return showNotification(
            title: '¡Dosis retrasada!',
            body:
                'Te retrasaste ${hours}h ${minutes}m en tomar tu dosis de ${medicationProvider.anticoagulante}.',
            channelId: 'medication_reminders',
            channelName: 'Medication Reminders',
          );
        }
      }

      // Get required shared preferences for email notifications
      final prefs = await SharedPreferences.getInstance();
      final emailEnabled = prefs.getBool('email') ?? false;
      final userEmail = prefs.getString('userEmail') ?? '';

      // Check if email notifications are enabled and email is valid
      if (emailEnabled && userEmail.isNotEmpty && userEmail.contains('@')) {
        String message;
        bool isLate = false;

        // Determine the email content based on the medication status
        if (dosisHoy.tomada) {
          message = 'Has tomado tu dosis de hoy correctamente.\n\n';

          if (nextDose != null) {
            final diff = nextDose.difference(now);
            final hours = diff.inHours;
            final minutes = diff.inMinutes % 60;
            message += 'Tu próxima dosis está programada en ${hours}h ${minutes}m.';
          } else {
            message += 'No tienes más dosis programadas por ahora.';
          }
        } else if (doseTime.isAfter(now)) {
          final diff = doseTime.difference(now);
          final hours = diff.inHours;
          final minutes = diff.inMinutes % 60;

          message = 'Te recordamos que tienes una dosis programada de ${medicationProvider.anticoagulante} en ${hours}h ${minutes}m.\n\nNo olvides registrarla en la aplicación una vez tomada.';
        } else {
          final delay = now.difference(doseTime);
          final hours = delay.inHours;
          final minutes = delay.inMinutes % 60;

          message = '¡Alerta! Te has retrasado ${hours}h ${minutes}m en tomar tu dosis de ${medicationProvider.anticoagulante}.\n\nPor favor, tómala lo antes posible y regístrala en la aplicación.';
          isLate = true;
        }

        await EmailService.sendMedicationReminderEmail(
          to: userEmail,
          medicationName: medicationProvider.anticoagulante,
          message: message,
          isLate: isLate,
        );
      }
    } catch (e) {
      debugPrint('Error sending medication reminder: $e');
      showNotification(
        title: 'Recordatorio de medicación',
        body: 'No olvides revisar tu medicación diaria.',
        channelId: 'medication_reminders',
        channelName: 'Medication Reminders',
      );
    }
  }

  // Helper method to get medication status
  static Future<MedicationConfigProvider?> _getMedicationStatus() async {
    try {
      final provider = MedicationConfigProvider();
      // Load medication config data
      await provider.loadMedicationConfig();
      if (provider.dosisGeneradas.isEmpty) {
        provider.generarDosisSegunEsquema(silent: true);
      }
      return provider;
    } catch (e) {
      debugPrint('Error getting medication status: $e');
      return null;
    }
  }

  // Helper method to check if two dates are on the same day
  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Helper method to find the next scheduled dose
  static DateTime? _findNextDose(
    MedicationConfigProvider provider,
    DateTime after,
  ) {
    final pendingDoses =
        provider.dosisGeneradas.where((d) {
          if (d.tomada) return false;
          if (d.hora == '00:00' || d.hora.isEmpty) return false;

          final parts = d.hora.split(':');
          if (parts.length != 2) return false;

          final doseTime = DateTime(
            d.fecha.year,
            d.fecha.month,
            d.fecha.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          );

          return doseTime.isAfter(after);
        }).toList();

    if (pendingDoses.isEmpty) return null;

    // Sort by date and time
    pendingDoses.sort((a, b) {
      final aTime = DateTime(
        a.fecha.year,
        a.fecha.month,
        a.fecha.day,
        int.parse(a.hora.split(':')[0]),
        int.parse(a.hora.split(':')[1]),
      );

      final bTime = DateTime(
        b.fecha.year,
        b.fecha.month,
        b.fecha.day,
        int.parse(b.hora.split(':')[0]),
        int.parse(b.hora.split(':')[1]),
      );

      return aTime.compareTo(bTime);
    });

    final nextDose = pendingDoses.first;
    final timeParts = nextDose.hora.split(':');

    return DateTime(
      nextDose.fecha.year,
      nextDose.fecha.month,
      nextDose.fecha.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  // Show a notification with guaranteed unique ID and custom sound
  static Future<void> showNotification({
    required String title,
    required String body,
    String channelId = 'inr_alerts',
    String channelName = 'INR Alerts',
    String channelDescription =
        'Notifications for INR values outside of target range',
  }) async {
    await initialize();

    // Generate a random ID to ensure notifications don't override each other
    final int notificationId = Random().nextInt(100000);

    debugPrint("Preparing to show notification: $title - $body");

    try {
      // Get user preferences for sound and vibration
      final prefs = await SharedPreferences.getInstance();
      final enableSound = prefs.getBool('sonido') ?? true;
      final enableVibration = prefs.getBool('vibracion') ?? true;

      // Configure Android notification details with custom sound
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            playSound: enableSound,
            sound:
                enableSound
                    ? const RawResourceAndroidNotificationSound('notification')
                    : null,
            enableVibration: enableVibration,
            visibility: NotificationVisibility.public,
            icon: '@mipmap/ic_launcher',
          );

      // Configure iOS notification details with custom sound
      DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: enableSound,
            sound: enableSound ? 'notification.mp3' : null,
          );

      // Combine platform-specific details
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      // Display the notification
      await _notificationsPlugin.show(
        notificationId,
        title,
        body,
        platformChannelSpecifics,
      );

      // Also play notification sound explicitly if enabled
      if (enableSound) {
        try {
          // Using AudioPlayer directly for sound
          final AudioPlayer audioPlayer = AudioPlayer();
          await audioPlayer.play(AssetSource('sounds/notification.mp3'));
        } catch (soundError) {
          debugPrint('Error playing notification sound: $soundError');
        }
      }

      debugPrint("Notification sent successfully: $title - $body");
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Method to test notifications of different types
  static Future<void> testNotification(
    BuildContext context,
    String userEmail,
    NotificationType type,
  ) async {
    switch (type) {
      case NotificationType.inr:
        await showNotification(
          title: 'Alerta de INR',
          body:
              'Tu valor de INR está fuera del rango recomendado. Consulta a tu médico.',
        );
        break;
      case NotificationType.medicationReminder:
        await showNotification(
          title: 'Recordatorio de medicación',
          body:
              'Es hora de tomar tu medicación. ¡No olvides registrar tu dosis!',
          channelId: 'medication_reminders',
          channelName: 'Medication Reminders',
          channelDescription: 'Recordatorios para tomar medicamentos',
        );
        break;
      case NotificationType.criticalValues:
        await showNotification(
          title: '¡Alerta de valor crítico!',
          body:
              'Tu valor de INR ha alcanzado un nivel crítico. Contacta a tu médico inmediatamente.',
          channelId: 'critical_values',
          channelName: 'Critical Values',
          channelDescription: 'Alertas para valores críticos de INR',
        );
        break;
    }
  }

  // Send push notification
  static Future<void> sendPushNotification(String title, String body) async {
    await showNotification(title: title, body: body);
  }

  // Send email notification (this would typically connect to a backend service)
  static Future<void> sendEmailNotification(
    String subject,
    String body,
    String email,
  ) async {
    try {
      final Email emailMessage = Email(
        body: body,
        subject: subject,
        recipients: [email],
        isHTML: false,
      );

      await FlutterEmailSender.send(emailMessage);
      debugPrint('Email notification sent to: $email');
    } catch (e) {
      // Fallback to email intent if direct sending fails
      try {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: email,
          query: encodeQueryParameters({
            'subject': subject,
            'body': body,
          }),
        );

        // Open email client
        // This would typically involve using url_launcher package
        debugPrint('Email notification URI created: $emailLaunchUri');
        debugPrint('Email would be sent to: $email');
        debugPrint('Subject: $subject');
        debugPrint('Body: $body');
      } catch (e) {
        debugPrint('Error creating email intent: $e');
      }
    }
  }

  // Helper method to encode query parameters
  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Update medication reminder schedule when notification settings change
  static Future<void> updateMedicationReminderSettings() async {
    await setupMedicationReminderTimer();
  }
}
