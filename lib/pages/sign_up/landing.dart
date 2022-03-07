import 'package:belay/pages/sign_up/how_it_works.dart';
import 'package:belay/pages/sign_up/uber_sso/uber_sso.dart';
import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';

import 'package:belay/utils/style.dart';

class Landing extends StatelessWidget {
  final void Function() onContinue;

  Landing({required this.onContinue});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(color: Style.purple),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 170 * Style.ratioV!,
                    ),
                    child: Image(
                      image: AssetImage('images/logo_white.png'),
                      height: 125 * Style.ratioV!,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 55 * Style.ratioV!, bottom: 15 * Style.ratioV!),
                    child: Text(
                      'Welcome to Belay',
                      textAlign: TextAlign.center,
                      style: Style.h2!.copyWith(color: Colors.white),
                    ),
                  ),
                  Text(
                    'Your ticket to first-class economic citizenship',
                    textAlign: TextAlign.center,
                    style: Style.h4!.copyWith(color: Color(0xFFE1e1e1)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50 * Style.ratioV!),
                    child: ElevatedButton(
                      style: Style.btn3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Image(
                              height: 22,
                              image: AssetImage('images/uber_logo.png'),
                            ),
                          ),
                          Text(
                            'Verify income with Uber',
                            style: Style.h2!.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Analytics.trackUberSignUpClicked();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UberSSO(
                              onContinue: onContinue,
                              isSignup: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -0.5),
              child: Container(
                height: 80 * Style.ratioV!,
                decoration: new BoxDecoration(
                  color: Style.purple,
                  borderRadius: BorderRadius.vertical(
                    bottom: new Radius.elliptical(Style.screenWidth! * 2, 100.0),
                  ),
                ),
                child: Container(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 60 * Style.ratioV!, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(
                      'Learn How it Works',
                      style: Style.p1!.copyWith(decoration: TextDecoration.underline, color: Style.purple),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HowItWorks(
                            onContinue: onContinue,
                            stage: 0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
