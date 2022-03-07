import 'package:belay/components/single_page_input.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'uber_email_verification.dart';
import 'uber_password.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/style.dart';

class UberMethodSelection extends StatelessWidget {
  final void Function()? onContinue;
  final bool isSignup;
  final String sessionId;
  UberMethodSelection({required this.isSignup, required this.onContinue, required this.sessionId});
  @override
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: 'Select authentication method',
      info: 'Finish connecting to Uber with either your password or a code sent to your email.',
      handleBack: () => Navigator.pop(context),
      form: UberMethodSelectionForm(
        handleContinue: onContinue,
        isSignup: isSignup,
        sessionId: sessionId,
      ),
    );
  }
}

class UberMethodSelectionForm extends HookWidget {
  final handleContinue;
  final bool isSignup;
  final String sessionId;
  UberMethodSelectionForm({required this.handleContinue, required this.isSignup, required this.sessionId});
  @override
  Widget build(BuildContext context) {
    final isSubmitting = useState(false);
    final error = useState('');
    final selectionIndex = useState(0);

    void handleConnectAccount() async {
      isSubmitting.value = true;
      error.value = '';

      if (selectionIndex.value == 0) {
        error.value = 'Please select a method.';
        isSubmitting.value = false;
        return;
      }

      final header = {
        "Accept": 'application/json',
        'Content-type': 'application/json',
      };
      if (selectionIndex.value == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UberPassword(
              sessionId: sessionId,
              onContinue: handleContinue,
              isSignup: isSignup,
            ),
          ),
        );
      } else {
        try {
          final response = await http.post(
            Uri.parse('https://us-central1-infra-test-308817.cloudfunctions.net/new_uber_sso'),
            headers: header,
            body: jsonEncode(<String, dynamic>{
              'stage': 'options',
              'session_id': sessionId,
              'event_type': 'TypeEmailOTP',
            }),
          );
          switch (response.statusCode) {
            case 200:
              {
                isSubmitting.value = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UberEmailVerification(
                      sessionId: sessionId,
                      handleContinue: handleContinue,
                      isSignup: isSignup,
                      emailHint: jsonDecode(response.body)['hint'],
                    ),
                  ),
                );
              }
              break;
            case 429:
              {
                isSubmitting.value = false;
                error.value = 'Sign up rate limit hit! Try again in a few hours.';
              }
              break;
            case 500:
              {
                isSubmitting.value = false;
                error.value = 'Server error! We\'re working to fix it, try again soon.';
              }
              break;
            default:
              {
                isSubmitting.value = false;
                error.value = 'Server error! We\'re working to fix it, try again soon.';
              }
          }
        } catch (ex) {
          isSubmitting.value = false;
          print(ex);
          error.value = 'Server error! We\'re working to fix it, try again soon.';
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => selectionIndex.value = 1,
              child: Card(
                shape: selectionIndex.value == 1
                    ? new RoundedRectangleBorder(side: new BorderSide(color: Style.blue, width: 3.0), borderRadius: BorderRadius.circular(5.0))
                    : new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.transparent, width: 3.0), borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Authenticate with password',
                    textAlign: TextAlign.center,
                    style: Style.p1,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => selectionIndex.value = 2,
              child: Card(
                shape: selectionIndex.value == 2
                    ? new RoundedRectangleBorder(side: new BorderSide(color: Style.blue, width: 3.0), borderRadius: BorderRadius.circular(5.0))
                    : new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.transparent, width: 3.0), borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    'Authenticate with email PIN',
                    textAlign: TextAlign.center,
                    style: Style.p1,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (error.value.isNotEmpty)
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              error.value,
              textAlign: TextAlign.center,
              style: Style.errorText,
            ),
          ),
        Container(
          padding: EdgeInsets.only(top: 50 * Style.ratioV!),
          child: ElevatedButton(
            child: Text('Continue'),
            style: Style.btn1,
            onPressed: isSubmitting.value || selectionIndex.value == 0 ? null : handleConnectAccount,
          ),
        ),
      ],
    );
  }
}
