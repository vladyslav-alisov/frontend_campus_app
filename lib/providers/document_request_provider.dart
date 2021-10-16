import 'package:campus_app/models/User.dart';
import 'package:campus_app/utils/my_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


class DocumentRequestProvider with ChangeNotifier {
  DocumentRequestProvider(this.authData);
  final User authData;

  Future<void> sendTranscriptRequest(String purpose) async {
    final Email email = Email(
      body: "Hello, I’m ${authData.profile.name} ${authData.profile.surname} from ${authData.profile.department} with ${authData.profile.userID} student number. I need to get my transcript document for $purpose. Can you please prepare the document as soon as possible? Regards",
      subject: "Transcript Request",
      recipients: [str_studentAffairEmail],
      cc: [],
      bcc: [],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
