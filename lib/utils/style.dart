import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? ratioV;
  static double? ratioH;
  static TextStyle? h1;
  static TextStyle? h2;
  static TextStyle? h3;
  static TextStyle? h4;
  static TextStyle? p1;
  static TextStyle? p2;
  static TextStyle? inputText;
  static TextStyle? errorText;
  static TextStyle? textLink;
  static ButtonStyle? btn1;
  static ButtonStyle? btn2;
  static ButtonStyle? btn3;
  static ButtonStyle? btn4;
  static ButtonStyle? btn5;
  static Color backgroundColor = Color(0xFFF5F7F8);
  static Color purple = Color(0xff53599A);
  static Color textColor = Color(0xFF474953);
  static Color red = Color(0xFFF97068);
  static Color blue = Color(0xFFAFCBFF);
  static Color cursorColor = Color(0xFF475953);

  static void init(BuildContext context) {
    final themeData = Theme.of(context);
    mediaQueryData = MediaQuery.of(context);
    screenWidth = min(mediaQueryData!.size.width, 428);
    screenHeight = min(mediaQueryData!.size.height, 926);

    ratioV = screenHeight! / 812;
    ratioH = screenWidth! / 375;

    // Header
    h1 = themeData.textTheme.headline1!.copyWith(fontSize: 54 * ratioV!);
    h2 = themeData.textTheme.headline2!.copyWith(fontSize: 20 * ratioV!);
    h3 = themeData.textTheme.headline3!.copyWith(fontSize: 14 * ratioV!);
    h4 = themeData.textTheme.headline4!.copyWith(fontSize: 14 * ratioV!);

    // Body text
    p1 = themeData.textTheme.bodyText1!.copyWith(fontSize: 16 * ratioV!);
    p2 = themeData.textTheme.bodyText2!.copyWith(fontSize: 12 * ratioV!);
    textLink = themeData.textTheme.headline4!.copyWith(
      fontSize: 14 * ratioV!,
      decoration: TextDecoration.underline,
    );
    inputText = themeData.textTheme.bodyText1!.copyWith(fontSize: 18 * ratioV!);

    // Error text
    errorText = themeData.textTheme.bodyText2!.copyWith(color: red);

    // Buttons
    btn1 = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: purple,
        padding: EdgeInsets.symmetric(vertical: 19 * ratioV!),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.normal,
        ),
        shape: StadiumBorder(),
      ),
    ).style;
    btn2 = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: blue, width: 3.5),
        primary: blue,
        padding: EdgeInsets.symmetric(vertical: 19 * ratioV!),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ).style;

    btn3 = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 17 * ratioV!),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          color: textColor,
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ).style;

    btn4 = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: blue,
        padding: EdgeInsets.symmetric(vertical: 19 * ratioV!),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    ).style;

    btn5 = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: purple, width: 3.5),
        primary: purple,
        padding: EdgeInsets.symmetric(vertical: 19 * ratioV!),
        textStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        shape: StadiumBorder(),
      ),
    ).style;
  }

  static InputDecoration getInputTextDecoration(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          width: 0,
          style: BorderStyle.none,
        ),
      ),
      fillColor: Color(0xffE1E3E5),
      filled: true,
      hintText: hint,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 17 * ratioV!),
    );
  }
}
