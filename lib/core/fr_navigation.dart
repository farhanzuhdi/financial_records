import 'package:financial_records/module/dashboard/dashboard_screen.dart';
import 'package:financial_records/module/list/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FRNavigation {
  toDashboard({required BuildContext context}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const DashboardScreen(),
      ),
    );
  }

  toList(
      {required BuildContext context,
      required String month,
      required String monthName,
      required String year,
      required String categoryName}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ListScreen(
          month: month,
          monthName: monthName,
          year: year,
          categoryName: categoryName,
        ),
      ),
    );
  }

  back({required BuildContext context}) {
    Navigator.pop(context);
  }
}

var frnavigation = FRNavigation();
