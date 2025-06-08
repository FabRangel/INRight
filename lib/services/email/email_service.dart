import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  /// Sends a medication reminder email to the specified recipient
  static Future<void> sendMedicationReminderEmail({
    required String to,
    required String medicationName,
    required String message,
    bool isLate = false,
  }) async {
    try {
      // Create a meaningful subject based on whether the dose is late
      final subject =
          isLate
              ? '⚠️ ALERTA: Dosis retrasada de $medicationName'
              : 'Recordatorio de medicación: $medicationName';

      // Format the email content
      final emailContent = '''
Recordatorio de Medicación - INRight

$message

Este es un mensaje automático de la aplicación INRight.
Por favor, no responda a este correo.

--
INRight - Tu asistente de seguimiento para anticoagulación
''';

      // Prepare the email object
      final Email email = Email(
        body: emailContent,
        subject: subject,
        recipients: [to],
        isHTML: false,
      );

      // Send the email
      await FlutterEmailSender.send(email);
      debugPrint('Medication reminder email sent successfully to: $to');
    } catch (e) {
      debugPrint('Error sending medication reminder email: $e');
      // Create a mailto URI as fallback
      try {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: to,
          query: _encodeQueryParameters({
            'subject':
                isLate
                    ? '⚠️ ALERTA: Dosis retrasada de $medicationName'
                    : 'Recordatorio de medicación: $medicationName',
            'body': message,
          }),
        );

        debugPrint('Email URI created as fallback: $emailLaunchUri');
        // Note: We would typically use url_launcher to open this URI
        // but we're just logging it for now
      } catch (fallbackError) {
        debugPrint('Error creating fallback email URI: $fallbackError');
      }
    }
  }

  // Helper method to encode query parameters for mailto URI
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
