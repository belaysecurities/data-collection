import 'package:belay/components/single_page_input.dart';
import 'package:belay/main.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:belay/root.dart';
import 'package:provider/provider.dart';

import '../../../utils/style.dart';

class UberEmailVerification extends StatelessWidget {
  final String sessionId;
  final void Function() handleContinue;
  final bool isSignup;
  final String emailHint;

  UberEmailVerification({
    required this.sessionId,
    required this.isSignup,
    required this.handleContinue,
    required this.emailHint,
  });

  @override
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: 'Enter 4 digit pin',
      info: 'Uber will send you a 4 digit pin code to $emailHint. Enter it below.',
      handleBack: () => {Navigator.pop(context)},
      form: UberEmailForm(
        isSignup: isSignup,
        sessionId: sessionId,
        handleContinue: handleContinue,
      ),
    );
  }
}

class UberEmailForm extends HookWidget {
  final String sessionId;
  final void Function() handleContinue;
  final bool isSignup;
  UberEmailForm({
    required this.sessionId,
    required this.handleContinue,
    required this.isSignup,
  });
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ValueNotifier<UserWrapper>>(context, listen: true);
    final codeController = useTextEditingController();
    final isSubmitting = useState(false);
    final error = useState('');

    void handleVerify() async {
      if (codeController.value.text == '' || codeController.value.text.length != 4) {
        error.value = 'Please enter your 4 digit code.';
        return;
      }

      Analytics.trackUberEmailAttempt();
      isSubmitting.value = true;
      error.value = '';

      final header = {
        "Accept": 'application/json',
        'Content-type': 'application/json',
      };
      try {
        final response = await http.post(
          Uri.parse('https://us-central1-infra-test-308817.cloudfunctions.net/new_uber_sso'),
          headers: header,
          body: jsonEncode(<String, dynamic>{
            'stage': 'sign_in',
            'event_type': 'TypeEmailOTP',
            'session_id': sessionId,
            'credentials': {'email_code': codeController.text},
          }),
        );
        switch (response.statusCode) {
          case 200:
            try {
              await auth.signInWithCustomToken(jsonDecode((response.body))['user_token']);
            } catch (ex) {
              print('Debug: ' + ex.toString());
              await auth.signInWithCustomToken(jsonDecode((response.body))['user_token']);
            }
            while (notifier.value.user == null) {
              await Future.delayed(Duration(milliseconds: 100));
            }
            isSubmitting.value = false;

            handleContinue();

            break;
          case 400:
            isSubmitting.value = false;
            error.value = 'Invalid pin entered. Please try again.';
            break;
          case 401:
            isSubmitting.value = false;
            error.value = 'Invalid pin entered. Please try again.';
            break;
          case 429:
            {
              isSubmitting.value = false;
              error.value = 'Sign up rate limit hit! Try again in a few hours.';
            }
            break;
          case 500:
            isSubmitting.value = false;
            error.value = 'Server error! We are working on a fix, please try again later.';
            break;
          default:
            error.value = 'Something unexpected happened, please try again later.';
            break;
        }
      } catch (ex) {
        isSubmitting.value = false;
        error.value = 'Something unexpected happened, please try again later.';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          child: TextFormField(
            controller: codeController,
            autofocus: true,
            textAlign: TextAlign.center,
            decoration: Style.getInputTextDecoration('Verification Code'),
            enabled: !isSubmitting.value,
            cursorColor: Style.cursorColor,
            style: Style.inputText,
          ),
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
        Padding(padding: EdgeInsets.only(top: 20)),
        TextButton(
          child: Text(
            'Send another code',
            style: Style.h4,
          ),
          onPressed: () => {
            http.post(
              Uri.parse('https://us-central1-infra-test-308817.cloudfunctions.net/new_uber_sso'),
              headers: {
                "Accept": 'application/json',
                'Content-type': 'application/json',
              },
              body: jsonEncode(<String, dynamic>{
                'stage': 'options',
                'session_id': sessionId,
                'event_type': 'TypeEmailOTP',
              }),
            )
          },
        ),
        Container(
          padding: EdgeInsets.only(top: 40),
          child: ElevatedButton(
            child: Text('Continue'),
            style: Style.btn1,
            onPressed: isSubmitting.value ? null : handleVerify,
          ),
        ),
      ],
    );
  }
}
