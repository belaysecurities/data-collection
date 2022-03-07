@JS()
library pixel;

import 'package:js/js.dart';

import 'package:belay/utils/analytics.dart';
import 'package:belay/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

@JS("fbq('track', 'PageView')")
external void trackAppOpenPixel();

@JS("fbq('trackCustom', 'SignupClick')")
external void trackSignup();

@JS("fbq('trackCustom', 'SigninClick')")
external void trackSignin();

@JS("fbq('trackCustom', 'InfoClick')")
external void trackInfo();

@JS("fbq('trackCustom', 'AttemptUberSignIn')")
external void trackUberSignIn();

@JS("fbq('trackCustom', 'AttempSMS')")
external void trackSMS();

@JS("fbq('trackCustom', 'ValueNugget')")
external void trackValueNugget();

@JS("fbq('trackCustom', 'AttemptAddSession')")
external void trackAttemptAddSession();

@JS("fbq('trackCustom', 'DateRangePicked')")
external void trackCalendar();

@JS("fbq('trackCustom', 'SessionPicked')")
external void trackSession();

@JS("fbq('track', 'Purchase')")
external void trackAccepted();

@JS("fbq('trackCustom', 'PlaidClicked')")
external void trackPlaid();

@JS("fbq('track', 'AddToCart')")
external void addToCart();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Analytics.initMixpanel();
  Analytics.trackAppOpen();
  runApp(Center(child: SizedBox(width: 428, height: 926, child: App(Firebase.initializeApp()))));
  //runApp(App(Firebase.initializeApp()));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> init;

  App(this.init);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final backgroundColor = Color(0xfff5f7f8);
    final fillColor = Color(0xff53599A);
    final textColor = Color(0xFF18191F);
    final accentColorRed = Color(0xFFF97068);
    final accentColorBlue = Color(0xFFAFCBFF);

    return FutureBuilder(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }

        return MaterialApp(
          title: 'Belay',
          theme: ThemeData(
            visualDensity: VisualDensity.standard,
            scaffoldBackgroundColor: backgroundColor,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: fillColor,
                padding: EdgeInsets.symmetric(vertical: 20),
                textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: backgroundColor,
                  fontWeight: FontWeight.normal,
                ),
                shape: StadiumBorder(),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                padding: EdgeInsets.all(15),
                textStyle: textTheme.button!.copyWith(fontFamily: 'Inter', fontSize: 18, color: accentColorBlue),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: accentColorBlue, width: 2, style: BorderStyle.solid),
                ),
              ),
            ),
            accentColor: accentColorBlue,
            errorColor: accentColorRed,
            primaryColorDark: fillColor,
            textTheme: GoogleFonts.interTextTheme(textTheme).copyWith(
              headline1: GoogleFonts.inter(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              headline2: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xFF18191F),
              ),
              headline3: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF474953),
              ),
              headline4: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Color(0xff555555),
                height: 1.7,
              ),
              bodyText1: GoogleFonts.inter(
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: textColor,
              ),
              bodyText2: GoogleFonts.inter(
                fontSize: 12,
                height: 1.83,
                color: textColor,
              ),
            ),
          ),
          home: Root(),
        );
      },
    );
  }
}
