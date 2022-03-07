import 'package:belay/components/single_page_input.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'uber_verification.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../utils/style.dart';

class UberAccountSelection extends StatelessWidget {
  final void Function()? onContinue;
  final bool isSignup;
  final String sessionId;
  final List<String> emails;
  UberAccountSelection({required this.isSignup, required this.onContinue, required this.sessionId, required this.emails});
  @override
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: 'Select your account',
      info: 'Select the email below that is associated\nwith your Uber Driver account',
      handleBack: () => Navigator.pop(context),
      form: UberAccountSelectionForm(
        handleContinue: onContinue,
        isSignup: isSignup,
        sessionId: sessionId,
        emails: emails,
      ),
    );
  }
}

class UberAccountSelectionForm extends HookWidget {
  final handleContinue;
  final bool isSignup;
  final String sessionId;
  final List<String> emails;
  UberAccountSelectionForm({required this.handleContinue, required this.isSignup, required this.sessionId, required this.emails});
  @override
  Widget build(BuildContext context) {
    final isSubmitting = useState(false);
    final error = useState('');
    final selectionIndex = useState(0);

    void handleConnectAccount() async {
      Analytics.mixpanel!.track('Uber select final auth method');
      isSubmitting.value = true;
      error.value = '';

      if (selectionIndex.value == 0) {
        error.value = 'Please select an account.';
        isSubmitting.value = false;
        return;
      }

      final header = {
        "Accept": 'application/json',
        'Content-type': 'application/json',
      };

      try {
        final response = await http.post(
          Uri.parse('https://us-central1-infra-test-308817.cloudfunctions.net/new_uber_sso'),
          headers: header,
          body: jsonEncode(<String, dynamic>{
            'session_id': sessionId,
            'stage': 'sign_in',
            'event_type': 'TypeSelectAccount',
            'credentials': {'account_index': selectionIndex.value},
            'data_collection': true,
          }),
        );
        switch (response.statusCode) {
          case 200:
            {
              isSubmitting.value = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UberVerification(
                    sessionId: jsonDecode(response.body)['session_id'],
                    handleContinue: handleContinue,
                    isSignup: isSignup,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: emails
              .asMap()
              .map(
                (i, email) => MapEntry(
                  i,
                  GestureDetector(
                    onTap: (() {
                      selectionIndex.value = i + 1;
                    }),
                    child: Card(
                      shape: selectionIndex.value == i + 1
                          ? new RoundedRectangleBorder(side: new BorderSide(color: Style.blue, width: 3.0), borderRadius: BorderRadius.circular(5.0))
                          : new RoundedRectangleBorder(
                              side: new BorderSide(color: Colors.transparent, width: 3.0), borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          email,
                          textAlign: TextAlign.center,
                          style: Style.p1,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
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
            onPressed: isSubmitting.value && selectionIndex.value > 0 ? null : handleConnectAccount,
          ),
        ),
      ],
    );
  }
}
