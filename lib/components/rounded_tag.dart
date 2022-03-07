import 'package:flutter/material.dart';

class RoundedTag extends StatelessWidget {
  final Color color;
  final String text;

  RoundedTag({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
