import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailService {
  final String username = 'Swaag!';
  final String email = 'chasseuragace@gmail.com';
  final String password = 'fpzjeaamhtauqlvn';
  final String name = "Swaag";

  late final SmtpServer smtpServer;
  MailService(
      //{
      // required this.name,
      // required this.email,
      // required this.password,
      // required this.port,
      // required this.smtpAddress,
      //}
      ) {
    smtpServer = SmtpServer(
      'smtp.gmail.com',
      port: 587,
      username: email,
      password: password,
    );
  }

  Future<bool> sendMail(
    String subject,
    String messageBody,
    String recipient,
  ) async {
    final message = Message()
      ..from = Address(email, name)
      ..recipients.add(recipient)
      ..subject = subject
      ..html = messageBody;

    try {
      final sendReport = await send(message, smtpServer);
      print(sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent: ${e}');
      return false;
    } on Exception catch (e) {
      print('Message not sent: ${e}');
      return false;
    }
  }
}
