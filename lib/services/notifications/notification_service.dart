import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

// Define the NotificationType enum at the top-level scope
enum NotificationType { inr, medicationReminder, criticalValue }

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _initialized = false;

  // Inicializar el servicio de notificaciones
  static Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(initializationSettings);
    _initialized = true;
  }

  // Enviar notificación push
  static Future<void> sendPushNotification(String title, String body) async {
    await initialize();

    // Verificar si las notificaciones push están habilitadas
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('push') ?? true;
    if (!pushEnabled) return;

    final bool soundEnabled = prefs.getBool('sonido') ?? true;
    final bool vibrationEnabled = prefs.getBool('vibracion') ?? true;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'inright_channel',
          'INRight Notificaciones',
          channelDescription: 'Canal para notificaciones de la app INRight',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(0, title, body, platformChannelSpecifics);

    // Activar sonido si está habilitado
    if (soundEnabled) {
      await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
    }

    // Activar vibración si está habilitado
    // Fix nullable expression issue by using proper null check
    if (vibrationEnabled && (await Vibration.hasVibrator() == true)) {
      Vibration.vibrate(duration: 500);
    }
  }

  // Enviar notificación por email
  static Future<void> sendEmailNotification(
    String subject,
    String body,
    String recipientEmail,
  ) async {
    // Verificar si las notificaciones por email están habilitadas
    final prefs = await SharedPreferences.getInstance();
    final emailEnabled = prefs.getBool('email') ?? false;
    if (!emailEnabled) return;

    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientEmail],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      debugPrint('Error al enviar correo: $e');
    }
  }

  // Mostrar notificación en la app (Snackbar)
  static void showInAppNotification(
    BuildContext context,
    String title,
    String message,
    ContentType contentType,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        inMaterialBanner: true,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Enviar alerta de INR basada en las preferencias del usuario
  static Future<void> sendInrAlert(
    BuildContext context,
    String userEmail,
    double inrValue,
    double minRange,
    double maxRange,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final inrAlertsEnabled = prefs.getBool('alertaInr') ?? true;

    if (!inrAlertsEnabled) return;

    String message;
    ContentType contentType;

    if (inrValue < minRange) {
      message =
          "Tu valor de INR ($inrValue) está por debajo del rango recomendado ($minRange - $maxRange)";
      contentType = ContentType.warning;
    } else if (inrValue > maxRange) {
      message =
          "Tu valor de INR ($inrValue) está por encima del rango recomendado ($minRange - $maxRange)";
      contentType = ContentType.warning;
    } else {
      return; // INR está en rango, no enviar alerta
    }

    final title = "Alerta de INR";

    // Enviar notificación push si está habilitada
    await sendPushNotification(title, message);

    // Enviar email si está habilitado
    await sendEmailNotification(title, message, userEmail);

    // Mostrar notificación en la app
    showInAppNotification(context, title, message, contentType);
  }

  // Enviar alerta de valores críticos
  static Future<void> sendCriticalValueAlert(
    BuildContext context,
    String userEmail,
    double inrValue,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final criticalAlertsEnabled = prefs.getBool('valoresCriticos') ?? true;

    if (!criticalAlertsEnabled || inrValue < 5.0) return;

    final title = "¡ALERTA DE VALOR CRÍTICO!";
    final message =
        "Tu valor de INR ($inrValue) es EXTREMADAMENTE ALTO y podría ser peligroso. Contacta a tu médico inmediatamente.";

    // Enviar notificación push con alta prioridad
    await sendPushNotification(title, message);

    // Enviar email siempre en caso crítico, independientemente de la configuración
    await sendEmailNotification(title, message, userEmail);

    // Mostrar notificación en la app
    showInAppNotification(context, title, message, ContentType.failure);

    // Activar vibración siempre en caso crítico
    // Fix nullable expression issue
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500]);
    }
  }

  // Enviar recordatorio de medicación
  static Future<void> sendMedicationReminder(
    BuildContext context,
    String userEmail,
    String medicationName,
    String dose,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final medicationRemindersEnabled = prefs.getBool('recordatorioMed') ?? true;

    if (!medicationRemindersEnabled) return;

    final title = "Recordatorio de medicación";
    final message = "Es hora de tomar tu $medicationName, dosis: $dose";

    // Enviar notificación push
    await sendPushNotification(title, message);

    // Enviar email si está habilitado
    await sendEmailNotification(title, message, userEmail);

    // Mostrar notificación en la app
    showInAppNotification(context, title, message, ContentType.help);
  }

  // Método para probar cualquier tipo de alerta basado en las preferencias
  static Future<void> testNotification(
    BuildContext context,
    String userEmail,
    NotificationType type,
  ) async {
    switch (type) {
      case NotificationType.inr:
        await sendInrAlert(context, userEmail, 3.8, 2.0, 3.5);
        break;
      case NotificationType.medicationReminder:
        await sendMedicationReminder(context, userEmail, "Warfarina", "5mg");
        break;
      case NotificationType.criticalValue:
        await sendCriticalValueAlert(context, userEmail, 6.2);
        break;
    }
  }
}
