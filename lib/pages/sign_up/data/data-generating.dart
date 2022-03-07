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
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 125 * Style.ratioV!),
                  child: Image(
                    image: AssetImage('images/charts.png'),
                    height: 200 * Style.ratioV!,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 65 * Style.ratioV!),
                  child: Text(
                    'Your account is connected!',
                    textAlign: TextAlign.center,
                    style: Style.h2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25 * Style.ratioV!, bottom: 15 * Style.ratioV!),
                  child: Text(
                    'We\'ve begun generating your report for Strike Acceptance and will notify you via email when it\'s sent.',
                    textAlign: TextAlign.center,
                    style: Style.p1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 55 * Style.ratioV!, bottom: 15 * Style.ratioV!),
                  child: Text(
                    'Do you stress over slow days driving Uber?',
                    textAlign: TextAlign.center,
                    style: Style.h4,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10 * Style.ratioV!),
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
