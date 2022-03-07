import 'dart:async';
import 'package:belay/components/no_transition_page_route.dart';
import 'package:belay/pages/sign_up/data/data-generating.dart';
import 'package:belay/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'pages/sign_up/landing.dart';
import 'utils/shared.dart';
import 'utils/analytics.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final _users = firestore.collection('users');

class UserData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String status;
  final bool uberConnected;
  final bool plaidConnected;
  final double reward;
  final DateTime trialEndDate;
  Update? update;
  Rates? rates;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.status,
    required this.uberConnected,
    required this.plaidConnected,
    required this.reward,
    required this.trialEndDate,
  });

  void setRates(Rates rate) {
    this.rates = rate;
  }

  void setUpdate(Update update) {
    this.update = update;
  }
}

class UserWrapper {
  final bool isInitial;
  final User? user;
  final UserData? info;

  UserWrapper({
    required this.isInitial,
    this.user,
    this.info,
  });
}

class Root extends HookWidget {
  @override
  Widget build(BuildContext context) {
    Style.init(context);

    final notifier = useValueNotifier<UserWrapper>(UserWrapper(isInitial: true), []);
    useEffect(() {
      StreamSubscription? infoSub;
      final userSub = auth.userChanges().listen((user) {
        if (user == null) {
          notifier.value = UserWrapper(isInitial: false);
          infoSub?.cancel();
          infoSub = null;
        } else {
          infoSub = _users.doc(user.uid).snapshots().listen((snapshot) {
            if (!snapshot.exists) {
              return;
            }

            final String firstName = snapshot.get('first_name');
            final String lastName = snapshot.get('last_name');
            final String email = snapshot.get('email');
            final String phoneNumber = snapshot.get('phone');

            double reward;
            try {
              reward = snapshot.get('reward_points').toDouble();
            } on StateError {
              reward = 0;
            }

            String status;
            try {
              status = snapshot.get('status');
            } on StateError {
              status = 'sign_up';
            }

            bool uberConnected;
            try {
              uberConnected = snapshot.get('links.uber.status') == 'activated';
            } on StateError {
              uberConnected = false;
            }

            bool plaidConnected;
            try {
              plaidConnected = snapshot.get('plaid.status') == 'connected';
            } on StateError {
              plaidConnected = false;
            }

            DateTime trialEndDate;
            try {
              trialEndDate = snapshot.get('trial_end_date').toDate();
            } on StateError {
              trialEndDate = DateTime.now().subtract(Duration(days: 1));
            }

            Analytics.mixpanel!.identify(user.uid);

            final info = UserData(
              firstName: firstName,
              lastName: lastName,
              email: email,
              phoneNumber: phoneNumber,
              status: status,
              uberConnected: uberConnected,
              plaidConnected: plaidConnected,
              reward: reward,
              trialEndDate: trialEndDate,
            );

            try {
              Update update = Update(
                type: snapshot.get('popup.type'),
                header: snapshot.get('popup.header'),
                body: snapshot.get('popup.body'),
                show: snapshot.get('popup.show_popup'),
              );
              info.setUpdate(update);
            } on StateError {}

            try {
              Rates rate = Rates(
                dayOfWeek: [
                  snapshot.get('rates.day_multipliers.0').toDouble(),
                  snapshot.get('rates.day_multipliers.1').toDouble(),
                  snapshot.get('rates.day_multipliers.2').toDouble(),
                  snapshot.get('rates.day_multipliers.3').toDouble(),
                  snapshot.get('rates.day_multipliers.4').toDouble(),
                  snapshot.get('rates.day_multipliers.5').toDouble(),
                  snapshot.get('rates.day_multipliers.6').toDouble(),
                ],
                timeOfDay: [
                  snapshot.get('rates.time_block_multipliers.0').toDouble(),
                  snapshot.get('rates.time_block_multipliers.6').toDouble(),
                  snapshot.get('rates.time_block_multipliers.12').toDouble(),
                  snapshot.get('rates.time_block_multipliers.18').toDouble(),
                ],
                baseRate: snapshot.get('rates.base_rate.rate').toDouble() / 100,
              );
              info.setRates(rate);
            } on StateError {}

            notifier.value = UserWrapper(
              isInitial: false,
              user: user,
              info: info,
            );
          });
        }
      });

      return () {
        userSub.cancel();
        infoSub?.cancel();
      };
    }, []);

    return ChangeNotifierProvider.value(
      value: notifier,
      child: Router(),
    );
  }
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        final WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (context) => Initial();
            break;
          case '/landing':
            builder = (context) => Landing(
                  onContinue: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    Navigator.pushNamed(context, '/');
                  },
                );
            break;

          default:
            return null;
        }
        return NoTransitionPageRoute(builder: builder);
      },
    );
  }
}

class Initial extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final notifier = Provider.of<ValueNotifier<UserWrapper>>(context, listen: false);

      void onChange() {
        if (notifier.value.isInitial) {
          return;
        }

        if (notifier.value.user == null || FirebaseAuth.instance.currentUser == null) {
          Navigator.pushReplacementNamed(context, '/landing');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DataGenerating(),
            ),
          );
        }
      }

      notifier.addListener(onChange);
      Future.delayed(Duration(milliseconds: 0)).then((_) => onChange());
      return () => notifier.removeListener(onChange);
    }, []);

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class DeactivatedAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(50),
            child: Text(
              'Your account is deactivated. Please email driversupport@ridebelay.com if you want to reactivate your account.',
              textAlign: TextAlign.center,
              style: Style.h4,
            ),
          ),
        ),
      ),
    );
  }
}
