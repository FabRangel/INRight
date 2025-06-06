import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailService {
  // Send an email using the flutter_email_sender package
  static Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
    List<String>? cc,
    List<String>? bcc,
    List<String>? attachmentPaths,
    bool isHTML = false,
  }) async {
    try {
      final Email email = Email(
        body: body,
        subject: subject,
        recipients: [to],
        cc: cc,
        bcc: bcc,
        attachmentPaths: attachmentPaths,
        isHTML: isHTML,
      );

      await FlutterEmailSender.send(email);
      debugPrint('Email sent to $to successfully');
      return true;
    } catch (e) {
      debugPrint('Error sending email with FlutterEmailSender: $e');
      
      // Try fallback method using URL launcher
      return _sendEmailViaUrlLauncher(to, subject, body);
    }
  }

  // Fallback method using URL launcher to open the default email client
  static Future<bool> _sendEmailViaUrlLauncher(
    String to,
    String subject,
    String body,
  ) async {
    try {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: to,
        query: _encodeQueryParameters({
          'subject': subject,
          'body': body,
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        debugPrint('Email client launched for $to');
        return true;
      } else {
        debugPrint('Could not launch email client');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching email client: $e');
      return false;
    }
  }

  // Helper method to encode query parameters
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Send medication reminder email
  static Future<bool> sendMedicationReminderEmail({
    required String to,
    required String medicationName,
    required String message,
    required bool isLate,
  }) async {
    final String subject = isLate
        ? 'INRight: ¡Dosis retrasada de $medicationName!'
        : 'INRight: Recordatorio de medicación - $medicationName';

    final String htmlBody = '''
    <html>
      <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; color: #333;">
        <div style="max-width: 600px; margin: 0 auto; background-color: #f9f9f9; border-radius: 10px; overflow: hidden; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
          <div style="background-color: ${isLate ? '#FFCCCC' : '#CCE5FF'}; padding: 20px; text-align: center;">
            <h2 style="color: ${isLate ? '#CC0000' : '#0066CC'}; margin: 0;">
              ${isLate ? '¡Alerta de dosis retrasada!' : 'Recordatorio de medicación'}
            </h2>
          </div>
          <div style="padding: 20px;">
            <p style="font-size: 16px; line-height: 1.5;">$message</p>
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center; color: #666; font-size: 12px;">
              <p>Este correo fue enviado automáticamente desde la aplicación INRight.</p>
              <p>No responda a este correo.</p>
            </div>
          </div>
        </div>
      </body>
    </html>
    ''';

    return await sendEmail(
      to: to,
      subject: subject,
      body: htmlBody,
      isHTML: true,
    );
  }
}
