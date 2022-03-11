import 'package:belay/components/single_page_input.dart';
import 'package:belay/pages/sign_up/manual_login.dart';
import 'package:belay/pages/sign_up/uber_sso/uber_account_selection.dart';
import 'package:belay/pages/sign_up/uber_sso/uber_method_selection.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../../../root.dart';
import 'uber_verification.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../../utils/style.dart';

class UberSSO extends StatelessWidget {
  final void Function()? onContinue;
  final bool isSignup;
  UberSSO({required this.isSignup, required this.onContinue});
  @override
  Widget build(BuildContext context) {
    return SinglePageInput(
      headerText: 'Connect with Uber',
      info: 'Securely connect your Uber account to verify your rideshare income.',
      handleBack: () => Navigator.pop(context),
      form: UberSSOForm(
        handleContinue: onContinue,
        isSignup: isSignup,
      ),
    );
  }
}

class UberSSOForm extends HookWidget {
  final handleContinue;
  final bool isSignup;
  UberSSOForm({required this.handleContinue, required this.isSignup});
  @override
  Widget build(BuildContext context) {
    final phoneController = useState('');
    final notifier = Provider.of<ValueNotifier<UserWrapper>>(context, listen: true);
    final isSubmitting = useState(false);
    final error = useState('');
    final accepted = useState(isSignup ? false : true);

    void handleConnectAccount() async {
      isSubmitting.value = true;
      error.value = '';

      if (phoneController.value == '0000000000') {
        isSubmitting.value = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManualLogin(onContinue: handleContinue)),
        );
        return;
      }

      Analytics.trackUberPhoneAttempt();

      if (!accepted.value) {
        error.value = 'Please accept the Terms and Conditions';
        isSubmitting.value = false;
        return;
      }

      if (phoneController.value == '') {
        error.value = 'Phone number is required.';
        isSubmitting.value = false;
        return;
      }

      if (!RegExp(r"^[0-9]{10}$").hasMatch(phoneController.value)) {
        error.value = 'Please enter a valid 10 digit phone number.';
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
            'stage': 'initial',
            'credentials': {
              'phone_number': phoneController.value,
            },
            'data_collection': true,
          }),
        );
        switch (response.statusCode) {
          case 200:
            {
              isSubmitting.value = false;
              Map<String, dynamic> body = jsonDecode(response.body);
              if (body.containsKey('event_type') && body['event_type'] == 'TypeSelectAccount') {
                List<String> emails = [];
                body['hints'].forEach((hint) => emails.add(hint['emailHint']));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UberAccountSelection(
                      sessionId: body['session_id'],
                      onContinue: handleContinue,
                      isSignup: isSignup,
                      emails: emails,
                    ),
                  ),
                );
              } else {
                if (body.containsKey('stage') && body['stage'] == 'options') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UberMethodSelection(
                        sessionId: jsonDecode(response.body)['session_id'],
                        onContinue: handleContinue,
                        isSignup: isSignup,
                      ),
                    ),
                  );
                } else if (body.containsKey('stage') && body['stage'] == 'finished') {
                  try {
                    await auth.signInWithCustomToken(jsonDecode((response.body))['user_token']);
                  } catch (ex) {
                    print('Debug: ' + ex.toString());
                    await auth.signInWithCustomToken(jsonDecode((response.body))['user_token']);
                  }
                  while (notifier.value.user == null) {
                    await Future.delayed(Duration(milliseconds: 100));
                  }

                  handleContinue();
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UberVerification(
                        sessionId: body['session_id'],
                        handleContinue: handleContinue,
                        isSignup: isSignup,
                      ),
                    ),
                  );
                }
              }
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
        InternationalPhoneNumberInput(
          selectorConfig: SelectorConfig(setSelectorButtonAsPrefixIcon: true, trailingSpace: false, leadingPadding: 70 * Style.ratioH!),
          onInputChanged: (PhoneNumber value) {
            phoneController.value = value.parseNumber();
          },
          countries: ['US'],
          textAlignVertical: TextAlignVertical.center,
          inputDecoration: Style.getInputTextDecoration('Phone Number').copyWith(
              prefix: Padding(
                padding: EdgeInsets.only(
                  right: 10,
                ),
              ),
              isCollapsed: true),
          cursorColor: Style.cursorColor,
          textStyle: Style.inputText,
          selectorTextStyle: Style.inputText,
          maxLength: 12,
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
        if (isSignup)
          Transform.translate(
            offset: Offset(-6.0, 0.0),
            child: Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.5),
                    child: Checkbox(
                      value: accepted.value,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      onChanged: (val) => accepted.value = val == null ? false : val,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'I agree to Belay’s ',
                      style: Style.h4,
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Terms and Conditions',
                            style: Style.textLink,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launch("https://ridebelay.com/terms-of-service");
                              }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(top: 50 * Style.ratioV!),
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
