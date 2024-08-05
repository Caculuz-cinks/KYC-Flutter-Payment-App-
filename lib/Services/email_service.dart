import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart'; //For creating the SMTP Server

class EmailService {
  String username = 'iadeleke01@gmail.com';
  String password = 'xxxxxxx';
  Future<void> mail(String email) async {
    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username, 'KYC')
      ..recipients.add(email) //recipent email

      ..subject =
          'Know Your Customer Document Verification ${DateTime.now()}' //subject of the email
      ..text =
          'Hi.\n We\'re thrilled to have you, your documents are pending review, till then, stay cool .'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }
}
