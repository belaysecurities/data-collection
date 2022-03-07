import 'package:flutter/material.dart';
import '../utils/style.dart';

class Header extends StatelessWidget {
  final String subtitle;
  final String title;

  Header({
    required this.subtitle,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190 * Style.ratioV!,
      width: Style.screenWidth,
      child: Container(
          padding: EdgeInsets.only(top: 45 * Style.ratioV!),
          color: Style.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(title, style: Style.h1),
              ),
            ],
          )),
    );
  }
}
