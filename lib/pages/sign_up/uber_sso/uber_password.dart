import 'package:belay/components/single_page_input.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../../root.dart';
import '../../../utils/style.dart';

class UberPassword extends StatelessWidget {
  final void Function()? onContinue;
  final bool isSignup;
  final String sessionId;
  UberPassword({required this.onContinue, required this.isSignup, required this.sessionId});
  @override
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: 'Enter your password',
      info:
          isSignup ? 'Enter your Uber account password to finish connecting your account.' : 'Enter your Uber account password to finish logging in.',
      handleBack: () => Navigator.pop(context),
      form: UberPasswordForm(
        handleContinue: onContinue,
        isSignup: isSignup,
        sessionId: sessionId,
      ),
    );
  }
}

class UberPasswordForm extends HookWidget {
  final handleContinue;
  final bool isSignup;
  final String sessionId;
  UberPasswordForm({
    required this.handleContinue,
    required this.isSignup,
    required this.sessionId,
  });

  final header = {
    "Accept": 'application/json',
    'Content-type': 'application/json',
  };

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ValueNotifier<UserWrapper>>(context, listen: true);
    final passwordController = useTextEditingController();

    final isSubmitting = useState(false);
    final error = useState('');

    void handleConnectAccount() async {
      isSubmitting.value = true;
      error.value = '';

      if (passwordController.text == '') {
        error.value = 'Please enter a password.';
        isSubmitting.value = false;
      }

      Analytics.trackUberPasswordAttempt();

      try {
        final response = await http.post(
          Uri.parse('https://us-central1-infra-test-308817.cloudfunctions.net/new_uber_sso'),
          headers: header,
          body: jsonEncode(<String, dynamic>{
            'stage': 'sign_in',
            'session_id': sessionId,
            'event_type': 'TypeVerifyPassword',
            'credentials': {
              'password': passwordController.text,
            }
          }),
        );
        switch (response.statusCode) {
          case 200:
            {
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
            }
            break;
          case 400:
            {
              isSubmitting.value = false;
              error.value = 'Password is incorrect. Please try again.';
            }
            break;
          case 401:
            {
              isSubmitting.value = false;
              error.value = 'Password is incorrect. Please try again.';
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
        Container(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: passwordController,
            decoration: Style.getInputTextDecoration('Password'),
            enabled: !isSubmitting.value,
            obscureText: true,
            style: Style.inputText,
            cursorColor: Style.cursorColor,
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
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: TextButton(
              child: Text(
                'Forgot your password?',
                style: Style.h4,
              ),
              onPressed: () {
                Analytics.mixpanel!.track('Forgot password');
                launch("https://auth.uber.com/login/forgot-password");
              }),
        ),
        Container(
          padding: EdgeInsets.only(top: 40 * Style.ratioV!),
          child: ElevatedButton(
            child: Text('Continue'),
            style: Style.btn1,
            onPressed: isSubmitting.value ? null : handleConnectAccount,
          ),
        ),
      ],
    );
  }
}
