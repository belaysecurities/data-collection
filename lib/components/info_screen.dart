import 'package:flutter/material.dart';
import 'package:belay/utils/style.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  final void Function() onSubmit;
  final String imagePath;
  final String titleText;
  final String bodyText;
  final String buttonText;
  final String? link;
  final String? linkText;
  final void Function()? handleBack;

  InfoScreen({
    required this.imagePath,
    required this.onSubmit,
    required this.titleText,
    required this.bodyText,
    required this.buttonText,
    this.handleBack,
    this.link,
    this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 40),
            child: handleBack != null
                ? BackButton(
                    onPressed: handleBack,
                  )
                : null,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40 * Style.ratioV!),
                  child: Image(
                    image: AssetImage(imagePath),
                    height: 212 * Style.ratioV!,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 65 * Style.ratioV!),
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: Style.h2,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 35 * Style.ratioV!),
                  child: Text(bodyText, textAlign: TextAlign.center, style: Style.p1),
                ),
                if (linkText != null)
                  TextButton(
                    child: Text(
                      linkText!,
                      style: Style.p1!.copyWith(color: Style.purple, height: 2.5),
                    ),
                    onPressed: () => launch(link!),
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 50),
            child: ElevatedButton(
              child: Text(buttonText),
              style: Style.btn1,
              onPressed: onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
