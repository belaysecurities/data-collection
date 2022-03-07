import 'package:url_launcher/url_launcher.dart';

import '../../../utils/style.dart';
import 'package:flutter/material.dart';

class DataGenerating extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 85 * Style.ratioV!),
                  child: Image(
                    image: AssetImage('images/money_person.png'),
                    width: Style.screenWidth,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 35 * Style.ratioV!, left: 30, right: 30),
                  child: Text(
                    'Your account is connected!\nStrike Acceptance will get back to you shortly.',
                    textAlign: TextAlign.left,
                    style: Style.h2!.copyWith(height: 1.5),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25 * Style.ratioV!, bottom: 15 * Style.ratioV!, left: 30, right: 30),
                  child: Text(
                    'We noticed that your income is more volatile than average. Belay protects your pay on slow days - if you\'re interested, try us out for a 1 week free trial!',
                    textAlign: TextAlign.left,
                    style: Style.p1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 40 * Style.ratioV!, left: 30, right: 30),
                  child: ElevatedButton(
                    child: Text(
                      'Try Belay pay protection for free',
                      style: Style.p1!.copyWith(color: Colors.white),
                    ),
                    style: Style.btn1,
                    onPressed: () => launch('https://app.ridebelay.com'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
