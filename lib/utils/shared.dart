import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Update {
  final String type;
  final String header;
  final String body;
  final bool show;
  Update({
    required this.type,
    required this.header,
    required this.body,
    required this.show,
  });
}

class ValueNuggetInfo {
  final double goodRate;
  final double badRate;
  final double averageRate;
  ValueNuggetInfo({
    required this.averageRate,
    required this.goodRate,
    required this.badRate,
  });
}

class Rates {
  final dayOfWeek;
  final timeOfDay;
  final baseRate;
  Rates({
    required this.dayOfWeek,
    required this.timeOfDay,
    required this.baseRate,
  });
}

bool isInteger(num value) => value is int || value == value.roundToDouble();

class Summary {
  DateTime startTime;
  DateTime endTime;
  double totalHoursDriven;
  double totalGuarantee;
  double amount;
  DateTime transactionDate;
  double points;
  int numSessions;
  double totalEarned;
  Summary({
    required this.startTime,
    required this.endTime,
    required this.amount,
    required this.transactionDate,
    required this.totalHoursDriven,
    required this.points,
    required this.totalGuarantee,
    required this.numSessions,
    required this.totalEarned,
  });
}

class Session {
  DateTime startTime;
  DateTime endTime;
  double duration;
  int dow;
  int tod;
  double progress;
  double earned;
  double points;

  Session({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.tod,
    required this.dow,
    required this.progress,
    required this.earned,
    required this.points,
  });

  Map<String, dynamic> getProperties() {
    switch (tod) {
      case 0:
        return {
          'name': 'Overnight',
          'hours': '12AM - 6AM',
          'color': Color(0xFF474953),
          'icon': Icons.auto_awesome_outlined,
        };
      case 1:
        return {
          'name': 'Morning',
          'hours': '6AM - 12PM',
          'color': Color(0xFFF97068),
          'icon': Icons.wb_sunny_outlined,
        };
      case 2:
        return {
          'name': 'Afternoon',
          'hours': '12PM - 6PM',
          'color': Color(0xFFAFCBFF),
          'icon': Icons.filter_drama_outlined,
        };
      default:
        return {
          'name': 'Evening',
          'hours': '6PM - 12AM',
          'color': Color(0xFF53599A),
          'icon': Icons.nights_stay_outlined,
        };
    }
  }
}

Session getEmptySession(DateTime date, int tod) {
  date = DateTime(date.year, date.month, date.day);
  return Session(
    startTime: date.add(
      tod == 0 ? Duration(hours: 24) : Duration(hours: tod * 6),
    ),
    endTime: date.add(
      tod == 0 ? Duration(hours: 30) : Duration(hours: (tod + 1) * 6),
    ),
    tod: tod,
    dow: tod == 0 ? date.subtract(Duration(days: 1)).weekday - 1 : date.weekday - 1,
    duration: 0,
    earned: 0,
    progress: 0,
    points: 0,
  );
}

class Day {
  DateTime startTime;
  DateTime endTime;
  Session morning;
  Session afternoon;
  Session evening;
  Session overnight;
  Day({
    required this.startTime,
    required this.endTime,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.overnight,
  });

  double totalHoursEstimated() {
    return morning.duration + afternoon.duration + evening.duration + overnight.duration;
  }

  double totalHoursDriven() {
    return morning.progress + afternoon.progress + evening.progress + overnight.progress;
  }

  double totalEarnings() {
    return morning.earned + afternoon.earned + evening.earned + overnight.earned;
  }

  List<Session> sessionsList() {
    return [morning, afternoon, evening, overnight];
  }

  double totalDriven() {
    return (morning.progress + afternoon.progress + evening.progress + overnight.progress);
  }

  double totalScheduled() {
    return (morning.duration + evening.duration + afternoon.duration + overnight.duration);
  }
}

double getSessionPay(Rates rates, Session session, bool isActual) {
  double rate = rates.dayOfWeek[session.dow] * rates.timeOfDay[session.tod] * rates.baseRate;
  return isActual ? session.progress * rate : session.duration * rate;
}

double getDayPay(Rates rates, Day day, bool isActual) {
  return getSessionPay(rates, day.morning, isActual) +
      getSessionPay(rates, day.afternoon, isActual) +
      getSessionPay(rates, day.evening, isActual) +
      getSessionPay(rates, day.overnight, isActual);
}
