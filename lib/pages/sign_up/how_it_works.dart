import 'package:belay/utils/analytics.dart';
import 'package:flutter/material.dart';
import 'package:belay/utils/style.dart';

final infoData = [
  [
    'images/app_person.png',
    'Connect to Belay\nwith your rideshare account',
    'We use your unique driving profile and aggregate regional data to generate a report for Strike Acceptance. They will then review the report for your auto loan.'
  ],
];

class HowItWorks extends StatelessWidget {
  final void Function() onContinue;
  final int stage;

  HowItWorks({
    required this.onContinue,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    stage == 0
        ? Analytics.trackHIWConnectApps()
        : stage == 1
            ? Analytics.trackHIWScheduling()
            : stage == 2
                ? Analytics.trackHIWDayToDay()
                : Analytics.trackHIWPaymentSchedule();
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, top: 20, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30 * Style.ratioV!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50 * Style.ratioV!),
                  child: Image(
                    image: AssetImage(infoData[stage][0]),
                    width: Style.screenWidth,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 45 * Style.ratioV!, left: 30, right: 30),
                  child: Text(
                    infoData[stage][1],
                    textAlign: TextAlign.left,
                    style: Style.h2!.copyWith(height: 1.6),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 25 * Style.ratioV!, left: 30, right: 30),
                  child: Text(
                    infoData[stage][2],
                    textAlign: TextAlign.left,
                    style: Style.p1,
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
